FROM golang:1.21-alpine AS builder
WORKDIR /app
RUN wget https://github.com/Droplr/aws-env/raw/master/bin/aws-env-linux-amd64 -O aws-env
RUN chmod +x aws-env
COPY src/main.go .
RUN go build main.go

FROM alpine:latest
RUN apk add --no-cache wget
COPY --from=builder /app /app
COPY --from=builder /app/aws-env /usr/local/bin/aws-env
COPY ssm-env.sh /app/ssm-env.sh

EXPOSE 80

CMD ["/bin/sh", "-c", "./ssm-env.sh; /app/main"]
