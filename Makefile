up:
	docker-compose -f docker-compose.yml up -d

up_no_d:
	docker-compose -f docker-compose.yml up

restart:
	docker-compose -f docker-compose.yml restart

stop:
	docker-compose -f docker-compose.yml stop

logs:
	docker-compose logs -f
