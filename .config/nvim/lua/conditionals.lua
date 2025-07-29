local M = {}

function M.has_plugin(plugin)
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/'..plugin
  local path_empty = fn.empty(fn.glob(install_path)) == 1
  return not path_empty
end

return M
