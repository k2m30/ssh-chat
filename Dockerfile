FROM golang:1.16.5-alpine3.13 AS builder

WORKDIR /usr/src/app
RUN apk add make openssh

COPY . .
RUN make build

FROM alpine:3.13.5
RUN apk add openssh

RUN mkdir -p /root/.ssh
RUN ssh-keygen -t rsa -C "chatkey" -f /root/.ssh/id_rsa

WORKDIR /usr/local/bin
COPY --from=builder /usr/src/app/ssh-chat .
RUN chmod +x ssh-chat
CMD ["./ssh-chat"]
