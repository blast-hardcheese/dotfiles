vim.g.mapleader = "\\"

-- Reorder tabs
-- This overwrites the default "move tab", but we have <leader>$num to jump
-- directly, as well as gt/gT to do the same thing as tt/tT
vim.api.nvim_set_keymap(
  "n",
  "tt",
  ":execute 'silent! tabmove ' . (tabpagenr()+1)<cr>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "tT",
  ":execute 'silent! tabmove ' . (tabpagenr()-2)<cr>",
  { noremap = true, silent = true }
)

-- Close all but the current tab
vim.api.nvim_set_keymap(
  "n",
  "to",
  ":tabonly<cr>",
  { noremap = true, silent = true }
)

-- Quickly zip to a tab by position
-- <leader>$n jumps to tab $n (1-indexed, <leader>0 is always the last tab)
-- https://superuser.com/questions/410982/in-vim-how-can-i-quickly-switch-between-tabs#answer-675119
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { noremap = true, silent = true })
end
vim.keymap.set('n', '<leader>0', ':tablast<cr>', { noremap = true, silent = true })


-- Replace-in-file or git grep for the word under cursor
-- http://vim.wikia.com/wiki/Search_and_replace_the_word_under_the_cursor
-- nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
-- nnoremap <Leader>g :Ggrep -w <C-r><C-w>

vim.api.nvim_set_keymap(
  "n",
  "<leader>s",
  ":%s/\\<<C-r><C-w>\\>/",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>g",
  ":Ggrep -w <C-r><C-w>",
  { noremap = true }
)

-- Set vim to yank and paste from the system clipboard
-- http://vim.wikia.com/wiki/Accessing_the_system_clipboard
vim.opt.clipboard = "unnamedplus"

-- Clear search highlighting on <CR> in normal mode
-- http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
vim.api.nvim_set_keymap(
  "n",
  "<CR>",
  ":noh<CR><CR>",
  { noremap = true, silent = true }
)

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep({
    additional_args = function()
      return {"--hidden", "--glob=!.git/"}
    end
  })
end, { desc = 'Telescope git grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

local telescope = require('telescope')
local actions = require('telescope.actions')

local action_state = require('telescope.actions.state')

-- Custom action to open multiple selections in tabs
local open_in_tabs = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if #multi_selection > 0 then
    actions.close(prompt_bufnr)
    for _, selection in ipairs(multi_selection) do
      vim.cmd("tabedit " .. selection.value)
    end
  else
    actions.select_tab(prompt_bufnr)
  end
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<tab>"] = actions.add_selection + actions.move_selection_next,
        ["<s-tab>"] = actions.remove_selection + actions.move_selection_previous,
        ["<cr>"] = open_in_tabs,
      },
      n = {
        ["<tab>"] = actions.add_selection + actions.move_selection_next,
        ["<s-tab>"] = actions.remove_selection + actions.move_selection_previous,
        ["<cr>"] = open_in_tabs,
      }
    }
  },
  extensions = {
    file_browser = {}
  }
})

-- Add file management/creation to telescope
telescope.load_extension("file_browser")
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { noremap = true })


require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    map('n', ']q', function()
        pcall(vim.cmd.cnext)
    end)
    map('n', '[q', function()
        pcall(vim.cmd.cprevious)
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hi', gitsigns.preview_hunk_inline)

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<leader>hd', gitsigns.diffthis)

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<leader>hq', gitsigns.setqflist)

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

-- nnoremap <leader>go :silent exec('Git open -b cur -l ' . line('.') . ' %')<CR>

vim.keymap.set("n", "<leader>go", ":silent exec('Git open -b cur -l ' . line('.') . ' %')<CR>", { noremap = true })
