export PORT="${PORT:-8080}" MAX_CONCURRENT_PAGES="${MAX_CONCURRENT_PAGES:-10}"; exec docker-entrypoint.sh pnpm start
