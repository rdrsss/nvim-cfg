return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>go", "<cmd>Octo<cr>", desc = "Octo menu" },
    { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List issues" },
    { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs" },
    { "<leader>gr", "<cmd>Octo review start<cr>", desc = "Start PR review" },
    { "<leader>gS", "<cmd>Octo search<cr>", desc = "Search issues/PRs" },
  },
  opts = {
    picker = "telescope",
    enable_builtin = true,
  },
}
