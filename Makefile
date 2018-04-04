ifeq ($(TARGET), rhel)
    DOCKERFILE := Dockerfile.rhel

    ifndef DOCKER_REGISTRY
        $(error DOCKER_REGISTRY is not set)
    endif

    REGISTRY := $(DOCKER_REGISTRY)
else
    DOCKERFILE := Dockerfile
    REGISTRY?=registry.devshift.net
endif
REPOSITORY?=bayesian/coreapi-pgbouncer
DEFAULT_TAG=latest

.PHONY: all docker-build fast-docker-build test get-image-name get-image-repository

all: fast-docker-build

docker-build:
	docker build --no-cache -f $(DOCKERFILE) -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

fast-docker-build:
	docker build -f $(DOCKERFILE) -t $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG) .

test: fast-docker-build
	./tests/run_integration_tests.sh

get-image-name:
	@echo $(REGISTRY)/$(REPOSITORY):$(DEFAULT_TAG)

get-image-repository:
	@echo $(REPOSITORY)

