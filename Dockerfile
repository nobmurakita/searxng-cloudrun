FROM searxng/searxng:2026.2.3-f7a608703

# Caddyをインストール（公式イメージからコピー）
COPY --from=caddy:2.10.2 /usr/bin/caddy /usr/bin/caddy

# 設定ファイル
COPY Caddyfile /etc/caddy/Caddyfile
COPY settings.yml /etc/searxng/settings.yml
RUN touch /etc/searxng/limiter.toml

# カスタムエントリーポイント
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ポート
EXPOSE 8080

# 起動
ENTRYPOINT ["/entrypoint.sh"]
