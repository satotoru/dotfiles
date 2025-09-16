# Home Manager設定開発ガイドライン

## 概要

このディレクトリには、異なるユーザーやシステム間で移植可能なHome Manager設定が含まれています。環境変数ベースとFlakeベースの両方のアプローチをサポートし、設定の柔軟性と再利用性を重視しています。

## アーキテクチャ

### コアコンポーネント

1. **`home.nix`**: パラメータ化されたメイン設定
   - `username`, `homeDirectory`, `extraImports`をパラメータとして受け取る
   - dotfilesへの相対パス参照を使用
   - Pure evaluation modeに対応

2. **`flake.nix`**: Flakeベースの設定管理
   - 複数のhomeConfigurationsを定義
   - nixpkgsのバージョン固定
   - home-managerとの依存関係管理

3. **`users/`ディレクトリ**: ユーザー固有設定
   - 各ユーザー専用の設定ファイル
   - 環境変数ベース設定(`env-based.nix`)
   - テンプレートファイル(`example-user.nix`)

## 開発ルール

### 1. パラメータ化の原則

**❌ 避けるべき例:**
```nix
home.username = "satotoru";
home.homeDirectory = "/home/satotoru";
```

**✅ 推奨する例:**
```nix
{ config, pkgs, username ? "satotoru", homeDirectory ? "/home/satotoru", ... }:
{
  home.username = username;
  home.homeDirectory = homeDirectory;
}
```

### 2. パス参照の原則

**❌ 避けるべき例:**
```nix
source = /home/satotoru/dotfiles/zsh/.zshrc;
```

**✅ 推奨する例:**
```nix
source = "${homeDirectory}/ghq/github.com/satotoru/dotfiles/zsh/.zshrc";
```

### 3. Pure vs Impure Evaluation

- **Pure mode**: 通常のFlake操作、予測可能な結果
- **Impure mode**: 環境変数使用時、`--impure`フラグ必須

```nix
# Impure evaluation用
let
  username = builtins.getEnv "USER";
  homeDirectory = /. + builtins.getEnv "HOME";
in
```

## ファイル管理

### 新しいユーザー設定を追加する手順

1. **ユーザー専用ファイル作成**:
   ```nix
   # users/newuser.nix
   { config, pkgs, ... }:

   import ../home.nix {
     inherit config pkgs;
     username = "newuser";
     homeDirectory = "/home/newuser";
     extraImports = [];
   }
   ```

2. **flake.nixに追加** (オプション):
   ```nix
   homeConfigurations."newuser" = home-manager.lib.homeManagerConfiguration {
     inherit pkgs;
     modules = [
       (import ./home.nix {
         inherit pkgs;
         config = {};
         username = "newuser";
         homeDirectory = "/home/newuser";
         extraImports = [];
       })
     ];
   };
   ```

### パッケージ追加のガイドライン

1. **カテゴリ別整理**: コメントでグループ分けを維持
2. **説明の追加**: 新しいパッケージには用途をコメント
3. **依存関係確認**: 既存パッケージとの競合をチェック

```nix
home.packages = with pkgs; [
  # --- 新カテゴリ ---
  package1  # 用途の説明
  package2  # 用途の説明
];
```

## テスト手順

### 1. ローカルテスト

```bash
# 設定の構文チェック
nix flake check

# Dry-run実行
home-manager switch --flake .#設定名 --dry-run

# 環境変数ベーステスト
home-manager switch --flake .#env-based --impure --dry-run
```

### 2. Dockerでの動作確認

基本的なDockerテスト例：
```dockerfile
FROM nixos/nix:latest
COPY . /dotfiles/
WORKDIR /root/.config/home-manager
RUN cp -r /dotfiles/home-manager/* . && \
    nix --extra-experimental-features "nix-command flakes" \
    run home-manager -- switch --flake .#test --dry-run
```

## トラブルシューティング

### よくあるエラーと対処法

1. **"access to absolute path is forbidden"**
   - 原因: Pure evaluation modeで絶対パスを使用
   - 対処: `--impure`フラグまたは相対パス使用

2. **"Home directory could not be determined"**
   - 原因: 環境変数が空または未設定
   - 対処: 明示的なhomeDirectory設定

3. **"Username could not be determined"**
   - 原因: $USERが設定されていない
   - 対処: 明示的なusername設定

### デバッグコマンド

```bash
# Nix式の評価結果確認
nix-instantiate --eval -E 'builtins.getEnv "USER"'

# Flakeの出力確認
nix flake show

# 詳細なエラー情報
nix --show-trace flake check
```

## 変更時のチェックリスト

- [ ] パラメータ化が適切に行われているか
- [ ] 絶対パスを使用していないか
- [ ] 新しいパッケージのコメントは適切か
- [ ] ドキュメント（README.md, USAGE.md）は更新されているか
- [ ] 異なるユーザーでの動作テストを実施したか
- [ ] 環境変数ベース設定での動作テストを実施したか

## パフォーマンス考慮事項

- **評価時間**: 複雑なimportsは避ける
- **ダウンロード量**: 不要なパッケージは削除
- **キャッシュ活用**: 安定したnixpkgsブランチを使用