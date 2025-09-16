{ config, pkgs, ... }:

# satotoru用の設定
import ../home.nix {
  inherit config pkgs;
  username = "satotoru";
  homeDirectory = "/home/satotoru";
  extraImports = [];
}