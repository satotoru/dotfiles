# Neovim設定ガイドライン

## ディレクトリ構造

```
~/.config/nvim/
├── init.lua                    # エントリーポイント - コア設定とプラグインを読み込み
├── lazy-lock.json             # プラグインのロックファイル
├── lua/
│   ├── core/                   # Neovimの基本設定
│   │   ├── options.lua        # vim.opt設定
│   │   └── keymaps.lua        # キーマッピングとリーダーキー
│   ├── plugins/                # プラグイン設定 (1ファイル1プラグイン)
│   │   ├── abolish.lua        # テキスト置換
│   │   ├── ai-instruction.lua # AI指示ファイル自動保存
│   │   ├── colorscheme.lua    # カラースキーム設定
│   │   ├── commentary.lua     # コメント操作
│   │   ├── emmet.lua          # HTMLタグ展開
│   │   ├── file-path-yank.lua # ファイルパス操作
│   │   ├── fugitive.lua       # Git統合
│   │   ├── git-signs.lua      # Git差分表示
│   │   ├── goyo.lua           # 集中モード
│   │   ├── indent-guides.lua  # インデントガイド
│   │   ├── nvim-cmp.lua       # 自動補完
│   │   ├── surround.lua       # 囲み文字操作
│   │   ├── fzf-lua.lua        # ファジーファインダー
│   │   ├── toggleterm.lua     # ターミナル統合
│   │   ├── treesitter.lua     # シンタックスハイライト
│   │   ├── unimpaired.lua     # ナビゲーション
│   │   ├── which-key.lua      # キーバインドヘルプ表示
│   │   └── lsp/               # LSP関連設定
│   │       └── init.lua       # LSPプラグイン定義
│   └── lazy-setup.lua         # プラグインマネージャーのセットアップ
```

## 設定ルール

### コア設定 (`lua/core/`)
- **options.lua**: すべての `vim.opt` 設定を含む
- **keymaps.lua**: グローバルなキーマップとリーダーキーの設定
- コアファイルは最小限に保ち、単一責任に集中する

### プラグイン設定 (`lua/plugins/`)
- 1ファイル1プラグインが基本方針
- 各ファイルはlazy.nvimのプラグイン仕様テーブルを返す
- 複雑なプラグイン（LSPなど）はサブディレクトリを使用
- プラグインファイルは独自のキーマップと設定を含む自己完結型にする

### エントリーポイント (`init.lua`)
- このファイルは最小限に保つ - コア設定とプラグインセットアップのみ
- 読み込み順序: コア設定を最初に、その後プラグインマネージャー

### プラグインマネージャー (`lazy-setup.lua`)
- lazy.nvimのインストールとセットアップを処理
- `lua/plugins/` ディレクトリ内のすべてのファイルを自動読み込み
- lazy.nvimのUI設定をここで行う

## 開発ワークフロー

### 新しいプラグインの追加
1. `lua/plugins/` ディレクトリに新しいファイルを作成
2. lazy.nvimプラグイン仕様を返す
3. 設定、キーマップ、依存関係を含める
4. Neovimを再起動してインストール

### leaderキーバインドの追加
1. 各プラグインファイルで`keys`テーブルに`desc`パラメータ付きでキーマップを定義
2. `lua/plugins/which-key.lua` の`wk.add()`にキーバインド説明を追加
3. グループ化が必要な場合は`group`パラメータを使用（例: `{ "<leader>f", group = "find" }`）

### 設定の変更
1. Vimオプションは適切なコアファイルを編集
2. プラグイン固有の設定はそれぞれのプラグインファイルで行う
3. Neovimを再起動して変更をテスト

### ファイル命名規則
- 複数語のファイルは小文字とハイフンを使用
- プラグインファイルはプラグイン名と一致または関連する名前
- コアファイルは説明的な名前（options、keymaps）を使用

### Gitコミットルール
- **コミットメッセージは日本語で記述する**
- 作業単位を適切に分割してコミット
- conventional commitsの形式を使用：
  - `feat:` - 新機能追加
  - `fix:` - バグ修正
  - `chore:` - 設定ファイル更新等
  - `docs:` - ドキュメント更新
  - `refactor:` - リファクタリング

## テストコマンド

```vim
:Lazy          " プラグインステータスの確認
:Mason         " LSP/ツールマネージャー
:checkhealth   " 設定の健全性確認
```

## 現在の設定

### インストール済みプラグイン
- **tokyonight.nvim**: カラースキーム（Tokyo Night Storm）
- **fzf-lua**: ファイル/grep検索付きファジーファインダー
- **nvim-treesitter**: 強化されたシンタックスハイライト
- **mason.nvim + mason-lspconfig.nvim**: LSPサーバー自動管理
- **nvim-lspconfig**: LSP設定（lua_ls）
- **nvim-cmp**: 自動補完（LSP、スニペット、バッファ、パス、コマンドライン対応）
- **LuaSnip**: スニペットエンジン
- **vim-fugitive**: Git統合
- **gitsigns.nvim**: Git差分表示
- **vim-commentary**: コメント操作
- **vim-surround**: 囲み文字操作
- **vim-abolish**: テキスト置換
- **vim-unimpaired**: ナビゲーション
- **goyo.vim**: 集中モード
- **indent-blankline.nvim**: インデントガイド
- **emmet-vim**: HTMLタグ展開
- **toggleterm.nvim**: ターミナル統合
- **file-path-yank**: ファイルパス操作
- **ai-instruction**: AI指示ファイル自動保存
- **which-key.nvim**: キーバインドヘルプ表示

### キーマッピング
#### 基本
- リーダーキー: `<Space>`
- `<leader>?`: which-keyヘルプを表示（全キーバインド一覧）
- `<leader>e`: プロジェクトツリー（netrw）を開く
- `<C-h>/<C-l>`: ウィンドウ間移動
- `<leader><space>`: 検索開始
- `<leader>x`: スクラッチバッファを開く

#### fzf-lua
- `<leader>ff`: ファイル検索
- `<leader>fa`: 隠しファイル込み検索
- `<leader>fg`: Grep検索
- `<leader>fb`: バッファ一覧
- `<leader>fq`: Quickfix検索
- `<leader>*`: カーソル位置/選択範囲でGrep検索

#### ファイルパス操作
- `<leader>yf`: ファイルパスのみをヤンク
- `<leader>yp`: ファイルパス+行番号をヤンク

#### ターミナル
- `<leader>t`: ターミナルを切り替え

#### その他
- `<C-W>z`: 集中モード切り替え

#### 編集
- `J`/`K` (visual): 選択範囲を上下に移動
- `<S-Tab>` (insert): 逆インデント

#### Emacsライク
- `<C-f>/<C-b>`: カーソル左右移動（insert/command）
- `<C-a>/<C-e>`: 行頭/行末移動（insert/command）

#### 自動補完
- `<C-Space>`: 補完開始
- `<CR>`: 補完確定
- `<Tab>/<S-Tab>`: 補完アイテム選択、スニペット展開/ジャンプ

### コア設定
- 相対行番号付きの行番号表示
- 2スペースタブとオート展開
- スマート大文字小文字区別なし検索
- OSとのクリップボード統合
- 24bitカラーサポート