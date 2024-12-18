FROM golang:1.22-alpine
RUN apk add --no-cache git
RUN apk add --no-cache git bash
WORKDIR /app
COPY wait_for_it.sh wait_for_it.sh
COPY bitdsm_entrypoint.sh bitdsm_entrypoint.sh
RUN chmod +x wait_for_it.sh
RUN chmod +x bitdsm_entrypoint.sh
RUN git clone --branch release https://github.com/BitDSM/BitDSM-Node.git
WORKDIR /app/BitDSM-Node
RUN go mod tidy
RUN go build .
WORKDIR /app
EXPOSE 8080