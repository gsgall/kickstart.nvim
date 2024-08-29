local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
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
    t { '', '\\end{equation}' },
    i(0),
  }),
  s('ilist', {
    t { '\\begin{itemize}', '  \\item ' },
    i(1),
    t { '', '\\end{itemize}' },
    i(0),
  }),
  s('elist', {
    t { '\\begin{enumerate}', '  \\item ' },
    i(1),
    t { '', '\\end{enumerate}' },
    i(0),
  }),
  s('newday', {
    t { '\\newpage', '\\section{' },
    f(function()
      return os.date '%m/%d/%Y' -- Inserts the current date in MM/DD/YYYY format
    end),
    t { '}', '\\subfile{sections/l' },
    i(1, 'count'), -- Placeholder for the subfile name
    t { '}', '' },
  }),
  s('beg', {
    t '\\begin{',
    i(1),
    t '}',
    t { '', '\t' },
    i(2),
    t { '', '\\end{' },
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t '}',
    i(0),
  }),
  s('lrp', {
    t '\\left(',
    i(1),
    t '\\right)',
    i(0),
  }),
  s('lrc', {
    t '\\left\\{',
    i(1),
    t '\\right\\}',
    i(0),
  }),
  s('lrb', {
    t '\\left[',
    i(1),
    t '\\right]',
    i(0),
  }),
  s('lra', {
    t '\\left<',
    i(1),
    t '\\right>',
    i(0),
  }),
  s('frac', {
    t { '\\frac{', '  ' },
    i(1),
    t { '', '}{', '  ' },
    i(2),
    t { '', '}', '' },
    i(0),
  }),
  s('mat', {
    t { '\\begin{bmatrix}', '  ' },
    i(1),
    t { '', '\\end{bmatrix}' },
    i(0),
  }),
  s('ip', {
    t '\\innerproduct{',
    i(1),
    t '}{',
    i(2),
    t '}',
  }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    ls.filetype_extend('tex', { 'latex' })
  end,
})
