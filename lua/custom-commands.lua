-- this ensures that we remove all white space and extra newlines in a file when saving
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
