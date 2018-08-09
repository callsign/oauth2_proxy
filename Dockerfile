FROM golang:1.9 AS builder
WORKDIR /go/src/github.com/bitly/oauth2_proxy
COPY . .
RUN go get -d -v; \
    CGO_ENABLED=0 GOOS=linux go build

FROM alpine:3.8

RUN apk update && apk upgrade

RUN apk add bash bind-tools curl

COPY --from=builder /go/src/github.com/bitly/oauth2_proxy/oauth2_proxy /bin/oauth2_proxy

RUN ln -s /bin/oauth2_proxy /oauth2_proxy

ENTRYPOINT ["/bin/oauth2_proxy"]

