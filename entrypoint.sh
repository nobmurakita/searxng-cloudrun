#!/bin/sh
set -e

# SIGTERM/SIGINTで停止
cleanup() {
    kill "$SEARXNG_PID" "$CADDY_PID" 2>/dev/null || true
    exit 0
}
trap cleanup TERM INT

# Basic認証環境変数チェック
if [ -z "$BASIC_AUTH_USER" ] || [ -z "$BASIC_AUTH_PASS" ]; then
    echo "ERROR: BASIC_AUTH_USER and BASIC_AUTH_PASS must be set" >&2
    exit 1
fi

# Basic認証のパスワードをハッシュ化
export BASIC_AUTH_PASS_HASH=$(printf '%s\n' "$BASIC_AUTH_PASS" | caddy hash-password)
unset BASIC_AUTH_PASS

# SearXNGをバックグラウンドで起動（ポート8888）
export GRANIAN_HOST=127.0.0.1
export GRANIAN_PORT=8888
/usr/local/searxng/entrypoint.sh &
SEARXNG_PID=$!

# Caddyをバックグラウンドで起動
caddy run --config /etc/caddy/Caddyfile &
CADDY_PID=$!

# どちらかのプロセスが終了したらコンテナを停止
while kill -0 "$SEARXNG_PID" 2>/dev/null && kill -0 "$CADDY_PID" 2>/dev/null; do
    sleep 1
done
echo "ERROR: A process exited unexpectedly" >&2
kill "$SEARXNG_PID" "$CADDY_PID" 2>/dev/null || true
exit 1
