# Plugin notes & gap analysis

A reading list of things this config does *not* currently include, with enough context to decide whether each is worth adopting. Nothing here is a recommendation to install — these are options.

Last reviewed: 2026-05-17 (Neovim 0.11 baseline).

---

## Built-in features in Neovim 0.10 / 0.11 worth knowing

These don't need plugins — they're already in Neovim and just need to be enabled or used.

### Built-in commenting (`gcc` / `gc{motion}`)
Shipped in Neovim 0.10. Toggle line/selection comments using the buffer's `commentstring`. Treesitter sets `commentstring` correctly per filetype, so this works out of the box. **No plugin needed** — you can remove `Comment.nvim` or `mini.comment` from any future config.

### `vim.lsp.foldexpr` — LSP-based folding (new in 0.11)
Folds based on LSP-reported document symbols instead of indentation or syntax. Wire it up in the `LspAttach` autocmd:

```lua
if client:supports_method("textDocument/foldingRange") then
  local win = vim.api.nvim_get_current_win()
  vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  vim.wo[win][0].foldmethod = "expr"
end
```

Folds collapse classes, functions, and blocks — much more useful than syntax folding.

### `vim.lsp.completion.enable` — built-in completion (0.11)
A lightweight alternative to `nvim-cmp`. Lacks fuzzy matching, snippet integration, and source pipelines. Reasonable for minimalist configs; not a reason to ditch nvim-cmp if you like the current behavior.

### `vim.snippet.expand` — built-in snippet expansion (0.10)
Native LSP snippet expansion using `$1`, `${2:placeholder}` syntax. If you ever drop LuaSnip, this is the replacement.

### `statuscolumn`
Modern customizable sign column / number column. You can build your own gutter (folds, signs, numbers) using a `%!v:lua...` expression. Most users adopt a plugin (`snacks.statuscolumn`, `luukvbaal/statuscol.nvim`) rather than rolling their own.

### `winbar`
Per-window header bar — useful for showing breadcrumbs (filepath + LSP symbol path). Often paired with `SmiteshP/nvim-navic` or `Bekaboo/dropbar.nvim`.

### Inlay hints (already enabled in this config)
You already toggle these with `<leader>th`. To enable by default on attach, add `vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })` to the `LspAttach` callback. Currently they're off until you toggle them.

---

## High-value plugins missing from this config

Ranked roughly by value-for-cost.

### `kylechui/nvim-surround` — surround text objects
Lets you add, change, and delete surrounding pairs (quotes, brackets, tags). Effectively required for serious editing.

- `ysiw"` — surround inner word with `"`
- `cs'"` — change `'` to `"`
- `ds(` — delete surrounding parens
- visual select + `S"` — surround selection

```lua
return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {},
}
```

**Cost**: tiny. **Why install**: muscle memory pays back forever.

### `folke/flash.nvim` — fast motion
Replaces `f`/`t`/`/` for big jumps. Press `s`, type 2 characters, jump to any visible match by label.

```lua
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
    { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
  },
}
```

**Cost**: small. **Why install**: faster navigation than `Ctrl-d`/`Ctrl-u` for in-screen jumps. Some people find it indispensable; others bounce off it.

### `rafamadriz/friendly-snippets` — snippet library for LuaSnip
This config already wires LuaSnip into nvim-cmp, but nothing populates it with snippets. Adding this gives you VSCode-style snippets for every language out of the box.

```lua
-- in lua/plugins/cmp.lua dependencies:
"rafamadriz/friendly-snippets",
-- and in cmp.lua config(), add:
require("luasnip.loaders.from_vscode").lazy_load()
```

**Cost**: tiny. **Why install**: snippets are dead weight without a library.

### `nvim-treesitter/nvim-treesitter-textobjects` — function/class textobjects
Adds textobjects driven by treesitter parse trees:

- `af` / `if` — around / inside function
- `ac` / `ic` — around / inside class
- `aa` / `ia` — around / inside argument

Combine with verbs: `daf` deletes the whole function, `cif` changes its body, `vac` selects the class.

```lua
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
```

**Caveat**: this plugin still uses the legacy `nvim-treesitter.configs` API — fine for textobjects, but inconsistent with the rest of this config's modern API usage.

**Cost**: medium (extra parsers, legacy API). **Why install**: massively faster code editing once internalized.

### `lukas-reineke/indent-blankline.nvim` — indent guides
Vertical lines showing indentation levels. Pure visual aid.

