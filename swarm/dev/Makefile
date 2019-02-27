.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/blockchain/go-blockchain/cmd/swarm
	go build -o bin/lov     github.com/blockchain/go-blockchain/cmd/lov
	go build -o bin/bootnode github.com/blockchain/go-blockchain/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/blockchain/go-blockchain/swarm/...
