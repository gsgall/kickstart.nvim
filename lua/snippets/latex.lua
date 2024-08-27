local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt

-- Helper function to create a snippet with a trigger and body

ls.add_snippets('tex', {
  s('sec', {
    t '\\section{',
    i(1),
    t '}',
    i(2),
  }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    ls.filetype_extend('tex', { 'latex' })
  end,
})
