#!/bin/bash

set -e

# 設定
USERNAME="$USER"
HOME_DIR="${1:-$HOME}"
DOTFILES_PATH="${HOME_DIR}/ghq/github.com/${USERNAME}/dotfiles"

echo "========================================="
echo "dotfiles セットアップスクリプト"
echo "========================================="
echo "ユーザー: $USERNAME"
echo "ホームディレクトリ: $HOME_DIR"
echo "dotfilesパス: $DOTFILES_PATH"
echo ""

# Homebrewがインストールされているか確認
if ! command -v brew &> /dev/null; then
    echo "エラー: Homebrewがインストールされていません"
    echo "まずHomebrewをインストールしてください"
    exit 1
fi

echo "✓ Homebrewが見つかりました"
echo ""
echo "========================================="
echo "ステップ 1: パッケージをインストール中"
echo "========================================="

# パッケージリスト
packages=(
    # シェルとプロンプト
    "zsh"
    "sheldon"
    "starship"
    # エディタとターミナルマルチプレクサ
    "neovim"
    "tmux"
    # バージョン管理
    "git"
    "ghq"
    # プログラミング言語とランタイム
    "ruby"
    "node"
    # LSP
    "lua-language-server"
    # ユーティリティ
    "ripgrep"
    "fzf"
)

for package in "${packages[@]}"; do
    if brew list "$package" &> /dev/null; then
        echo "✓ $package はすでにインストール済み"
    else
        echo "インストール中: $package"
        brew install "$package"
    fi
done

echo ""
echo "========================================="
echo "ステップ 2: シンボリックリンクを設定中"
echo "========================================="

# dotfilesディレクトリが存在するか確認
if [ ! -d "$DOTFILES_PATH" ]; then
    echo "エラー: dotfiles ディレクトリが見つかりません"
    echo "パス: $DOTFILES_PATH"
    echo "まず ghq で dotfiles リポジトリをクローンしてください"
    exit 1
fi

# シンボリックリンク設定
create_symlink() {
    local src="$1"
    local dst="$2"
    local dst_dir=$(dirname "$dst")

    if [ ! -e "$src" ]; then
        echo "⚠ ソースが見つかりません: $src (スキップ)"
        return
    fi

    # ディレクトリがなければ作成
    mkdir -p "$dst_dir"

    # 既存のファイル/リンクがあれば削除
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        echo "削除中: $dst"
        rm -rf "$dst"
    fi

    # シンボリックリンク作成
    ln -s "$src" "$dst"
    echo "✓ リンク作成: $dst -> $src"
}

# リンク定義
declare -A symlinks=(
    ["$DOTFILES_PATH/zsh/.zshrc"]="$HOME_DIR/.zshrc"
    ["$DOTFILES_PATH/git/.gitignore_global"]="$HOME_DIR/.gitignore_global"
    ["$DOTFILES_PATH/git/.gitconfig"]="$HOME_DIR/.gitconfig"
    ["$DOTFILES_PATH/tmux/.tmux.conf"]="$HOME_DIR/.tmux.conf"
    ["$DOTFILES_PATH/sheldon/plugins.toml"]="$HOME_DIR/.config/sheldon/plugins.toml"
    ["$DOTFILES_PATH/starship/starship.toml"]="$HOME_DIR/.config/starship.toml"
    ["$DOTFILES_PATH/nvim"]="$HOME_DIR/.config/nvim"
    ["$DOTFILES_PATH/claude/commands/AI.md"]="$HOME_DIR/.claude/commands/AI.md"
)

for src in "${!symlinks[@]}"; do
    dst="${symlinks[$src]}"
    create_symlink "$src" "$dst"
done

echo ""
echo "========================================="
echo "セットアップ完了！"
echo "========================================="
echo ""
echo "次のステップ:"
echo "1. シェルを再起動するか以下を実行: exec \$SHELL"
echo "2. 設定ファイルを確認して必要に応じて編集してください"
echo ""
