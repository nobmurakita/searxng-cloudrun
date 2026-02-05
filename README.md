# SearXNG on Cloud Run

Google Cloud Run にデプロイするカスタム SearXNG インスタンス。Caddy による Basic 認証付きリバースプロキシ構成。

## 構成

- **SearXNG** — ポート 8888 で動作
- **Caddy** — ポート 8080 で Basic 認証付きリバースプロキシとして動作

## 環境変数

| 変数名 | 用途 |
|--------|------|
| `SEARXNG_SECRET` | SearXNG暗号化キー |
| `BASIC_AUTH_USER` | Basic認証ユーザー名 |
| `BASIC_AUTH_PASS` | Basic認証パスワード |

### `.env` ファイルの作成

```bash
cp .env.example .env
```

### `SEARXNG_SECRET` の生成

```bash
openssl rand -hex 16
```

## ローカルで起動

```bash
docker build -t searxng . && docker run --rm -p 8080:8080 --env-file .env searxng
```

http://localhost:8080 にアクセスし、`.env` に設定した認証情報でログインします。

## Cloud Run へデプロイ

```bash
gcloud run deploy searxng \
  --source . \
  --execution-environment gen2 \
  --allow-unauthenticated \
  --startup-probe httpGet.path=/healthz \
  --env-vars-file .env \
  --region asia-northeast1 \
  --project your-project-id
```
