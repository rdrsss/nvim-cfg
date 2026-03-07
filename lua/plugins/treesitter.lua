return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "python",
        "go",
        "javascript",
        "typescript",
        "html",
        "css",
        "c",
        "cpp",
        "rust",
        "sql",
      },
    })
  end,
}
