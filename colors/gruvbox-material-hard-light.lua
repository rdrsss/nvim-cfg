vim.o.background = "light"
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_foreground = "material"
local f = vim.api.nvim_get_runtime_file("colors/gruvbox-material.vim", false)[1]
if f then
  vim.cmd.source(f)
end
