# Branch diff review — workflow, patched solution, and a build-your-own sketch

Capturing an idea: review code changes **in place**, scoped to what's changed on the
current branch — both for reviewing someone else's pulled branch and for tracking my
own in-progress work. This doc records the workflow I want, the solution achievable
today by composing plugins already in this config, the existing single-plugin options,
and what writing a dedicated plugin would look like.

Last reviewed: 2026-06-01 (Neovim 0.11 baseline).

---

## 1. The workflow

The mental model is a **"branch review mode"** I toggle on, with two use cases that
share the same machinery:

- **Reviewing a pulled branch** — fetch someone's branch, check it out, and drill
  through only the files they touched, reading changes in context rather than as a
  flat diff.
- **Tracking my own work** — while editing, keep a live picture of everything I've
  changed relative to where the branch started (the merge-base with `main`), not just
  uncommitted changes.

What the mode should do:

1. **File tree filtered to branch changes** — the explorer shows *only* the files
   changed vs the base branch, so the tree itself is the change set.
2. **Added code highlighted green, in place** — read additions inside the real buffer,
   not in a separate split.
3. **Jump block → block** — hop between changed hunks across the file.
4. **Toggle-able removals** — deletions (the "negative diff") are hidden by default but
   one keystroke away as virtual lines.
5. **Branch-relative base** — all of the above compare against the merge-base with the
   target branch (e.g. `main`), not just `HEAD` / the index.
6. **Live** — updates as I edit, so it doubles as a working aid, not just a review tool.

Base ref of record: `git merge-base HEAD main` (the commit the branch diverged from),
so renamed/rebased history doesn't pollute the change set.

---

## 2. Patched-together solution (plugins already installed)

Two plugins this config already loads cover most of the workflow with **zero new
dependencies**: `gitsigns.nvim` for in-buffer highlighting and `neo-tree.nvim` for the
filtered tree. The trick is pointing both at the same branch base.

### The two key, non-obvious settings

- **`gitsigns.change_base(base, global)`** — rebases all the in-buffer signs/highlights
  to compare against `base` instead of the index/HEAD. With `global = true` it applies
  to every buffer.
