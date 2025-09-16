# Home Manager設定

このディレクトリには、異なるユーザーやシステム間で移植可能なHome Manager設定が含まれています。

## セットアップ方法

1. このディレクトリの内容を`~/.config/home-manager/`にコピー：
```bash
cp -r home-manager/* ~/.config/home-manager/
```

2. `~/.config/home-manager/`に移動：
```bash
cd ~/.config/home-manager
```

## 使用方法

### 1. Flakeを使用（推奨）

#### 現在のユーザー（satotoru）で実行
```bash
home-manager switch --flake .#satotoru --extra-experimental-features nix-command --extra-experimental-features flakes
```

#### 環境変数ベース設定
```bash
home-manager switch --flake .#env-based --impure --extra-experimental-features nix-command --extra-experimental-features flakes
```

#### 新しいユーザーを追加
1. `users/新ユーザー名.nix`ファイルを作成
2. 必要に応じて`flake.nix`の`homeConfigurations`に追加

### 2. 従来の方法（ファイル指定）

```bash
# 環境変数ベース（--impure必須）
home-manager switch --impure -f users/env-based.nix
```

## ディレクトリ構造

```
~/.config/home-manager/
├── flake.nix             # Flake設定
├── home.nix              # メイン設定（パラメータ化済み）
├── users/                # ユーザー固有設定
│   ├── env-based.nix     # 環境変数ベース設定
│   ├── satotoru.nix      # satotoru用設定
│   └── example-user.nix  # 他ユーザー用テンプレート
└── README.md             # このファイル
```

## 環境変数の制限について

Nixの純粋評価モードでは、`builtins.getEnv`は空文字列を返します。環境変数を使用する場合は必ず`--impure`フラグを付けてください。

## カスタマイズ

新しい環境やユーザー用の設定を作成する場合：

1. `users/`ディレクトリに新しい`.nix`ファイルを作成
2. `username`と`homeDirectory`を適切な値に設定
3. 必要に応じて`flake.nix`の`homeConfigurations`を更新

## dotfilesへの参照について

`home.nix`では、dotfilesリポジトリへのパスとして`${homeDirectory}/ghq/github.com/satotoru/dotfiles`を使用しています。異なるパスでdotfilesを管理している場合は、この部分を適切に修正してください。