# nvim-cfg

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim >= 0.11
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `clang-format` (for C/C++ formatting -- install via `:MasonInstall clang-format` or `brew install clang-format`)
- `make` and a C compiler (for telescope-fzf-native)

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
    colorscheme.lua       -- Kanagawa Dragon theme
    conform.lua           -- Formatting (clang-format, gofmt)
    gitsigns.lua          -- Git hunk signs and actions
    lsp.lua               -- LSP via Mason + vim.lsp.config (lua_ls, gopls, clangd)
    lualine.lua           -- Status line
    neo-tree.lua          -- File explorer
    telescope.lua         -- Fuzzy finder (with fzf-native)
    treesitter.lua        -- Syntax highlighting
    which-key.lua         -- Keymap hints
```

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
| `gr` | References |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>d` | Diagnostics float |

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

| Language | LSP | Formatter | Treesitter |
|----------|-----|-----------|------------|
| C/C++ | clangd | clang-format | yes |
| Go | gopls | gofmt | yes |
| Lua | lua_ls | stylua | yes |
| Python | -- | -- | yes |
| JS/TS | -- | -- | yes |
| HTML/CSS | -- | -- | yes |
| Bash | -- | -- | yes |
| JSON/YAML | -- | -- | yes |
| Markdown | -- | -- | yes |
