# Build Lov in a stock Go builder container
FROM golang:1.10-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-blockchain
RUN cd /go-blockchain && make lov

# Pull Lov into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-blockchain/build/bin/lov /usr/local/bin/

EXPOSE 55557 8546 44446 44446/udp
ENTRYPOINT ["lov"]
