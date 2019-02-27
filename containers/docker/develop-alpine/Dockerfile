FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/blockchain/go-blockchain && \
  (cd go-blockchain && make lov) && \
  cp go-blockchain/build/bin/lov /lov && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-blockchain && rm -rf /var/cache/apk/*

EXPOSE 55557
EXPOSE 44446

ENTRYPOINT ["/lov"]
