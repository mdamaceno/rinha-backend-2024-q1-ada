build:
	docker compose -f docker-compose-dev.yml down && \
	docker compose -f docker-compose-dev.yml run --rm app01 alr -n build --release && \
	docker compose build --no-cache

run:
	docker compose -f docker-compose-dev.yml down && \
	docker compose -f docker-compose-dev.yml up -d

stop:
	docker compose -f docker-compose-dev.yml down

logs:
	docker compose -f docker-compose-dev.yml logs -f
