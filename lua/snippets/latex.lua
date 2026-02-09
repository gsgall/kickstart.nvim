local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local events = require 'luasnip.util.events'
-- Helper function to create a snippet with a trigger and body

ls.add_snippets('tex', {
  s('inf', { t { '\\infty' }, i(0) }),
  s('4p', { t { '4 \\pi' }, i(0) }),
  s('2p', { t { '2 \\pi' }, i(0) }),
  s('pdiff', {
    t { '\\pdiff[ ' },
    i(1),
    t { ' ]{ ' },
    i(2),
    t { ' }{ ' },
    i(3),
    t ' }',
    i(0),
  }),
  s('diff', {
    t { '\\diff[ ' },
    i(1),
    t { ' ]{ ' },
    i(2),
    t { ' }{ ' },
    i(3),
    t ' }',
    i(0),
  }),
  s('tdiff', {
    t { '\\diff{ ' },
    i(1),
    t ' }{t} ',
    i(0),
  }),
  s('tpdiff', {
    t { '\\pdiff{ ' },
    i(1),
    t ' }{t} ',
    i(0),
  }),
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
    t { '\\begin{align}', '  ' },
    i(1),
    t { '', '\\end{align}' },
    i(0),
  }),
  s('peq', {
    t { '\\begin{align*}', '  ' },
    i(1),
    t { '', '\\end{align*}' },
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
    i(0),
  }),
  s('newsec', {
    t { '\\newpage', '\\section{' },
    i(1),
    t { '}', '' },
    i(0),
  }),
  s('newssec', {
    t { '\\newpage', '\\subsection{' },
    i(1),
    t { '}', '' },
    i(0),
  }),
  s('newsssec', {
    t { '\\newpage', '\\subsubsection{' },
    i(1),
    t { '}', '' },
    i(0),
  }),
  s('beg', {
    t '\\begin{',
    i(1),
    t '}',
    t { '', '  ' },
    i(2),
    t { '', '\\end{' },
    f(function(args)
      return args[1][1]
    end, { 1 }),
    t '}',
    i(0),
  }),
  s('lrp', {
    t '\\left( ',
    i(1),
    t ' \\right)',
    i(0),
  }),
  s('lrc', {
    t '\\left\\{ ',
    i(1),
    t ' \\right\\}',
    i(0),
  }),
  s('lrb', {
    t '\\left[ ',
    i(1),
    t ' \\right]',
    i(0),
  }),
  s('lra', {
    t '\\left< ',
    i(1),
    t ' \\right>',
    i(0),
  }),
  s('olfrac', {
    t { '\\frac{ ' },
    i(1),
    t { ' }{ ' },
    i(2),
    t { ' }' },
    i(0),
  }),
  s('frac', {
    t { '\\frac{', '  ' },
    i(1),
    t { '', '}{', '  ' },
    i(2),
    t { '', '}' },
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
  s('align', {
    t { '\\begin{align}', '  ' },
    i(1),
    t { '', '\\end{align}' },
    i(0),
  }),
  s('newproblem', {
    t { '\\newpage', '\\section{}', '\\subfile{sections/p' },
    i(1, 'count'),
    t { '}', '' },
    i(0),
  }),
  s('ibp-beg', {
    t { '\\tabmethod{', '\\tabmethodstep{' },
    i(1, 'sign'),
    t { '}{' },
    i(2, 'u'),
    t { '}{' },
    i(3, 'dv'),
    t { '}' },
    i(0),
    t { '', '}' },
  }),
  s('ibpstep', {
    t { '\\tabmethodstep{' },
    i(1, 'sign'),
    t { '}{' },
    i(2, 'u'),
    t { '}{' },
    i(3, 'dv'),
    t { '}' },
    i(0),
  }),
  s('ibpstep-na', {
    t { '\\tabmethodstepnoarrow{' },
    i(1, 'sign'),
    t { '}{' },
    i(2, 'u'),
    t { '}{' },
    i(3, 'dv'),
    t { '}' },
    i(0),
  }),
  s('ibpstep-last', {
    t { '\\tabmethodlaststep{' },
    i(1, 'sign'),
    t { '}{' },
    i(2, 'u'),
    t { '}{' },
    i(3, 'dv'),
    t { '}' },
    i(0),
  }),
  s('fig', {
    t { '\\begin{figure}[H]', '  \\centering', '  \\includegraphics[' },
    i(1),
    t ']{',
    i(2),
    t { '}', '  \\caption{' },
    i(3),
    t { '}', '  \\label{fig:' },
    i(4),
    t { '}', '\\end{figure}', '' },
    i(0),
  }),
  s('subfig', {
    t { '\\begin{subfigure}[h]{' },
    i(1),
    t { '}', '  \\centering', '  \\includegraphics[' },
    i(2),
    t ']{',
    i(3),
    t { '}', '  \\caption{' },
    i(4),
    t { '}', '  \\label{fig:' },
    i(5),
    t { '}', '\\end{subfigure}', '' },
    i(0),
  }),
  s('nsubfig', {
    t { '\\begin{figure}[H]', '  \\centering', '  \\begin{subfigure}[h]{' },
    i(1),
    t { '\\textwidth}', '    \\centering', '    \\includegraphics[' },
    i(2),
    t { ']{' },
    i(3),
    t { '}', '    \\caption{' },
    i(4),
    t { '}', '    \\label{fig:' },
    i(5),
    t { '}', '  \\end{subfigure}', '  ' },
    i(6),
    t { '', '\\end{figure}', '' },
    i(0),
  }),
  s('pfig', {
    t { '\\begin{figure}[H]', '  \\centering', '  \\includegraphics[' },
    i(1),
    t ']{',
    i(2),
    t { '}', '\\end{figure}', '' },
    i(0),
  }),
  s('tab', {
    t { '\\begin{table}[H]', '  \\begin{tabu}{' },
    i(1),
    t { '}', '    ' },
    i(2),
    t { '', '    \\hline', '    \\hline', '    ' },
    i(3),
    t { '', '    \\hline', '  \\end{tabu}', '  \\caption{' },
    i(4),
    t { '}', '  \\label{tab:' },
    i(5),
    t { '}', '\\end{table}', '' },
    i(0),
  }),
  s('col', {
    t { '\\begin{columns}', '  \\column{' },
    i(1),
    t { '\\textwidth}', '  ' },
    i(2),
    t { '', '\\end{columns}' },
  }),
  s('ncol', {
    t { '\\column{' },
    i(1),
    t { '\\textwidth}', '' },
    i(0),
  }),
  s('frame', {
    t { '\\begin{frame}{' },
    i(1),
    t { '}', '' },
    t { '  \\begin{columns}', '' },
    t { '    \\column{' },
    i(2),
    t { '\\textwidth}', '      ' },
    i(3),
    t { '', '  \\end{columns}' },
    t { '', '\\end{frame}' },
    i(0),
  }),
  s('blk', {
    t { '\\begin{block}{' },
    i(1),
    t { '}', '  ' },
    i(2),
    t { '', '\\end{block}' },
    i(0),
  }),
  s('ofr', {
    t { '\\left( \\vec{r} \\,\\right)' },
    i(0),
  }),
  s('ofom', {
    t { '\\left( \\vec{\\Omega} \\,\\right)' },
    i(0),
  }),
  s('ofp', {
    t { '\\left( \\vec{p} \\,\\right)' },
    i(0),
  }),
  s('ofv', {
    t { '\\left( \\vec{v} \\,\\right)' },
    i(0),
  }),
  s('ofe', {
    t { '\\left( E \\right)' },
    i(0),
  }),
  s('ofg', {
    t { '\\left( \\Gamma \\right)' },
    i(0),
  }),
  s('oft', {
    t { '\\left( t \\right)' },
    i(0),
  }),
  s('ofnu', {
    t { '\\left( \\nu \\right)' },
    i(0),
  }),
  s('ofe', {
    t { '\\left( E \\right)' },
    i(0),
  }),
  s('ofrt', {
    t { '\\left( \\vec{r}, t\\right)' },
    i(0),
  }),
  s('ofpt', {
    t { '\\left( \\vec{p}, t\\right)' },
    i(0),
  }),
  s('ofgt', {
    t { '\\left( \\Gamma, t\\right)' },
    i(0),
  }),
  s('ofvt', {
    t { '\\left( \\vec{v}, t\\right)' },
    i(0),
  }),
  s('ofet', {
    t { '\\left( E, t\\right)' },
    i(0),
  }),
  s('ofnut', {
    t { '\\left( \\nu, t\\right)' },
    i(0),
  }),
  s('ofomt', {
    t { '\\left( \\vec{\\Omega}, t\\right)' },
    i(0),
  }),
  s('ofrvt', {
    t { '\\left( \\vec{r}, \\vec{v}, t\\right)' },
    i(0),
  }),
  s('ofrpt', {
    t { '\\left( \\vec{r}, \\vec{p}, t\\right)' },
    i(0),
  }),
  s('ofret', {
    t { '\\left( \\vec{r}, E, t\\right)' },
    i(0),
  }),
  s('ofrgt', {
    t { '\\left( \\vec{r}, \\Gamma, t\\right)' },
    i(0),
  }),
  s('ofromt', {
    t { '\\left( \\vec{r}, \\vec{\\Omega}, t\\right)' },
    i(0),
  }),
  s('ofrnut', {
    t { '\\left( \\vec{r}, \\nu, t\\right)' },
    i(0),
  }),
  s('pos', {
    t { '\\vec{r}' },
    i(0),
  }),
  s('vel', {
    t { '\\vec{v}' },
    i(0),
  }),
  s('pvec', {
    t { '\\vec{p}' },
    i(0),
  }),
  s('ppvec', {
    t { "\\vec{p}\\,'" },
    i(0),
  }),
  s('vec', {
    t { '\\vec{' },
    i(1),
    t { '}' },
    i(0),
  }),
  s('dr', {
    t { 'd^3 r' },
    i(0),
  }),
  s('dp', {
    t { 'd^3 p' },
    i(0),
  }),
  s('dg', {
    t { 'd \\Gamma' },
    i(0),
  }),
  s('dnu', {
    t { 'd \\nu' },
    i(0),
  }),
  s('dom', {
    t { 'd \\Omega' },
    i(0),
  }),
  s('grad', {
    t { '\\vec{\\nabla}' },
    i(0),
  }),
  s('vgrad', {
    t { '\\cdot \\vec{\\nabla}_{\\vec{v}}' },
    i(0),
  }),
  s('rgrad', {
    t { '\\cdot \\vec{\\nabla}_{\\vec{r}}' },
    i(0),
  }),
  s('pgrad', {
    t { '\\cdot \\vec{\\nabla}_{\\vec{p}}' },
    i(0),
  }),
  s('gam', {
    t { '\\Gamma' },
    i(0),
  }),
  s('gpup', {
    t { "\\Gamma', \\Gamma_1' \\to \\Gamma, \\Gamma_1" },
    i(0),
  }),
  s('ofgpup', {
    t { "\\left( \\Gamma', \\Gamma_1' \\to \\Gamma, \\Gamma_1 \\right)" },
    i(0),
  }),
  s('ofrgpupt', {
    t { "\\left( \\vec{r}, \\Gamma', \\Gamma_1' \\to \\Gamma, \\Gamma_1, t \\right)" },
    i(0),
  }),
  s('gupp', {
    t { "\\Gamma, \\Gamma_1 \\to \\Gamma', \\Gamma_1'" },
    i(0),
  }),
  s('ofgupp', {
    t { "\\left( \\Gamma, \\Gamma_1 \\to \\Gamma', \\Gamma_1' \\right)" },
    i(0),
  }),
  s('ofrguppt', {
    t { "\\left(\\vec{r}, \\Gamma, \\Gamma_1 \\to \\Gamma', \\Gamma_1', t \\right)" },
    i(0),
  }),
  s('ppup', {
    t { "\\vec{p}\\,' \\to \\vec{p}" },
    i(0),
  }),
  s('ofppup', {
    t { "\\left( \\vec{p}\\,' \\to \\vec{p} \\right)" },
    i(0),
  }),
  s('pupp', {
    t { "\\vec{p} \\to \\vec{p}\\,'" },
    i(0),
  }),
  s('ofpupp', {
    t { "\\left( \\vec{p} \\to \\vec{p}\\,' \\right)" },
    i(0),
  }),
  s('pen', {
    t { '\\frac{ p^2 }{ 2m }' },
    i(0),
  }),
  s('icol', {
    t { 'I_\\text{coll}' },
    i(0),
  }),
  s('inu', {
    t { 'I_{\\nu}' },
    i(0),
  }),
  s('enu', {
    t { 'E_{\\nu}' },
    i(0),
  }),
  s('knu', {
    t { '\\vkappa_{\\nu}' },
    i(0),
  }),
  s('om', {
    t { '\\vec{\\Omega}' },
    i(0),
  }),
  s('ofvec', {
    t { '\\left( \\vec{ ' },
    i(1),
    t { ' } \\,\\right)' },
    i(0),
  }),
  s('psup', {
    t { '^{( ' },
    i(1),
    t { ' )}' },
    i(0),
  }, {
    -- this function moves the start of the expansion to one character before the first character where the snippet was started
    callbacks = {
      [-1] = {
        [events.pre_expand] = function(snippet, event_args)
          local pos = vim.api.nvim_win_get_cursor(0)
          local row, col = pos[1], pos[2]
          local new_col = math.max(0, col - 1)
          vim.api.nvim_buf_set_text(0, row - 1, new_col, row - 1, col, {})
          vim.api.nvim_win_set_cursor(0, { row, new_col })
        end,
      },
    },
  }),
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tex',
  callback = function()
    ls.filetype_extend('tex', { 'latex' })
  end,
})
