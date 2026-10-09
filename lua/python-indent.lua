vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.bo.autoindent = true
    vim.bo.smartindent = false
    vim.bo.cindent = false
    vim.bo.indentexpr = ''
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})
