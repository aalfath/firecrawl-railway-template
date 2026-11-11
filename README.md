# Firecrawl on Railway

Start scripts and gateway config for the **Firecrawl** Railway template. Every service runs an official image pinned by digest. This repo only holds the readable source of the start commands, so you can check what the base64 strings in the template do.

| Service | Image | Start script |
|---|---|---|
| Firecrawl (public gateway) | `caddy:2.11.9-alpine@sha256:0bbb055bda6793c999bde78b1b5ce3e89f829fb031af2cf50056ea1246559fee` | [`scripts/gateway-start.sh`](scripts/gateway-start.sh) + [`Caddyfile`](Caddyfile) |
| API (API, workers, NuQ workers) | `ghcr.io/firecrawl/firecrawl:2.11.723@sha256:0f1cfc844176f536e618ab0545223c234f7e538c8e264d19622652e4e5c7f218` | [`scripts/api-start.sh`](scripts/api-start.sh) |
| Playwright | `ghcr.io/firecrawl/playwright-service:latest@sha256:eacaf2c256a6ff7fd1869e470d2969e97a037ff6c75ac01d38784d138a33f8eb` | [`scripts/playwright-start.sh`](scripts/playwright-start.sh) |
| NUQ-Postgres (`pg_cron` + queue schema) | `ghcr.io/firecrawl/nuq-postgres:latest@sha256:d719b36160eac2fcbe16dc7e7360ddb9c82c40ea5da183d07bf4a755c6a0b2ae` | [`scripts/nuq-postgres-start.sh`](scripts/nuq-postgres-start.sh) |
| RabbitMQ | `rabbitmq:3.13.7-management@sha256:e582c0bc7766f3342496d8485efb5a1df782b5ce3886ad017e2eaae442311f69` | [`scripts/rabbitmq-start.sh`](scripts/rabbitmq-start.sh) |
| Redis | Railway's Redis (`redis:8.2`) | Railway default |

## Why a gateway

Self-hosted Firecrawl doesn't check API keys unless you connect Supabase (`USE_DB_AUTHENTICATION`). So the template keeps the API on Railway's private network and puts Caddy in front of it. Caddy:

- forwards a request only if it carries `Authorization: Bearer <FIRECRAWL_API_KEY>` (or the key as `Sec-WebSocket-Protocol`, for the crawl WebSocket);
- lets `/admin/<BULL_AUTH_KEY>/queues` (the Bull queue dashboard, protected by its secret path) and `/health` through;
- answers everything else with `401`;
- refuses to start if `FIRECRAWL_API_KEY` or `BULL_AUTH_KEY` is shorter than 20 characters.

## Other notes

- The API start script waits for Postgres and RabbitMQ before starting, because Firecrawl's harness stops every process when one worker fails to connect.
- Postgres keeps its data in `/var/lib/postgresql/data/pgdata` on the volume, because initdb won't use a mount point that contains `lost+found`.
- RabbitMQ uses the fixed node name `rabbit@localhost`, so its volume stays valid when Railway changes the container hostname.

`./build-start-commands.sh` prints the exact start commands used in the template.
