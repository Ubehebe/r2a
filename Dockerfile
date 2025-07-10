# adapted from https://docs.docker.com/guides/golang/build-images
FROM golang:1.24.5-alpine AS stage0
WORKDIR /
COPY main.go go.mod ./
RUN go build

FROM alpine:3.22.0
WORKDIR /
COPY --from=stage0 /r2a /r2a
EXPOSE 8080
ENTRYPOINT ["/r2a"]