return {
  "selimacerbas/mdkite.nvim",
  dependencies = { "selimacerbas/kitehost.nvim" },
  cmd = "MdKite",
  ft = "markdown",
  keys = {
    { "<leader>mp", "<cmd>MdKite toggle<cr>", ft = "markdown", desc = "Toggle markdown preview" },
    { "<leader>mr", "<cmd>MdKite refresh<cr>", ft = "markdown", desc = "Refresh markdown preview" },
  },
  opts = {},
}
