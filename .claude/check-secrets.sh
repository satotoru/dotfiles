#!/usr/bin/env bash
# Publicリポジトリ公開前チェックスクリプト
# Claude Code の PreToolUse フックから呼ばれます
# git commit/push コマンドの前にステージングされた変更を自動検査します
#
# 2段階チェック:
#   BLOCK: 明確な機密情報 → 自動ブロック (exit 2)
#   WARN:  要確認情報     → ユーザーに判断を委ねる (JSON ask)

# stdin から tool_input JSON を読み取り
INPUT=$(cat)

# コマンドを抽出 (tool_input.command)
CMD=$(python3 -c "
import sys, json
try:
    data = json.loads(sys.argv[1])
    print(data.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" "$INPUT" 2>/dev/null || echo "")

# git commit または git push コマンドでなければスキップ
if ! echo "$CMD" | grep -qE 'git[[:space:]]+(commit|push)'; then
    exit 0
fi

# commit: ステージング差分、push: 未プッシュのコミット差分を取得
if echo "$CMD" | grep -qE 'git[[:space:]]+push'; then
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
    if git rev-parse "origin/$CURRENT_BRANCH" >/dev/null 2>&1; then
        DIFF=$(git diff "origin/$CURRENT_BRANCH"..HEAD --unified=0 2>/dev/null || echo "")
    else
        DIFF=$(git diff HEAD~1 HEAD --unified=0 2>/dev/null || echo "")
    fi
else
    DIFF=$(git diff --cached --unified=0 2>/dev/null || echo "")
fi

if [ -z "$DIFF" ]; then
    exit 0
fi

# 追加行のみ抽出（削除行は無視）
ADDED=$(echo "$DIFF" | grep -P "^\+" | grep -v "^+++" || true)

BLOCK_FOUND=0
BLOCK_MSGS=""
WARN_FOUND=0
WARN_MSGS=""

# 自動ブロックパターンを追加
add_block() {
    local pattern="$1"
    local description="$2"
    local matches
    matches=$(echo "$ADDED" | grep -iP "$pattern" 2>/dev/null | head -3 || true)
    if [ -n "$matches" ]; then
        BLOCK_FOUND=1
        BLOCK_MSGS="${BLOCK_MSGS}\n【${description}】\n${matches}"
    fi
}

# 要確認パターンを追加
add_warn() {
    local pattern="$1"
    local description="$2"
    local matches
    matches=$(echo "$ADDED" | grep -iP "$pattern" 2>/dev/null | head -3 || true)
    if [ -n "$matches" ]; then
        WARN_FOUND=1
        WARN_MSGS="${WARN_MSGS}\n【${description}】\n${matches}"
    fi
}

# ============================================================
# BLOCK: 明確な機密情報（自動ブロック）
# ============================================================

# クラウドサービスAPIキー
add_block 'AKIA[0-9A-Z]{16}'                             'AWS アクセスキー'
add_block 'sk-[a-zA-Z0-9]{48}'                           'OpenAI APIキー'
add_block 'sk-ant-[a-zA-Z0-9_-]{93}'                     'Anthropic APIキー'
add_block 'AIza[0-9A-Za-z_-]{35}'                        'Google API Key'

# GitHub トークン
add_block 'ghp_[a-zA-Z0-9]{36}'                          'GitHub Personal Access Token'
add_block 'ghs_[a-zA-Z0-9]{36}'                          'GitHub Actions Token'
add_block 'github_pat_[a-zA-Z0-9_]{82}'                  'GitHub Fine-grained Token'

# Slack トークン
add_block 'xoxb-[0-9]{11}-[0-9]{11}-[a-zA-Z0-9]{24}'    'Slack Bot Token'
add_block 'xoxp-[0-9]{11}-[0-9]{11}-[0-9]{12}-[a-zA-Z0-9]{32}' 'Slack User Token'

# 秘密鍵
add_block '-----BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY-----' 'プライベートキー'

# 認証情報のハードコード
add_block '(password|passwd|pwd)\s*[:=]\s*["\x27][^"\x27]{3,}["\x27]'   'パスワードの直接記述'
add_block '(secret|api_?key|access_?token|auth_?token)\s*[:=]\s*["\x27][^"\x27]{8,}["\x27]' 'APIキー/シークレット/トークン'

# 認証情報付きDB接続文字列
add_block '(mysql|postgres|postgresql|mongodb|redis|amqp)://[^@\s]+:[^@\s]+@' 'データベース接続文字列（認証情報付き）'

# ============================================================
# WARN: 要確認情報（ユーザー判断に委ねる）
# ============================================================

# プライベートIPアドレス
add_warn '(^|[^0-9.])(192\.168\.[0-9]{1,3}\.[0-9]{1,3}|10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3})([^0-9.]|$)' \
    'プライベートIPアドレス（内部ネットワーク情報の可能性）'

# 内部ホスト名
add_warn '[a-zA-Z0-9-]+\.(local|internal|corp|lan|intranet|private)\b' \
    '内部ホスト名（社内ネットワーク情報の可能性）'

# 社内・開発環境URL
add_warn 'https?://[a-zA-Z0-9._-]*(internal|intranet|corp|staging|dev\.|local)[a-zA-Z0-9._/-]*' \
    '社内/開発環境URL（非公開情報の可能性）'

# メールアドレス
add_warn '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' \
    'メールアドレス（個人情報の可能性）'

# 日本の電話番号
add_warn '(0[0-9]{1,4}[-\s]?[0-9]{1,4}[-\s]?[0-9]{3,4}|\+81[-\s]?[0-9]{1,4}[-\s]?[0-9]{1,4}[-\s]?[0-9]{3,4})' \
    '電話番号（個人情報の可能性）'

# コメントアウトされたクレデンシャル疑い
add_warn '#\s*.*(password|api_?key|secret|token|passwd)\s*[:=]\s*\S{4,}' \
    'コメントアウトされたクレデンシャル疑い'

# ============================================================
# 結果処理
# ============================================================

if [ "$BLOCK_FOUND" -eq 0 ] && [ "$WARN_FOUND" -eq 0 ]; then
    echo "✅ 機密情報は検出されませんでした。" >&2
fi

if [ "$BLOCK_FOUND" -eq 1 ]; then
    # 明確な機密情報 → 自動ブロック
    {
        echo ""
        echo "🚨 機密情報が検出されました。Publicリポジトリへのコミットをブロックします。"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e "$BLOCK_MSGS"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "機密情報を削除してから再試行してください。"
        echo ""
    } >&2
    exit 2
fi

if [ "$WARN_FOUND" -eq 1 ]; then
    # 要確認情報 → ユーザーに判断を委ねる
    WARN_TEXT=$(echo -e "$WARN_MSGS")
    HOOK_REASON="⚠️ Publicリポジトリへの公開前に確認が必要な内容が検出されました。

${WARN_TEXT}

上記の内容をPublicリポジトリにコミットしても問題ないですか？
問題あり → 「拒否」でコミットを中止し、内容を見直してください。
問題なし → 「許可」でコミットを続行してください。" \
    python3 -c "
import json, os
reason = os.environ.get('HOOK_REASON', '')
output = {
    'hookSpecificOutput': {
        'hookEventName': 'PreToolUse',
        'permissionDecision': 'ask',
        'permissionDecisionReason': reason
    }
}
print(json.dumps(output, ensure_ascii=False))
"
    exit 0
fi

exit 0
