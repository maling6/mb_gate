default: all

.PHONY: all
all: test build

GIT_REVISION=$(shell git rev-parse --short HEAD)
GIT_BRANCH=$(shell git rev-parse --symbolic-full-name --abbrev-ref HEAD)

LDFLAGS=-ldflags "-s -X main.gitRevision=$(GIT_REVISION) -X main.gitBranch=$(GIT_BRANCH)"

.PHONY: clean
clean:
	rm bin/*

.PHONY: prepare
prepare:
	go mod tidy

.PHONY: test
test: prepare
	go test -v ./...

.PHONY: run
run:
	go run .

.PHONY: build
build: prepare
	go build $(LDFLAGS) -o bin/mb_gate
	go build $(LDFLAGS) -o bin/client ./cmd/client/
	go build $(LDFLAGS) -o bin/wiren ./cmd/wiren/

.PHONY: gox
gox: prepare
	GOARM=5 gox --osarch="linux/amd64 linux/arm" -output "bin/{{.Dir}}_{{.OS}}_{{.Arch}}" $(LDFLAGS)