- **neo-tree `git_base`** — `:Neotree git_base=<ref>` makes the `git_status` source (and
  the filesystem source's git markers) reflect branch-vs-base instead of working-tree
  changes.

### Requirement coverage

| Requirement | How |
|---|---|
| File tree = only changed files | neo-tree `git_status` source with `git_base` set to the merge-base |
| Green adds in place | gitsigns `toggle_linehl` (`GitSignsAddLn` highlight) |
| Jump block → block | gitsigns `nav_hunk("next"/"prev")` — already mapped to `]h` / `[h` |
| Toggle removals | gitsigns `toggle_deleted` (deleted lines as virtual lines), `toggle_word_diff` |
| Branch-relative base | gitsigns `change_base(mergebase, true)` + neo-tree `git_base` |
| Live while editing | gitsigns is live by default |

### What's already wired (for reference)

`lua/plugins/gitsigns.lua` already maps, in `on_attach`:

- `]h` / `[h` → `nav_hunk("next"/"prev")`
- `<leader>hs` / `<leader>hr` / `<leader>hp` / `<leader>hb` → stage / reset / preview / blame

`lua/plugins/neo-tree.lua` maps `<leader>e` → `Neotree toggle` (filesystem source).

### The missing glue: a "branch review mode" toggle

Nothing currently computes the merge-base and points both plugins at it together. A
small command/keymap would close the gap. Sketch (not yet added — design only):

```lua
-- Compute merge-base with a target branch, then rebase gitsigns + neo-tree onto it.
local function branch_review(target)
  target = target or "main"
  local base = vim.trim(vim.fn.system({ "git", "merge-base", "HEAD", target }))
  require("gitsigns").change_base(base, true)
  require("gitsigns").toggle_linehl(true)
  vim.cmd("Neotree git_status git_base=" .. base)
end

local function branch_review_off()
  require("gitsigns").change_base(nil, true) -- back to index
  require("gitsigns").toggle_linehl(false)
end
```

Candidate keymaps (consistent with the existing `<leader>h*` hunk namespace):

- `<leader>hv` → enable branch review vs `main`
- `<leader>hV` → disable
- `<leader>hd` → `gitsigns.toggle_deleted` (reveal removals)
- `<leader>hw` → `gitsigns.toggle_word_diff`

**Pros**: no new plugins, reuses muscle memory (`]h`/`[h`), live, works for both use
cases. **Cons**: the tree and the buffer highlighting are two separate systems toggled
by one function (no shared state); neo-tree's `git_status` is a separate view from the
normal `<leader>e` filesystem tree; deletions are virtual-line only (no full red-block
inline view); changing target branch means re-running the command.

---

## 3. Existing single-plugin options

If the patched solution feels too seam-y, these get closer to "one thing that does it,"
ranked by closeness to the workflow above.

### `axkirillov/unified.nvim` — closest single match
Inline, in-buffer unified diff with its **own file tree of changed files**, diff against
**any branch/commit** (`:Unified <ref>`), hunk navigation (`next_hunk`/`prev_hunk`), and
**live `auto_refresh`**. Essentially this workflow in one package.
**Gaps vs the vision**: uses its own tree panel (not neo-tree); gutter-sign based with
`DiffAdd`/`DiffDelete` groups rather than gitsigns' green line-highlight; no documented
"hide removals" toggle.

### `echasnovski/mini.diff` — best in-place overlay
`MiniDiff.toggle_overlay()` shows adds highlighted and deletions as virtual lines in
place, with `goto_hunk` navigation and live (debounced) updates.
**Gap**: default reference is the git index — diffing against an arbitrary branch needs a
**custom source** (an `attach` fn calling `set_ref_text`), which is exactly the
merge-base glue from §2, just inside mini.diff's model.

### `sindrets/diffview.nvim` — best "pull a branch and drill" panel
`:DiffviewOpen main...HEAD` gives a file panel of every changed file; `<tab>`/`<s-tab>`
cycle through them. The canonical branch-review tool.
**Gap**: split/side-by-side diff, **not** in-place green-in-buffer; a dedicated tabpage,
not your normal editing surface.

### `esmuellert/codediff.nvim` — VSCode-style
Two-tier (line + character) highlighting, side-by-side **or** inline layouts, compares
any rev (HEAD/commit/branch/tag). Heavier; closer to a review tool than a live working
aid.

---

## 4. What writing my own would look like

The honest gap none of the above fills: **a single toggle that unifies the file-tree
filter and the in-place inline diff under one branch base**, using *my* tree (neo-tree)
and gitsigns-grade in-buffer highlighting with toggle-able removals. unified.nvim is
closest but owns its tree and lacks the toggle-deleted/green-linehl polish.

So a custom plugin is **glue, not a diff engine** — the hard part (computing diffs,
rendering signs, virtual lines) is already solved by gitsigns/mini.diff. Building a diff
algorithm from scratch would be the wrong move.

### Two viable architectures

**A. Thin orchestrator over existing plugins (recommended).**
A `branch-review.nvim` that owns *state and coordination*, delegating rendering:

- **State**: current mode on/off, target branch, resolved merge-base, whether removals
  are shown. One module-level table.
- **Base resolution**: `git merge-base HEAD <target>`; re-resolve on `BufWritePost` /
  `FocusGained` so it tracks new commits. Cache per-repo.
- **Highlighting**: delegate to gitsigns `change_base` + `toggle_linehl` + `toggle_deleted`
  (or mini.diff with a custom source set to the merge-base blob).
- **Tree**: drive neo-tree's `git_status` source with `git_base`, refreshed when the base
  changes. (neo-tree exposes a Lua API / events to refresh sources.)
- **Navigation**: reuse gitsigns `nav_hunk`; optionally add "next changed *file*" that
  walks the tree's change set and opens the next file at its first hunk — the one
  genuinely new behavior worth writing.
- **Surface**: `:BranchReview [target]`, `:BranchReviewOff`, a `toggle`, and the
  `<leader>h*` keymaps from §2. Lazy-load on the command.

Effort: small. Risk: coupled to gitsigns/neo-tree internal-ish APIs (`change_base`,
source refresh), which can shift between versions.

**B. Standalone using Neovim diff primitives.**
Compute the change set with `git diff --name-only <base>` for the tree, and render
in-buffer diffs with `vim.diff()` (built-in) → extmarks for green adds + virtual lines
for removals, navigation via a hunk list. No dependency on gitsigns/neo-tree.

Effort: medium–large (re-implements sign/virtual-line rendering and a tree UI, or a
custom neo-tree source). Payoff: fully self-contained, exactly the desired UX, no
coupling. This is "rebuild a slice of gitsigns + a neo-tree source," so only worth it if
A proves too fragile.

### Recommended path

1. Live on the **§2 patched solution** for a while — it's free and reveals what's
   actually missing.
2. If the seams bite, write **architecture A** (a thin coordinator), since it captures
   the only real gap (unified tree + in-place highlight + toggle under one branch base)
   without rebuilding solved machinery.
3. Reserve **architecture B** for if the delegated APIs prove too unstable to depend on.

### Open questions to settle before building

- Merge-base vs. direct `target..HEAD` vs. include-uncommitted — which "change set" do I
  actually want while *working* vs. while *reviewing*? (Possibly mode-dependent.)
- Should the change-set tree replace `<leader>e` or be a separate explorer?
- "Next changed file" ordering — tree order, or git-diff order?
- Multi-repo / submodule behavior.
```

> Status: design notes only. Nothing in §2's "missing glue" or §4 has been added to the
> config yet.
