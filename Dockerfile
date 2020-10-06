# Use the offical golang image to create a binary.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.14-buster as builder

# Create and change to the app directory.
WORKDIR /app

# Retrieve application dependencies.
# This allows the container build to reuse cached dependencies.
# Expecting to copy go.mod and if present go.sum.
COPY go.* ./
RUN go mod download

# Copy local code to the container image.
COPY invoke.go ./

# Build the binary.
RUN go build -mod=readonly -v -o server

# Use the official Debian slim image for a lean production container.
# https://hub.docker.com/_/debian
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    --no-install-recommends \
    ca-certificates git wget gnupg

    #&& \
    #rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/saulpw/deb-vd/master/devotees.gpg.key
RUN apt-key add devotees.gpg.key

RUN apt install -y apt-transport-https software-properties-common

RUN add-apt-repository \
    "deb [arch=amd64] https://raw.githubusercontent.com/saulpw/deb-vd/master \
    sid \
    main"
RUN apt-get update
RUN apt-get install -y visidata

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /app/server
COPY script.sh ./
COPY cmdlog.vd ./

# Run the web service on container startup.
CMD ["/app/server"]
