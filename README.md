# nvim-cfg

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim >= 0.11
- Xcode Command Line Tools (`xcode-select --install`) for `make` and a C compiler — needed to build telescope-fzf-native and treesitter parsers

### System dependencies

**LSP servers are installed automatically via Mason** (lua_ls, gopls, rust_analyzer, pyright, sqls, graphql, zls). The exception is **clangd**, which the config points at the Homebrew LLVM binary (`/opt/homebrew/opt/llvm/bin/clangd`) to stay version-matched with the local compiler and avoid C++20 module PCM compatibility issues.

Everything else — formatters, language runtimes invoked by those formatters, and the search tools Telescope shells out to — must be installed on the system:

| Tool | Purpose |
|------|---------|
| `neovim` | The editor itself |
| `git` | Required by lazy.nvim and gitsigns |
| `ripgrep` | Telescope live grep |
| `fd` | Telescope file finder (faster than the fallback) |
| `llvm` | Provides `clangd` and `clang-format` for C/C++ |
| `go` | Provides `gofmt`, and the Go toolchain used by gopls |
| `rust` | Provides `rustfmt` and the Rust toolchain used by rust_analyzer |
| `zig` | Provides `zig fmt` (invoked by conform's `zigfmt`) and the compiler used by zls |
| `stylua` | Lua formatter |
| `ruff` | Python formatter / import sorter |
| `sqlfluff` | SQL formatter and linter |
| `font-jetbrains-mono-nerd-font` | A Nerd Font for icons (Homebrew cask) |

Install everything with Homebrew in one shot:

```sh
brew install neovim git ripgrep fd llvm go rust zig stylua ruff sqlfluff
brew install --cask font-jetbrains-mono-nerd-font
```

After installing the Nerd Font, set it as your terminal's font.

## Installation

Back up any existing config, then clone:

```sh
git clone https://github.com/rdrsss/nvim-cfg ~/.config/nvim
```

Open Neovim and lazy.nvim will bootstrap itself and install all plugins automatically.

## Structure

```
init.lua                  -- Entry point
lua/
  config/
    options.lua           -- Editor options (tabs, search, UI, etc.)
    keys.lua              -- Global keymaps
    automds.lua           -- Autocommands
    lazy.lua              -- lazy.nvim bootstrap
  plugins/
    autopairs.lua         -- Auto-close brackets/parens/quotes
    cmp.lua               -- Completion (nvim-cmp + LuaSnip)
    colorscheme.lua       -- Colorschemes (kanagawa, rose-pine, catppuccin, gruvbox-material)
    conform.lua           -- Formatting (clang-format, gofmt, stylua, ruff, rustfmt, sqlfluff, zigfmt)
    gitsigns.lua          -- Git hunk signs and actions
    lsp.lua               -- LSP via Mason + vim.lsp.config (lua_ls, gopls, clangd, rust_analyzer, pyright, sqls, graphql, zls) + inlay hints
    lualine.lua           -- Status line
    neo-tree.lua          -- File explorer
    telescope.lua         -- Fuzzy finder (with fzf-native)
    treesitter.lua        -- Syntax highlighting
    which-key.lua         -- Keymap hints
  colors/
    gruvbox-material-{hard,medium,soft}-{dark,light}.lua  -- Gruvbox Material variants
```

## Colorschemes

The default colorscheme is **kanagawa-wave**. The following are installed and available via `:colorscheme`:

- `kanagawa-wave` (default), `kanagawa-dragon`, `kanagawa-lotus`
- `rose-pine`, `rose-pine-moon`, `rose-pine-dawn`
- `catppuccin`, `catppuccin-latte`, `catppuccin-frappe`, `catppuccin-macchiato`, `catppuccin-mocha`
- `gruvbox-material-hard-dark`, `gruvbox-material-hard-light`
- `gruvbox-material-medium-dark`, `gruvbox-material-medium-light`
- `gruvbox-material-soft-dark`, `gruvbox-material-soft-light`

The gruvbox-material variants are custom `colors/` files that set the background/contrast globals and source the upstream colorscheme directly.

## Keymaps

Leader key is `<Space>`.

### General

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-d>` / `<C-u>` | Half page down/up (centered) |
| `<leader>/` or `<Esc>` | Clear search highlight |
| `J` / `K` (visual) | Move selected lines down/up |

### Plugins

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree file explorer |
| `<leader>f` | Format buffer |

### Telescope

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Search word under cursor |
| `<leader>fb` | Buffers |
| `<leader>fo` | Recent files |
| `<leader>fs` | Document symbols (LSP) |
| `<leader>fd` | Workspace diagnostics |
| `<leader>fr` | Resume last search |
| `<leader>fh` | Help tags |

### LSP (active when a server is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>d` | Diagnostics float |
| `<leader>th` | Toggle inlay hints |

### Git (gitsigns)

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |

### Completion (insert mode)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` / `<S-Tab>` | Next / previous item |

## Language Support

| Language | LSP | Formatter | Treesitter | Inlay Hints |
|----------|-----|-----------|------------|-------------|
| C/C++ | clangd (Homebrew LLVM) | clang-format | yes | yes |
| Go | gopls | gofmt | yes | yes |
| Lua | lua_ls | stylua | yes | -- |
| Rust | rust_analyzer | rustfmt | yes | -- |
| SQL | sqls | sqlfluff | yes | -- |
| Python | pyright | ruff | yes | -- |
| Zig | zls | zigfmt (`zig fmt`) | yes | -- |
| GraphQL | graphql | -- | yes | -- |
| JS/TS | -- | -- | yes | -- |
| HTML/CSS | -- | -- | yes | -- |
| Bash | -- | -- | yes | -- |
| JSON/YAML | -- | -- | yes | -- |
| Markdown | -- | -- | yes | -- |
