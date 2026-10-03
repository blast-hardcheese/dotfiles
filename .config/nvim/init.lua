if not require("plugins") then
  return
end
require("keymap")
require("theme")
require("completion")

require("autorun")
require("lsp").setup()
