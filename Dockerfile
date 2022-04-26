FROM ubuntu:20.04 as base

ARG TARGETARCH

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update && apt-get install -y git make curl tree tzdata \
  && apt-get install -y clang llvm \
  && apt-get install -y gcc \
  && if [ "${TARGETARCH}" = "amd64" ]; then apt-get install -y gcc-multilib ; fi

RUN curl -Lo go1.16.12.linux-${TARGETARCH}.tar.gz https://go.dev/dl/go1.16.12.linux-${TARGETARCH}.tar.gz \
  && tar -xzf go1.16.12.linux-${TARGETARCH}.tar.gz -C /usr/local/ \
  && rm go1.16.12.linux-${TARGETARCH}.tar.gz \
  && curl -L https://github.com/golangci/golangci-lint/releases/download/v1.42.1/golangci-lint-1.42.1-linux-${TARGETARCH}.deb -o golangci-lint-1.42.1-linux-${TARGETARCH}.deb \
  && dpkg -i golangci-lint-1.42.1-linux-${TARGETARCH}.deb \
  && rm golangci-lint-1.42.1-linux-${TARGETARCH}.deb

ENV  PATH=$PATH:/usr/local/go/bin

RUN go install github.com/gobuffalo/packr/v2/packr2@v2.8.3 \
  && go install mvdan.cc/gofumpt@v0.1.1 \
  && go get -u golang.org/x/tools/cmd/goyacc \
  && go get -u github.com/kevinburke/go-bindata/... \
  && cp -r $HOME/go/bin/* /usr/local/bin


ENV KERNEL_SRC_VERSION=5.4.0-99 DK_BPF_KERNEL_SRC_PATH=/usr/src/linux-headers-${KERNEL_SRC_VERSION}

RUN mkdir -p /root/go/src/gitlab.jiagouyun.com/cloudcare-tools/ \
  && apt-get install -y linux-headers-${KERNEL_SRC_VERSION}
