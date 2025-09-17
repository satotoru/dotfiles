#!/bin/bash
#
# Home Manager環境を自動でセットアップするスクリプト
# 前提条件: gitがインストールされ、認証済みであること
#

# エラーが発生した場合はスクリプトを即座に終了する
set -e

# --- 変数定義 ---
# あなたのdotfilesリポジトリとクローン先ディレクトリ
# 必要に応じて変更してください
DOTFILES_REPO="git@github.com:satotoru/dotfiles.git"
DOTFILES_DIR="$HOME/ghq/github.com/satotoru/dotfiles"

# Home Managerの設定ファイルのパス
HOME_NIX_SOURCE="$DOTFILES_DIR/home.nix"
HOME_NIX_TARGET_DIR="$HOME/.config/nixpkgs"
HOME_NIX_TARGET_FILE="$HOME_NIX_TARGET_DIR/home.nix"


echo "=== 1. dotfilesリポジトリのクローンを開始します ==="
if [ -d "$DOTFILES_DIR" ]; then
  echo "リポジトリは既に存在します。スキップします: $DOTFILES_DIR"
else
  echo "クローン先: $DOTFILES_DIR"
  # ghqのディレクトリ構造に合わせて親ディレクトリを作成
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  echo "クローンが完了しました。"
fi
echo ""


echo "=== 2. Nixパッケージマネージャーのインストールを確認・実行します ==="
if command -v nix-shell &> /dev/null; then
  echo "Nixは既にインストールされています。スキップします。"
else
  echo "Nixをインストールします..."
  echo "途中でsudoパスワードの入力を求められる場合があります。"
  # マルチユーザーインストール用の公式スクリプトを実行
  curl -L https://nixos.org/nix/install | sh

  # 現在のシェルセッションでNixを有効化
  # これをしないと以降のnix-channelコマンド等が失敗する
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  echo "Nixのインストールが完了しました。"
fi
echo ""


echo "=== 3. Home Managerのインストールを確認・実行します ==="
if command -v home-manager &> /dev/null; then
  echo "Home Managerは既にインストールされています。スキップします。"
else
  echo "Home Managerをインストールします..."
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update

  # `install`は非推奨になりつつあるため、`nix-shell`経由で初期セットアップ
  # home-manager switch を初回実行するために必要
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
  nix-shell '<home-manager>' -A install
  echo "Home Managerのインストールが完了しました。"
fi
echo ""


echo "=== 4. home.nixのシンボリックリンクを作成します ==="
echo "ソース: $HOME_NIX_SOURCE"
echo "ターゲット: $HOME_NIX_TARGET_FILE"
mkdir -p "$HOME_NIX_TARGET_DIR"
# -f オプションで既存のリンクがあれば上書きする
ln -sf "$HOME_NIX_SOURCE" "$HOME_NIX_TARGET_FILE"
echo "シンボリックリンクを作成しました。"
echo ""


echo "=== 5. Home Managerで環境を構築します ==="
echo "'home-manager switch' を実行します。これには時間がかかる場合があります..."
home-manager switch
echo ""

echo "🎉 セットアップが完了しました！"
echo "新しいターミナルを開いて、環境が適用されているか確認してください。"
