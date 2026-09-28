return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>gb',
      desc = 'Show git blame for current line',
      function()
        local blame_text = require('gitblame').get_current_blame_text()
        vim.notify(blame_text, vim.log.levels.INFO, { title = 'Git Blame' })
      end,
    },
  },
  opts = {
    enabled = true,
    display_virtual_text = false,
    message_template = '<author> • <date> • <sha>\n<summary>',
    date_format = '%m-%d-%Y',
    virtual_text_column = 1,
  },
}
