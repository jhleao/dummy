FROM golang:1.22-alpine AS builder
WORKDIR /app
RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O aws-env
RUN chmod +x aws-env
COPY . .
RUN go mod download
RUN go build src/main.go

FROM alpine:latest
RUN apk add --no-cache wget
COPY --from=builder /app /app
COPY --from=builder /app/aws-env /usr/local/bin/aws-env
COPY ssm-env.sh /app/ssm-env.sh

EXPOSE 80

CMD ["/bin/sh", "-c", "/app/ssm-env.sh; /app/main"]
