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
      -- Ctrl+W N でノーマルモードに移行
      vim.keymap.set('t', '<C-w>n', '<C-\\><C-n>', opts)
      -- <Esc><Esc> でターミナルを閉じる
      vim.keymap.set('t', '<Esc><Esc>', '<cmd>ToggleTerm<cr>', opts)
    end

    -- ターミナルバッファが開かれたときにキーマッピングを設定
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
