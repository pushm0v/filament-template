SHELL    = /bin/bash
ARGUMENT = $(arg)
STEP	 = $(step)
VERSION               = $(shell git describe --always --tags)
GIT_COMMIT            = $(shell git rev-parse HEAD)
GIT_DIRTY             = $(shell test -n "`git status --porcelain`" && echo "+CHANGES" || true)
BUILD_DATE            = $(shell date '+%Y-%m-%d-%H:%M:%S')
EXEC_APP = docker-compose exec -it app
DOCKER_BUILD = docker buildx build
ORG_NAME = app-name
REPO_NAME = docker.io
API_NAME = app-name-api
SERVICE_NAME = core

.PHONY: default
default: help

.PHONY: help
help:
	@echo 'Management commands docker:'
	@echo
	@echo 'Usage:'
	@echo '    make shellapp                                     Execute shell in app container.'
	@echo '    make logsall                                      Following log for all container.'
	@echo


.PHONY: run
run:
	docker-compose up -d

.PHONY: shellapp
shellapp:
	${EXEC_APP} /bin/bash

.PHONY: logsall
logsall:
	docker-compose logs -f

.PHONY: migratenew
migratenew:
	${EXEC_APP} php artisan make:migration ${ARGUMENT}

.PHONY: migrateup
migrateup:
	${EXEC_APP} php artisan migrate

.PHONY: migratedown
migratedown:
	${EXEC_APP} php artisan migrate:rollback --step=${STEP}

.PHONY: configclear
configclear:
	${EXEC_APP} php artisan config:clear

.PHONY: createuser
createuser:
	${EXEC_APP} php artisan make:filament-user

.PHONY: allseeder
allseeder:
	${EXEC_APP} php artisan db:seed

.PHONY: seeder
seeder:
	${EXEC_APP} php artisan db:seed --class=${ARGUMENT}

.PHONY: resource
resource:
	${EXEC_APP} php artisan make:filament-resource ${ARGUMENT} --generate

.PHONY: exec
exec:
	${EXEC_APP} ${ARGUMENT}

.PHONY: yarnrun
yarnrun:
	${EXEC_APP} yarn run build

.PHONY: dropalltables
dropalltables:
	${EXEC_APP} php artisan db:wipe --force

.PHONY: command
command:
	${EXEC_APP} php artisan app:${ARGUMENT}

.PHONY: queue
queue:
	${EXEC_APP} php artisan queue:work ${ARGUMENT}

.PHONY: buildapi
buildapi:
	@echo "Building ${API_NAME} ${VERSION}"
	cd golang/cmd/${SERVICE_NAME}; go build -o bin/${API_NAME}

.PHONY: runapi
runapi: buildapi
	@echo "Running ${API_NAME} ${VERSION}"
	cd golang/cmd/${SERVICE_NAME}/bin; ./${API_NAME}

.PHONY: packageapi
packageapi:
	@echo "Building ${API_NAME} ${VERSION}"
	docker buildx build \
		--progress plain \
		--tag ${API_NAME}:${VERSION} \
		--tag ${API_NAME}:latest \
		--build-arg VERSION=${VERSION} \
		--build-arg GIT_COMMIT=${GIT_COMMIT}${GIT_DIRTY} \
		--build-arg APP_NAME=${API_NAME} \
		--build-arg SERVICE_NAME=${SERVICE_NAME} \
		-f Dockerfile-api \
		.