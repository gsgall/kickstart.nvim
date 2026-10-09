local function python_indentexpr(lnum)
  lnum = lnum or vim.v.lnum
  if lnum == 0 then return 0 end

  -- find the previous non-blank line
  local prevlnum = vim.fn.prevnonblank(lnum - 1)
  if prevlnum == 0 then return 0 end

  local prevline = vim.fn.getline(prevlnum)
  local prev_indent = vim.fn.indent(prevlnum)
  local sw = vim.fn.shiftwidth()

  -- strip trailing whitespace/comments for keyword checks
  local trimmed = prevline:gsub('%s+$', '')

  local indent = prev_indent

  -- increase indent if previous line ends with ':'
  -- (handles "for x in y:", "if x:", "def f():", "else:", etc.)
  if trimmed:match ':%s*$' then
    indent = prev_indent + sw

  -- decrease indent if previous line is a dedent-triggering statement
  elseif
    trimmed:match '^%s*return%f[%A]'
    or trimmed:match '^%s*pass%f[%A]'
    or trimmed:match '^%s*break%f[%A]'
    or trimmed:match '^%s*continue%f[%A]'
    or trimmed:match '^%s*raise%f[%A]'
  then
    indent = math.max(prev_indent - sw, 0)
  end

  -- current line: dedent one level if it starts with
  -- else/elif/except/finally (so they line up with their opening block)
  local curline = vim.fn.getline(lnum)
  if curline:match '^%s*else%f[%A]' or curline:match '^%s*elif%f[%A]' or curline:match '^%s*except%f[%A]' or curline:match '^%s*finally%f[%A]' then
    indent = math.max(indent - sw, 0)
  end

  return indent
end

_G.python_indentexpr = python_indentexpr

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.autoindent = true
    vim.bo.smartindent = false
    vim.bo.cindent = false
    vim.bo.indentexpr = 'v:lua.python_indentexpr(v:lnum)'
  end,
})
