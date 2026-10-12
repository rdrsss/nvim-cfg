return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  cmd = "RenderMarkdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>mt", "<cmd>RenderMarkdown buf_toggle<cr>", ft = "markdown", desc = "Toggle in-buffer markdown rendering" },
  },
  opts = {
    code = {
      enabled = true,
      style = "full",
      language_icon = true,
      language_name = true,
    },
  },
}
