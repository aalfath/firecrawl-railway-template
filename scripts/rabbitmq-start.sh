export RABBITMQ_DEFAULT_USER="${RABBITMQ_DEFAULT_USER:-firecrawl}" RABBITMQ_NODENAME="${RABBITMQ_NODENAME:-rabbit@localhost}"; exec docker-entrypoint.sh rabbitmq-server
