VERSION ?= $(shell node -p 'require("./package.json").version')

OS ?= $(shell node -p 'process.platform')

.PHONY: all
all: clean build

.PHONY: clean
clean: rm -rf bin reason-bin.tar.gz

.PHONY: build
build: clean

.PHONY: bin
bin:
	@curl -O -L https://github.com/yunxing/reason-bin/releases/download/$(VERSION)-$(OS)/reason-bin.tar.gz
	@tar xzvf reason-bin.tar.gz
	@rm reason-bin.tar.gz
