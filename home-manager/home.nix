{ config, pkgs, username ? "satotoru", homeDirectory ? "/home/satotoru", extraImports ? [], ... }:

{
  # 外部から渡されたimportsを使用（デフォルトは空）
  imports = extraImports;

  home.username = username;
  home.homeDirectory = homeDirectory;
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

    # --- 言語サーバー ---
    lua-language-server

    # --- ユーティリティ ---
    ripgrep
    fzf
  ];

  # --- zsh設定ファイルのシンボリックリンク管理 ---
  # 既存のdotfilesリポジトリから設定ファイルのシンボリックリンクを作成します。
  home.file = let
    # dotfilesリポジトリのパス（~/.config/home-managerからdotfilesへの参照）
    dotfilesPath = "${homeDirectory}/ghq/github.com/satotoru/dotfiles";
  in {
    # 例1: ~/.zshrc へのシンボリックリンクを作成
    ".zshrc" = {
      source = "${dotfilesPath}/zsh/.zshrc";
    };

    ".gitignore_global" = {
      source = "${dotfilesPath}/git/.gitignore_global";
    };

    ".gitconfig" = {
      source = "${dotfilesPath}/git/.gitconfig";
    };

    ".tmux.conf" = {
      source = "${dotfilesPath}/tmux/.tmux.conf";
    };

    ".config/sheldon/plugins.toml" = {
      source = "${dotfilesPath}/sheldon/plugins.toml";
    };

    ".config/starship.toml" = {
      source = "${dotfilesPath}/starship/starship.toml";
    };

    ".config/nvim" = {
      source = "${dotfilesPath}/nvim";
    };

    # claude
    ".claude/commands/AI.md" = {
      source = "${dotfilesPath}/claude/commands/AI.md";
    };
  };

  # home-managerのバージョンを指定します。
  # この設定により、どのマシンでも同じバージョンのhome-managerを使うことが保証され、
  # 予期せぬ挙動を防ぎます。
  home.stateVersion = "25.05";

  # Home Managerにプログラムの管理を許可します。
  programs.home-manager.enable = true;
}
