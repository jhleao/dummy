FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest
RUN apk add --no-cache wget
COPY --from=builder /app/app /app
EXPOSE 80
ENTRYPOINT ["/app"]