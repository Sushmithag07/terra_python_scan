.PHONY: help all build-docker clean build-lambdas test fmt lint clean-pyc

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
LAMBDAS_FUNCTIONS_DIR:=$$(ls -d ./lambdas/functions/*/)
BUILD_DIST_PATH:="./.dist"
PACKAGE_DIST_PATH:="./.packages"
BUILD_DIST_DIR_NAME:=".dist"
PACKAGE_DIST_DIR_NAME:=".packages"
DOCKER_IMAGE="pendulum-multi-lambda"

help:
	@echo "	clean 		- remove all build, test, coverage and Python artifacts"
	@echo "	clean-dist	- remove build & package artifacts"
	@echo "	lint 		- lint python and unit-test code"
	@echo "	test 		- run pytest tests"
	@echo "	build-docker 				- build the base docker image for build automation"
	@echo "	build-docker-x-platform 	- build the base docker image using cross platform image builder `buildx`"
	@echo "	build-lambdas				- build multiple lambdas and package them with their corresponding dependencies"
	@echo "	fmt 						- format lambdas and unit-test code style using Black for readability & consistency"

all: clean build-docker

build-docker:
	docker build -t $(DOCKER_IMAGE):arm64 .

# Github action runners OS arch are x86. Cross platform building tool buildx is required
# Build the base docker image against arm64 arch emulator
build-docker-x-platform:
	docker run --privileged --rm tonistiigi/binfmt --install all;
	docker buildx create --use;
	docker buildx build --platform=linux/arm64 -t $(DOCKER_IMAGE):arm64 . --load

# Build multiple lambdas and package them with their corresponding dependencies
build-lambdas: clean-dist clean
	@for dir in $(LAMBDAS_FUNCTIONS_DIR) ; do \
		mkdir -p $(BUILD_DIST_PATH)/$$(basename $$dir); \
		mkdir -p $(PACKAGE_DIST_PATH); \
		cp -a $$dir $(BUILD_DIST_PATH)/$$(basename $$dir);\
		docker run --rm \
		       -v $$(pwd)/lambdas:/home/lambdas \
			   -v $$(pwd)/$(BUILD_DIST_DIR_NAME):/opt/dist \
			   $(DOCKER_IMAGE):arm64 \
			   "mkdir -p /opt/dist/$$(basename $$dir); pip install -r ./functions/$$(basename $$dir)/requirements.txt -t /opt/dist/$$(basename $$dir)" ;\
		cd $(BUILD_DIST_PATH)/$$(basename $$dir); zip -r -r9 $$(basename $$dir).zip .; mv $$(basename $$dir).zip $(ROOT_DIR)/$(PACKAGE_DIST_DIR_NAME)/$$(basename $$dir).zip; cd ../..; \
	done

# Run Lambdas unit tests
test:
	docker run --rm -v  $$(pwd)/lambdas:/home/lambdas $(DOCKER_IMAGE):arm64 "python -m pytest tests"

# Format Lambdas scripts and unit tests code 
fmt:
	docker run --rm -v $$(pwd)/lambdas:/home/lambdas $(DOCKER_IMAGE):arm64 "black functions tests"

# Run lints for Lambdas scripts and unit tests
lint:
	docker run --rm -v $$(pwd)/lambdas:/home/lambdas $(DOCKER_IMAGE):arm64 "pylint functions"

# Clean python compiled artifacts from the project
clean:
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +
	@find . -name '.coverage' -exec rm -fr {} +
	@find . -name '.pytest_cache' -exec rm -fr {} +

# Clean build and packaging artifacts directories
clean-dist:
	echo "Cleaning build & packaging artifacts"
	@rm -rf $(BUILD_DIST_PATH)
	@rm -rf $(PACKAGE_DIST_PATH)

	
