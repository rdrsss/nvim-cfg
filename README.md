# nvim-cfg

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim >= 0.11
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `make` and a C compiler (for telescope-fzf-native)

### External Tools

LSP servers are installed automatically via Mason, except **clangd** which uses the Homebrew LLVM binary directly (`/opt/homebrew/opt/llvm/bin/clangd`) to stay version-matched with the compiler and avoid C++20 module PCM compatibility issues.

The following formatters/linters must be installed manually:

| Tool | Language | Install |
|------|----------|---------|
| `llvm` | C/C++ | `brew install llvm` (provides clangd, clang-format) |
| `gofmt` | Go | Included with Go (`brew install go`) |
| `stylua` | Lua | `brew install stylua` or `cargo install stylua` |
| `rustfmt` | Rust | Included with Rust (`rustup component add rustfmt`) |
| `ruff` | Python | `brew install ruff` or `pip install ruff` |
| `sqlfluff` | SQL | `pip install sqlfluff` or `brew install sqlfluff` |

To install all of the above with Homebrew in one shot (rustfmt still needs `rustup component add rustfmt`):

```sh
brew install llvm go stylua ruff sqlfluff
```

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
    conform.lua           -- Formatting (clang-format, gofmt, stylua, ruff, rustfmt, sqlfluff)
    gitsigns.lua          -- Git hunk signs and actions
    lsp.lua               -- LSP via Mason + vim.lsp.config (lua_ls, gopls, clangd, rust_analyzer, pyright, sqls) + inlay hints
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
| JS/TS | -- | -- | yes | -- |
| HTML/CSS | -- | -- | yes | -- |
| Bash | -- | -- | yes | -- |
| JSON/YAML | -- | -- | yes | -- |
| Markdown | -- | -- | yes | -- |
