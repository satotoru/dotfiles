FROM ubuntu:24.04

RUN apt-get update && apt-get install -y stow && rm -rf /var/lib/apt/lists/*

# テスト用ユーザーを作成
RUN useradd -m testuser
USER testuser
WORKDIR /home/testuser

# dotfiles をコピー
RUN mkdir -p ghq/github.com/testuser/dotfiles
COPY --chown=testuser:testuser . ghq/github.com/testuser/dotfiles/

# stow パッケージ一覧
ENV DOTFILES_PATH=/home/testuser/ghq/github.com/testuser/dotfiles

# stow を実行してシンボリックリンクを作成
RUN stow -R -v -d "$DOTFILES_PATH" -t /home/testuser zsh git tmux sheldon starship nvim claude

# シンボリックリンクを検証
# stow はツリーフォールディングを行うため、ディレクトリ単位でシンボリックリンクを作成する
# 例: .config/sheldon -> ../../ghq/.../sheldon/.config/sheldon (ディレクトリリンク)
# そのため、ファイル単位ではなくディレクトリ単位で -L チェックし、
# ファイルのアクセス可能性は -f で確認する
RUN set -e && echo "=== シンボリックリンク検証 ===" && \
    # ホーム直下のファイルリンク
    test -L /home/testuser/.zshrc && \
    echo "OK: .zshrc -> $(readlink /home/testuser/.zshrc)" && \
    test -L /home/testuser/.gitconfig && \
    echo "OK: .gitconfig -> $(readlink /home/testuser/.gitconfig)" && \
    test -L /home/testuser/.gitignore_global && \
    echo "OK: .gitignore_global -> $(readlink /home/testuser/.gitignore_global)" && \
    test -L /home/testuser/.tmux.conf && \
    echo "OK: .tmux.conf -> $(readlink /home/testuser/.tmux.conf)" && \
    # .config 配下（stow がディレクトリ単位でリンクを作成）
    test -L /home/testuser/.config/sheldon && \
    echo "OK: .config/sheldon -> $(readlink /home/testuser/.config/sheldon)" && \
    test -f /home/testuser/.config/sheldon/plugins.toml && \
    echo "OK: .config/sheldon/plugins.toml はアクセス可能" && \
    test -L /home/testuser/.config/starship.toml && \
    echo "OK: .config/starship.toml -> $(readlink /home/testuser/.config/starship.toml)" && \
    test -L /home/testuser/.config/nvim && \
    echo "OK: .config/nvim -> $(readlink /home/testuser/.config/nvim)" && \
    test -f /home/testuser/.config/nvim/init.lua && \
    echo "OK: .config/nvim/init.lua はアクセス可能" && \
    test -d /home/testuser/.config/nvim/lua && \
    echo "OK: .config/nvim/lua/ はアクセス可能" && \
    # .claude 配下（stow がディレクトリ単位でリンクを作成）
    test -L /home/testuser/.claude && \
    echo "OK: .claude -> $(readlink /home/testuser/.claude)" && \
    test -f /home/testuser/.claude/commands/AI.md && \
    echo "OK: .claude/commands/AI.md はアクセス可能" && \
    echo "=== 全てのシンボリックリンクが正常に作成されました ==="
