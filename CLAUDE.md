# CLAUDE.md

Guidelines for working on this Neovim configuration.

## Project Overview

Personal Neovim config using lazy.nvim as the plugin manager. All config is in Lua.

## Structure

- `init.lua` -- Entry point, loads config modules in order: options, keys, automds, lazy
- `lua/config/` -- Core settings (options, keymaps, autocommands, lazy.nvim bootstrap)
- `lua/plugins/` -- One file per plugin (or plugin group). lazy.nvim auto-imports all files in this directory.

## Conventions

- **One plugin per file** in `lua/plugins/`. The filename should match the plugin's purpose (e.g., `lsp.lua`, `cmp.lua`).
- **Lazy loading**: Plugins should lazy-load where possible using `event`, `cmd`, `keys`, or `ft`.
- **Leader key** is `<Space>`, set in `lua/config/options.lua` before lazy.nvim loads.
- **Keymaps**: Global keymaps go in `lua/config/keys.lua`. Plugin-specific keymaps go in the plugin's spec (via `keys` field or in `config`/`on_attach`).
- **LSP servers** are managed by Mason + mason-lspconfig. Add new servers to `ensure_installed` in `lua/plugins/lsp.lua`. Custom server configs get their own handler in the `handlers` table.
- **Formatters** are managed by conform.nvim in `lua/plugins/conform.lua`. Add new formatters to `formatters_by_ft`.
- **Treesitter parsers**: Add new languages to `ensure_installed` in `lua/plugins/treesitter.lua`.

## Current Language Support

- **C/C++**: clangd (LSP) + clang-format (formatter) + treesitter
- **Go**: gopls (LSP) + treesitter
- **Lua**: lua_ls (LSP, configured for Neovim API) + treesitter

## Adding a New Language

1. Add the LSP server to `ensure_installed` in `lua/plugins/lsp.lua`
2. Add a custom handler if the server needs special settings
3. Add the treesitter parser to `ensure_installed` in `lua/plugins/treesitter.lua`
4. Add a formatter to `formatters_by_ft` in `lua/plugins/conform.lua` if needed

## Style

- Keep plugin configs minimal -- prefer `opts = {}` over `config = function()` when possible
- No unnecessary abstractions or wrapper functions
- Use the `desc` field on all keymaps for which-key integration
