#!/bin/bash
# PreToolUse hook: git commit / git push の前に機密情報を自動スキャンする

input=$(cat)

# git commit または git push を含むBashコマンドのみ対象
command=$(echo "$input" | jq -r '.tool_input.command // ""')
if ! echo "$command" | grep -qE 'git (commit|push)'; then
  exit 0
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

# commitの場合はステージング差分、pushの場合は最新コミット差分をスキャン
if echo "$command" | grep -q 'git commit'; then
  diff_target=$(git diff --cached 2>/dev/null)
else
  diff_target=$(git diff HEAD~1 HEAD 2>/dev/null)
fi

if [[ -z "$diff_target" ]]; then
  exit 0
fi

# 追加行（+で始まる行）のみを対象に機密情報パターンを検索
secrets_found=$(echo "$diff_target" | grep '^+' | grep -v '^+++' | grep -iE \
  'AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]+|ghs_[a-zA-Z0-9]+|github_pat_[a-zA-Z0-9_]+|xoxb-[a-zA-Z0-9-]+|xoxp-[a-zA-Z0-9-]+|AIza[a-zA-Z0-9_-]{35}|sk-ant-[a-zA-Z0-9-]+|BEGIN (RSA |EC |DSA )?PRIVATE KEY|password\s*[:=]\s*["'"'"'][^"'"'"']{4,}["'"'"']|secret\s*[:=]\s*["'"'"'][^"'"'"']{4,}["'"'"']|token\s*[:=]\s*["'"'"'][^"'"'"']{4,}["'"'"']|mysql://[^@\s]+@|postgres://[^@\s]+@|mongodb\+?srv?://[^@\s]+@' \
  2>/dev/null)

if [[ -n "$secrets_found" ]]; then
  echo "🚨 機密情報が検出されました。コマンドを中止します: $command" >&2
  echo "" >&2
  echo "$secrets_found" >&2
  echo "" >&2
  echo "対処: 環境変数への移行、または .gitignore への追加を検討してください。" >&2
  exit 2
fi

exit 0
