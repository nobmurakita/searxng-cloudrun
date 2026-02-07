FROM searxng/searxng:2026.2.3-f7a608703

# Caddyをインストール（公式イメージからコピー）
COPY --from=caddy:2.10.2 /usr/bin/caddy /usr/bin/caddy

# 起動時の証明書更新をスキップ（ビルド時に最新）
RUN printf '#!/bin/sh\nexit 0\n' > /usr/sbin/update-ca-certificates

# 設定ファイル・エントリーポイント
COPY docker/ /
RUN chmod +x /entrypoint.sh

# ポート
EXPOSE 8080

# 起動
ENTRYPOINT ["/entrypoint.sh"]
