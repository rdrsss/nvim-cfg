return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/format" },
      { "<leader>g", group = "github (octo)" },
      { "<leader>h", group = "git hunks" },
      { "<leader>r", group = "rename" },
    },
  },
}
