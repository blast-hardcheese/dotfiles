vim.cmd [[ colorscheme solarized ]]

vim.cmd [[ set number ]]

-- Tilt config files use starlark language (bazel, etc)
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*Tiltfile",
  callback = function()
    vim.bo.filetype = "starlark"
  end,
})
