vim.g.detectindent_preferred_expandtab = 1
vim.g.detectindent_preferred_indent = 2

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  command = "DetectIndent"
})
