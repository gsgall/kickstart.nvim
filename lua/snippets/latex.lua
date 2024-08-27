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
    i(0),
  }),
  s('ssec', {
    t '\\subsection{',
    i(1),
    t '}',
    i(0),
  }),
  s('sssec', {
    t '\\subsubsection{',
    i(1),
    t '}',
    i(0),
  }),
  s('eq', {
    t { '\\begin{equation}', '  ' },
    i(1),
    t { '', '\\end{equation}', '' },
    i(0),
  }),
  s('ilist', {
    t { '\\begin{itemize}', '  ' },
    i(1),
    t { '', '\\end{itemize}', '' },
    i(0),
  }),
  s('elist', {
    t { '\\begin{enumerate}', '  ' },
    i(1),
    t { '', '\\end{enumerate}', '' },
    i(0),
  }),
  s('newday', {
    t { '\\newpage', '\\section{' },
    f(function()
      return os.date '%m/%d/%Y' -- Inserts the current date in MM/DD/YYYY format
    end),
    t { '}', '\\subfile{sections/' },
    i(1, 'file'), -- Placeholder for the subfile name
    t { '}', '' },
  }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    ls.filetype_extend('tex', { 'latex' })
  end,
})
