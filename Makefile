VERSION ?= $(shell node -p 'require("./package.json").version')

OS ?= $(shell node -p 'process.platform')

.PHONY: all
all: clean build

.PHONY: clean
clean: rm -rf bin reason-bin.tar.gz

.PHONY: build
build: clean

.PHONY: ocaml
ocaml:
	./buildocaml.sh

.PHONY: bin
bin: ocaml
	curl -O -L https://github.com/yunxing/reason-bin/releases/download/$(VERSION)-$(OS)/reason-bin.tar.gz
	tar xzvf reason-bin.tar.gz
	mv bin/ocamlmerlin bin/ocamlmerlin-vanilla
	rm reason-bin.tar.gz
	./setup-merlin.sh
