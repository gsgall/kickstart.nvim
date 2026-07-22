vim.lsp.log.set_level(vim.log.levels.OFF)
-- this ensures that we remove all white space and extra newlines in a file when saving
vim.opt.inccommand = 'nosplit'
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    pcall(function() vim.cmd [[%s/\s\+$//e]] end)
    vim.fn.setpos('.', save_cursor)
  end,
})

-- This ensures that a formatter is run on the files before it is saved
vim.api.nvim_create_autocmd('BufWritePre', {
  -- uncomment in case the need to specify which files get formatted is needed
  --  pattern = { '*.cpp', '*.cc', '*.cxx', '*.c++', '*.hpp', '*.h', '*.hxx', '*.h++' },
  callback = function() vim.lsp.buf.format { async = false } end,
})

local indent_group = vim.api.nvim_create_augroup('IndentationOverrides', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = indent_group,
  -- sh covers bash/zsh, make covers Makefiles
  pattern = { 'sh', 'make', 'c', 'cpp' },
  callback = function()
    if vim.bo.filetype == 'make' then
      -- Makefiles MUST use real tabs
      vim.opt_local.expandtab = false
      vim.opt_local.shiftwidth = 4
      vim.opt_local.tabstop = 4
    elseif vim.bo.filetype == 'sh' then
      -- Bash scripts often use 2 spaces by convention
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
    else
      -- C/C++
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.tabstop = 2
    end
  end,
})

local function duplicate_content(direction)
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_win = vim.api.nvim_get_current_win()

  -- Try to move right
  vim.cmd('wincmd ' .. direction)
  local target_win = vim.api.nvim_get_current_win()

  if target_win == current_win then
    -- No window to the right, create one
    if direction == 'h' or direction == 'l' then
      vim.cmd 'vsplit'
    elseif direction == 'j' or direction == 'k' then
      vim.cmd 'split'
    end
    vim.cmd('wincmd ' .. direction)
    target_win = vim.api.nvim_get_current_win()
  end

  -- Set the same buffer and cursor position in the target window
  vim.api.nvim_win_set_buf(target_win, buf)
  vim.api.nvim_win_set_cursor(target_win, cursor)
end

vim.keymap.set('n', '<leader>vsd', function()
  duplicate_content 'l'
  vim.lsp.buf.definition()
end, { desc = 'Go to definition in a window to the right of the current one' })

vim.keymap.set('n', '<leader>hvsd', function()
  duplicate_content 'h'
  vim.lsp.buf.definition()
end, { desc = 'Go to definition in a window to the left of the current one' })

vim.keymap.set('n', '<leader>hsd', function()
  duplicate_content ''
  vim.lsp.buf.definition()
end, { desc = 'Go to definition in a window below the current one' })

vim.keymap.set('n', '<leader>khsd', function()
  duplicate_content 'k'
  vim.lsp.buf.definition()
end, { desc = 'Go to definition in a window below the current one' })
-- Duplicate current buffer into the right split and move there
vim.keymap.set('n', '<leader>dh', function() duplicate_content 'h' end, { desc = 'Duplicate buffer into a left split' })
vim.keymap.set('n', '<leader>dj', function() duplicate_content 'j' end, { desc = 'Duplicate buffer into a lower split' })
vim.keymap.set('n', '<leader>dk', function() duplicate_content 'k' end, { desc = 'Duplicate buffer into an upper split' })
vim.keymap.set('n', '<leader>dl', function() duplicate_content 'l' end, { desc = 'Duplicate buffer into a right split ' })

-- copy the current file name to the system clipboard
vim.keymap.set('n', '<leader>yf', function() vim.fn.setreg('+', vim.fn.expand '%:t') end, { desc = 'Yank filename to clipboard', nowait = true })
-- copy the current file name with the relative path from where neovim is open to the system clipboard
vim.keymap.set('n', '<leader>yr', function() vim.fn.setreg('+', vim.fn.expand '%:~:.') end, { desc = 'Yank relative path to clipboard', nowait = true })
-- copy the current file name with the absolute path from where neovim is open to the system clipboard
vim.keymap.set('n', '<leader>yp', function() vim.fn.setreg('+', vim.fn.expand '%:p') end, { desc = 'Yank full path to clipboard', nowait = true })

vim.keymap.set('n', '<leader>wh', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<leader>wl', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<leader>wj', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<leader>wk', '<C-w>K', { desc = 'Move window to the upper' })

vim.keymap.set('n', '<leader>vmf', function()
  local function feedm(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'm', false) end
  local function feed(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false) end
  feed 'df '
  feed 'f('
  feed 'F l'
  feedm '<leader>yf'
  feed 'P'
  feed 'h'
  feed '2x'
  feed 'i::<Esc>'
  feed 'f;'
  feed 'F '
  feed 'd$'
  feed 'a { return  }<Esc>'
  feedm 'Fnl:w<Enter>'
  feed 'a '
end, { desc = 'Modify a virutal const member function definition into implementation outline' })

vim.keymap.set('n', '<leader>mf', function()
  local function feedm(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'm', false) end
  local function feed(keys) vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false) end
  feed 'f('
  feed 'F l'
  feedm '<leader>yf'
  feed 'P'
  feed 'h'
  feed '2x'
  feed 'i::<esc>'
  feed 'f;x'
  feed 'a { return  }<esc>'
  feedm 'fnl:w<enter>'
  feed 'a '
end, { desc = 'modify a non virtual const member function definition into a implementation outline' })
