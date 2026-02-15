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
    # シンボリックリンク管理
    "stow"
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

# stow パッケージ一覧
stow_packages=(zsh git tmux sheldon starship nvim claude)

# stow でシンボリックリンクを作成
stow --dotfiles -R -v -d "$DOTFILES_PATH" -t "$HOME_DIR" "${stow_packages[@]}"

echo ""
echo "========================================="
echo "セットアップ完了！"
echo "========================================="
echo ""
echo "次のステップ:"
echo "1. シェルを再起動するか以下を実行: exec \$SHELL"
echo "2. 設定ファイルを確認して必要に応じて編集してください"
echo ""
