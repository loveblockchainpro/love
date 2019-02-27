# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: lov android ios lov-cross swarm evm all test clean
.PHONY: lov-linux lov-linux-386 lov-linux-amd64 lov-linux-mips64 lov-linux-mips64le
.PHONY: lov-linux-arm lov-linux-arm-5 lov-linux-arm-6 lov-linux-arm-7 lov-linux-arm64
.PHONY: lov-darwin lov-darwin-386 lov-darwin-amd64
.PHONY: lov-windows lov-windows-386 lov-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

lov:
	build/env.sh go run build/ci.go install ./cmd/lov
	@echo "Done building."
	@echo "Run \"$(GOBIN)/lov\" to launch lov."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/lov.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Lov.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

lov-cross: lov-linux lov-darwin lov-windows lov-android lov-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/lov-*

lov-linux: lov-linux-386 lov-linux-amd64 lov-linux-arm lov-linux-mips64 lov-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-*

lov-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/lov
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep 386

lov-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/lov
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep amd64

lov-linux-arm: lov-linux-arm-5 lov-linux-arm-6 lov-linux-arm-7 lov-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep arm

lov-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/lov
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep arm-5

lov-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/lov
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep arm-6

lov-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/lov
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep arm-7

lov-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/lov
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep arm64

lov-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/lov
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep mips

lov-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/lov
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep mipsle

lov-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/lov
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep mips64

lov-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/lov
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/lov-linux-* | grep mips64le

lov-darwin: lov-darwin-386 lov-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/lov-darwin-*

lov-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/lov
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/lov-darwin-* | grep 386

lov-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/lov
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/lov-darwin-* | grep amd64

lov-windows: lov-windows-386 lov-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/lov-windows-*

lov-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/lov
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/lov-windows-* | grep 386

lov-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/lov
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/lov-windows-* | grep amd64
