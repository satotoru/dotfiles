{
  description = "Home Manager configuration for satotoru";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        # デフォルト設定（現在のユーザー）
        "satotoru" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./home.nix {
              inherit pkgs;
              config = {};
              username = "satotoru";
              homeDirectory = "/home/satotoru";
              extraImports = [];
            })
          ];
        };

        # 環境変数ベース設定（--impure必須）
        "env-based" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./users/env-based.nix
          ];
        };
      };
    };
}