{ config, pkgs, ... }:

# 環境変数ベースの設定
# 使用方法: home-manager switch --flake .#env-based --impure
let
  username = builtins.getEnv "USER";
  homeDirectory = /. + builtins.getEnv "HOME";
  # --impure使用時のみextra.nixをインポート
  extraConfig = "${builtins.getEnv "HOME"}/.config/home-manager/extra.nix";
  extraImports = if builtins.pathExists extraConfig then [ extraConfig ] else [];
in
import ../home.nix {
  inherit config pkgs username homeDirectory extraImports;
}