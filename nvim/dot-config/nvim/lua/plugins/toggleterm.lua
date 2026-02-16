-- ターミナル統合 (toggleterm.nvim)
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<leader>t", "<cmd>ToggleTerm<cr>", desc = "ターミナルを切り替え" },
  },
  config = function()
    require("toggleterm").setup({
      size = 20,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = false,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- ターミナルモード用のキーマッピング
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      -- Ctrl+W <Esc> でノーマルモードに移行
      vim.keymap.set('t', '<C-w><Esc>', '<C-\\><C-n>', opts)
      -- <Esc><Esc> でターミナルを閉じる
      vim.keymap.set('t', '<Esc><Esc>', '<cmd>ToggleTerm<cr>', opts)
      -- Ctrl+W p で前のターミナル (最初なら最後へラップ)
      vim.keymap.set('t', '<C-w>p', function()
        local terms = require("toggleterm.terminal").get_all(true)
        if #terms <= 1 then return end
        local current = require("toggleterm.terminal").get(vim.b.toggle_number)
        if not current then return end
        local idx
        for i, t in ipairs(terms) do
          if t.id == current.id then idx = i; break end
        end
        local prev = idx == 1 and terms[#terms] or terms[idx - 1]
        current:close()
        prev:open()
      end, opts)
      -- Ctrl+W n で次のターミナル (最後なら最初へラップ)
      vim.keymap.set('t', '<C-w>n', function()
        local terms = require("toggleterm.terminal").get_all(true)
        if #terms <= 1 then return end
        local current = require("toggleterm.terminal").get(vim.b.toggle_number)
        if not current then return end
        local idx
        for i, t in ipairs(terms) do
          if t.id == current.id then idx = i; break end
        end
        local next_term = idx == #terms and terms[1] or terms[idx + 1]
        current:close()
        next_term:open()
      end, opts)
    end

    -- ターミナルバッファが開かれたときにキーマッピングを設定
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
