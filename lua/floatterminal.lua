vim.api.nvim_set_hl(0, 'TerminalBackgroundColor', { bg = '#000000' })

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

--- Inspects the process tree to find the terminal's current directory
local function get_terminal_cwd(buf)
  local chan_id = vim.bo[buf].channel
  if chan_id <= 0 then return nil end

  local pid = vim.fn.jobpid(chan_id)
  local cmd = ''

  if vim.fn.has 'linux' == 1 then
    cmd = string.format('readlink /proc/%d/cwd', pid)
  elseif vim.fn.has 'mac' == 1 then
    cmd = string.format("lsof -p %d -a -d cwd -Fn | tail -1 | sed 's/^n//'", pid)
  else
    return nil -- Fallback for unsupported OS
  end

  local term_cwd = vim.fn.trim(vim.fn.system(cmd))
  return (term_cwd ~= '' and vim.fn.isdirectory(term_cwd) == 1) and term_cwd or nil
end

local function sync_terminal_cwd()
  if not vim.api.nvim_buf_is_valid(state.floating.buf) then return end

  local term_cwd = get_terminal_cwd(state.floating.buf)
  if term_cwd and term_cwd ~= vim.fn.getcwd() then
    -- Using the API to change directory globally
    vim.api.nvim_set_current_dir(term_cwd)
  end
end

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns)
  local height = opts.height or math.floor(vim.o.lines)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = (opts.buf and vim.api.nvim_buf_is_valid(opts.buf)) and opts.buf or vim.api.nvim_create_buf(false, true)

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.wo[win].winhighlight = 'Normal:TerminalBackgroundColor'
  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      -- Start terminal in Neovim's current directory
      vim.cmd.terminal()
    end
    -- Automatically enter insert mode when opening
    vim.cmd 'startinsert'
  else
    -- Sync directory BEFORE hiding the window
    sync_terminal_cwd()
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
vim.keymap.set('n', '<leader>ot', toggle_terminal, { desc = 'Toggle floating terminal' })
vim.keymap.set('t', '<leader>ot', toggle_terminal, { desc = 'Toggle floating terminal' })
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Terminal normal mode' })
