FROM ubuntu:20.04

ARG TARGETARCH

ENV PATH=$PATH:/usr/local/go/bin

WORKDIR /root

RUN apt-get update && apt-get install -y git make curl \
  && apt-get install -y clang llvm \
  && apt-get install -y gcc \
  && if [ "${TARGETARCH}" = "amd64" ]; then apt-get install -y gcc-multilib tree; fi \
  && rm -rf /var/lib/apt/lists/*

RUN curl -Lo go1.16.12.linux-${TARGETARCH}.tar.gz https://go.dev/dl/go1.16.12.linux-${TARGETARCH}.tar.gz \
  && tar -xzf go1.16.12.linux-${TARGETARCH}.tar.gz -C /usr/local/ \
  && rm go1.16.12.linux-${TARGETARCH}.tar.gz \
  && curl -L https://github.com/golangci/golangci-lint/releases/download/v1.42.1/golangci-lint-1.42.1-linux-${TARGETARCH}.deb -o golangci-lint-1.42.1-linux-${TARGETARCH}.deb \
  && dpkg -i golangci-lint-1.42.1-linux-${TARGETARCH}.deb \
  && rm golangci-lint-1.42.1-linux-${TARGETARCH}.deb

RUN go install github.com/gobuffalo/packr/v2/packr2@v2.8.3 \
  && go install mvdan.cc/gofumpt@v0.1.1 \
  && go get -u golang.org/x/tools/cmd/goyacc \
  && go get -u github.com/kevinburke/go-bindata/... \
  && cp -r $HOME/go/bin/* /usr/local/bin
