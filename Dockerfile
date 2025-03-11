FROM golang:1.22-alpine
RUN apk add --no-cache git
RUN apk add --no-cache git bash
WORKDIR /app
COPY wait_for_it.sh wait_for_it.sh
COPY motif_entrypoint.sh motif_entrypoint.sh
RUN chmod +x wait_for_it.sh
RUN chmod +x motif_entrypoint.sh
RUN git clone --branch release https://github.com/motif-project/motif-node.git
WORKDIR /app/motif-node
RUN go mod tidy
RUN go build .
WORKDIR /app
EXPOSE 8080