vim.o.background = "dark"
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "material"
local f = vim.api.nvim_get_runtime_file("colors/gruvbox-material.vim", false)[1]
if f then
  vim.cmd.source(f)
end
