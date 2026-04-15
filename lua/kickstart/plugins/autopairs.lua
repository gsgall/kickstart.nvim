-- autopairs
-- https://github.com/windwp/nvim-autopairs

---@module 'lazy'
---@type LazySpec
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'

    npairs.setup {
      map_c_h = true, -- Enable the <C-h> mapping
      map_c_l = true, -- Enable the <C-l> mapping
    }

    -- Custom rule for $$ in TeX documents
    npairs.add_rules {
      Rule('$', '$', { 'tex', 'latex' })
        :with_pair(function(opts)
          -- Check if we're already inside a $$ environment
          local line = opts.line
          local col = opts.col
          local inside_dollars = line:sub(1, col - 1):match '%%$' and line:sub(col):match '^%%$'
          if inside_dollars then
            -- If inside $$, don't add another $
            return false
          else
            -- If not inside $$, add another $ to make $$
            opts.char = '$$'
            return true
          end
        end)
        :with_move(function(opts) return opts.char == '$' end)
        :use_key '$',
    }
  end,
}
