-- ~/.config/nvim/lua/plugins/file-path-yank.lua

return {
  "file-path-yank",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  config = function()
    -- 設定
    local config = {
      clipboard_register = '+',
      notify_level = vim.log.levels.INFO,
    }

    -- 共通処理: ファイルパス取得
    local function get_file_path()
      local file_path = vim.fn.fnamemodify(vim.fn.expand('%'), ':.')
      if file_path == "" or file_path == "." then
        vim.notify("ファイルが保存されていません", vim.log.levels.WARN)
        return nil
      end
      return file_path
    end

    -- 共通処理: ヤンクと通知
    local function yank_and_notify(content)
      vim.fn.setreg(config.clipboard_register, content)
      vim.notify("ヤンクしました: " .. content, config.notify_level)
    end

    -- ファイルパスのみをヤンクする関数
    local function yank_file_path()
      local file_path = get_file_path()
      if not file_path then return end
      
      yank_and_notify(file_path)
    end

    -- ファイルパスと行番号をヤンクする関数（統合版）
    local function yank_file_path_with_lines()
      local file_path = get_file_path()
      if not file_path then return end

      -- 最後のビジュアル選択のマークを確認
      local start_mark = vim.api.nvim_buf_get_mark(0, '<')
      local end_mark = vim.api.nvim_buf_get_mark(0, '>')
      local start_line = start_mark[1]
      local end_line = end_mark[1]
      
      -- マークが無効（0）の場合は現在行を使用
      if start_line == 0 or end_line == 0 then
        local current_line = vim.fn.line('.')
        start_line = current_line
        end_line = current_line
      end
      
      local result
      if start_line == end_line then
        result = file_path .. "#L" .. start_line
      else
        result = file_path .. "#L" .. start_line .. "-L" .. end_line
      end
      
      yank_and_notify(result)
    end

    -- キーマップを設定
    vim.keymap.set("n", "<leader>yf", yank_file_path, { desc = "ファイルパスのみをヤンク" })
    vim.keymap.set("n", "<leader>yp", yank_file_path_with_lines, { desc = "ファイルパス+行番号をヤンク" })
    -- グローバル関数として公開（ビジュアルモード用）
    _G.FilePathYankVisual = function(start_line, end_line)
      local file_path = get_file_path()
      if not file_path then return end
      
      local result
      if start_line == end_line then
        result = file_path .. "#L" .. start_line
      else
        result = file_path .. "#L" .. start_line .. "-L" .. end_line
      end
      
      yank_and_notify(result)
    end

    vim.keymap.set("v", "<leader>yp", ":<C-u>lua _G.FilePathYankVisual(vim.fn.line(\"'<\"), vim.fn.line(\"'>\"))<CR>", { desc = "ファイルパス+行範囲をヤンク" })
  end,
}