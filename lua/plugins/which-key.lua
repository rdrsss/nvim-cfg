return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/format" },
      { "<leader>h", group = "git hunks" },
      { "<leader>r", group = "rename" },
    },
  },
}
