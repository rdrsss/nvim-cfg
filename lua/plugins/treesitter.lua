return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").install({
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
      "gomod",
      "gosum",
      "javascript",
      "typescript",
      "html",
      "css",
      "c",
      "cpp",
      "rust",
      "sql",
      "graphql",
      "zig",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
      end,
    })
  end,
}
