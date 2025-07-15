local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- Helper function to create a snippet with a trigger and body

ls.add_snippets('cpp', {
  s('jdc', {
    t { '/**', ' * ' },
    i(1),
    t { '', ' */' },
  }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'C', 'cpp', 'c', 'h', 'hpp', 'hh', 'hxx' },
  callback = function()
    ls.filetype_extend(vim.bo.filetype, { 'cpp' })
  end,
})
