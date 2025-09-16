{ config, pkgs, ... }:

# 異なるユーザー用の設定例
# username と homeDirectory を適宜変更してください
import ../home.nix {
  inherit config pkgs;
  username = "example-user";
  homeDirectory = "/home/example-user";
  extraImports = [];
}