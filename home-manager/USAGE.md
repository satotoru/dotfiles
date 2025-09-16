# Home Manager ポータブル設定 使用方法

## 概要

このリポジトリのHome Manager設定は、異なるユーザーやシステム間で移植可能になっています。

## セットアップ

1. Home Manager設定を`~/.config/home-manager/`にコピー：
```bash
cp -r home-manager/* ~/.config/home-manager/
cd ~/.config/home-manager
```

## 使用方法

### 1. Flakeを使った設定管理（推奨）

#### 現在のユーザー（satotoru）で使用
```bash
home-manager switch --flake .#satotoru --extra-experimental-features nix-command --extra-experimental-features flakes
```

#### 環境変数ベースで使用
```bash
home-manager switch --flake .#env-based --impure --extra-experimental-features nix-command --extra-experimental-features flakes
```

#### 新しいユーザーを追加
1. `users/新ユーザー名.nix`を作成
2. 必要に応じて`flake.nix`の`homeConfigurations`セクションに追加

### 2. 従来の方法（--impureフラグ使用）

```bash
home-manager switch --impure -f users/env-based.nix
```

### 3. カスタマイズ例

新しいユーザー用設定ファイル作成例：

```nix
# users/myuser.nix
{ config, pkgs, ... }:

import ../home.nix {
  inherit config pkgs;
  username = "myuser";
  homeDirectory = "/home/myuser";
  extraImports = [];
}
```

## 利点

1. **移植性**: ユーザー名やホームディレクトリがハードコードされていない
2. **環境分離**: ユーザーごとに個別の設定ファイル
3. **Flake対応**: モダンなNixの機能を活用
4. **後方互換性**: `--impure`フラグでの従来の使用方法も可能

## ファイル構造

```
├── home-manager/                # Home Manager設定（~/.config/home-manager/にコピー）
│   ├── flake.nix                # Flake設定
│   ├── home.nix                 # メイン設定（パラメータ化済み）
│   ├── users/                   # ユーザー固有設定
│   │   ├── env-based.nix        # 環境変数ベース設定
│   │   ├── satotoru.nix         # satotoru用設定
│   │   └── example-user.nix     # 他ユーザー用テンプレート
│   ├── README.md                # 詳細な使用方法
│   └── USAGE.md                 # このファイル
└── 各種dotfiles/                # 既存のdotfiles
```

## 注意事項

- Flakeを使用する場合は`--extra-experimental-features nix-command --extra-experimental-features flakes`が必要
- 環境変数を使用する場合は`--impure`フラグが必須
- 新しいユーザーを追加する際は、dotfilesのパスも適切に設定してください