```lua
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
```

**Alternative**: `echasnovski/mini.indentscope` highlights only the *current* scope (less noise).

**Cost**: tiny. **Why install**: helps with deeply-nested code.

### `folke/trouble.nvim` — diagnostics / quickfix UI
Pretty list view for diagnostics, references, LSP symbols, and quickfix. Telescope's `<leader>fd` already shows diagnostics, so this is partial overlap — but Trouble's persistent floating list works better for multi-file refactors.

```lua
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix (Trouble)" },
  },
}
```

**Cost**: small. **Why install**: nicer than telescope for sustained diagnostic work.

---

## Worth considering, situationally

### `mfussenegger/nvim-dap` — debugger
Debug Adapter Protocol client. Needs per-language adapter setup (`nvim-dap-go`, `codelldb` for Rust/C++, `debugpy` for Python). Significant config investment; only worth it if you actually use debuggers regularly. The "easy mode" plugin pair is `rcarriga/nvim-dap-ui` + `theHamsta/nvim-dap-virtual-text`.

### `MeanderingProgrammer/render-markdown.nvim` — pretty markdown rendering
Renders headings, code fences, checkboxes, callouts inline in the buffer. Worth it if you spend significant time in markdown.

### `folke/noice.nvim` — cmdline / messages / popups overhaul
Replaces the bottom-of-screen cmdline with a floating prompt, routes `:messages` and notifications through a nicer UI. Some people love it; some hit weird edge cases with plugins that print to the cmdline. Try cautiously.

### Dashboard / start screen
Options: `folke/snacks.nvim` (dashboard module), `goolord/alpha-nvim`, `nvimdev/dashboard-nvim`. Pure aesthetic.

### `windwp/nvim-ts-autotag` — auto-close HTML/JSX tags
If you do frontend work. No-op otherwise.

### `numToStr/Comment.nvim` / `echasnovski/mini.comment`
**Skip** — Neovim 0.10's built-in `gcc` / `gc{motion}` covers this.

---

## Ecosystem shifts to track

These aren't action items today, but they're directional. Worth knowing about when you next refactor.

### `Saghen/blink.cmp` is replacing `nvim-cmp`
nvim-cmp's original author archived their personal config in mid-2024 and the project shifted to maintenance mode. blink.cmp is the de facto successor:

- Written in Rust (faster fuzzy matching)
- Single plugin instead of nvim-cmp + 5 source plugins
- Simpler config

Migration is non-trivial but mechanical. Not urgent — nvim-cmp still works fine and is actively patched. If/when you decide to refactor completion, blink is the destination.

### `folke/snacks.nvim` — bundled "small utilities" plugin
Folke (lazy.nvim author) bundled many small features into one plugin: dashboard, statuscolumn, picker (telescope-alternative), indent guides, notifier, bufdelete, git utilities, scratch buffers, terminal toggles, big-file handling, lazygit integration, etc.

Some configs replace half a dozen plugins with snacks. Not for you if you prefer one-plugin-per-purpose, but worth knowing about because *a lot* of community configs are converging on it.

### `ibhagwan/fzf-lua` — telescope alternative
Faster, fewer abstractions, uses fzf directly. If you ever hit performance issues with telescope on large repos, fzf-lua is the standard escape hatch. Otherwise telescope is fine.

### `nvim-mini/mini.nvim`
Modular suite — 40+ small focused modules (`mini.surround`, `mini.pairs`, `mini.comment`, `mini.statusline`, `mini.files`, etc.). Each works standalone. A different philosophy than snacks: small modules vs. one big plugin. If you like minimalism, worth a look.

---

## AI / Copilot tools (optional, opinionated)

- **`zbirenbaum/copilot.lua`** — GitHub Copilot client. Pair with `zbirenbaum/copilot-cmp` to surface suggestions in nvim-cmp.
- **`olimorris/codecompanion.nvim`** — chat sidebar / inline edits via Anthropic/OpenAI/Ollama.
- **`yetone/avante.nvim`** — Cursor-style inline AI assistant.

Skip unless you actively want AI assistance in Neovim. All require an API key or Copilot subscription.

---

## Quick "minimal additions" recommendation

If you want to add just a few things without bloating the config, the highest value-per-line additions are:

1. `nvim-surround` (3 lines)
2. `friendly-snippets` (1 dep + 1 line)
3. `flash.nvim` (8 lines)

Each is independently useful and none of them change the rest of the config.
