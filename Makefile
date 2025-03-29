run:
	docker-compose --project-name development up -d

dev_logs:
	docker-compose --project-name development logs -f

run_production:
	docker-compose --project-name production -f docker-compose.yml -f docker-compose.prod.yml up -d

run_test:
	docker-compose --project-name test -f docker-compose.yml -f docker-compose.test.yml up -d

logs:
	docker-compose --project-name production -f docker-compose.yml -f docker-compose.prod.yml logs --follow

stop:
	docker stop app_gl db_gl adminer_gl

initialize_dev:
	@echo "Waiting for containers to be ready..."
	@while ! docker ps | grep app_gl | grep -q "Up"; do \
		echo "Waiting for app_gl container to start..."; \
		sleep 5; \
	done
	@while ! docker ps | grep db_gl | grep -q "Up"; do \
		echo "Waiting for db_gl container to start..."; \
		sleep 5; \
	done
	@echo "Waiting additional time for database to initialize..."
	@sleep 5
	@echo "Running initialization commands..."
	@docker exec -ti app_gl bash -c "rm -rf migrations && \
		flask db init && \
		flask db migrate && \
		flask db upgrade && \
		flask create-admin admin admin@gl.com 123456"
	@echo "Initialization complete!"
