local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets('python', {
  s('pdc', {
    t { '"""', '' },
    i(0),
    t { '', '"""' },
  }),
  s('pdp', {
    t { 'Parameters', '----------', '' },
    i(0),
  }),
  s('pdr', {
    t { 'Returns', '-------', 'out : ' },
    i(0),
  }),
  s('pdt', {
    t { 'Raises', '------', '' },
    i(0),
  }),
  s('pdn', {
    t { 'Notes', '-----', '' },
    i(0),
  }),
  s('pde', {
    t { 'Examples', '--------', '>>> ' },
    i(0),
  }),
})
