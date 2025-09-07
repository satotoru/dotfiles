{ config, pkgs, ... }:

{
  # `./extra.nix` というファイルが存在する場合にのみ、その設定を読み込む。
  # これにより、環境ごとの設定を安全に分離できる。
  imports = [
    /home/satotoru/.config/home-manager/extra.nix
  ];

  home.username = "satotoru";
  home.homeDirectory = "/home/satotoru";
  # Home Managerに管理させたいパッケージをここにリストアップします。
  # このリストを編集して `home-manager switch` を実行するだけで、
  # ユーザー環境のパッケージが更新されます。
  home.packages = with pkgs; [
    # --- シェルとプロンプト ---
    zsh
    sheldon
    starship

    # --- エディタとターミナル ---
    neovim
    tmux

    # --- バージョン管理 ---
    git
    ghq

    # --- プログラミング言語とランタイム ---
    ruby
    nodejs

    # --- ユーティリティ ---
    ripgrep
    fzf
  ];

  # --- zsh設定ファイルのシンボリックリンク管理 ---
  # 既存のdotfilesリポジトリから設定ファイルのシンボリックリンクを作成します。
  # `source` のパスをあなたのdotfilesの実際のパスに置き換えてください。
  home.file = {
    # 例1: ~/.zshrc へのシンボリックリンクを作成
    ".zshrc" = {
      source = ~/ghq/github.com/satotoru/dotfiles/zsh/.zshrc;
    };

    ".gitignore_global" = {
      source = ~/ghq/github.com/satotoru/dotfiles/git/.gitignore_global;
    };

    ".gitconfig" = {
      source = ~/ghq/github.com/satotoru/dotfiles/git/.gitconfig;
    };

    ".tmux.conf" = {
      source = ~/ghq/github.com/satotoru/dotfiles/tmux/.tmux.conf;
    };

    ".config/sheldon/plugins.toml" = {
      source = ~/ghq/github.com/satotoru/dotfiles/sheldon/plugins.toml;
    };

    ".config/starship.toml" = {
      source = ~/ghq/github.com/satotoru/dotfiles/starship/starship.toml;
    };

    ".config/nvim" = {
      source = ~/ghq/github.com/satotoru/dotfiles/nvim;
    };
  };

  # home-managerのバージョンを指定します。
  # この設定により、どのマシンでも同じバージョンのhome-managerを使うことが保証され、
  # 予期せぬ挙動を防ぎます。
  home.stateVersion = "24.05"; # あなたがHome Managerを使い始めるバージョンに合わせてください

  # Home Managerにプログラムの管理を許可します。
  programs.home-manager.enable = true;
}
