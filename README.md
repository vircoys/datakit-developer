# 制作 DataKit Ubuntu 开发环境镜像


~~构建环境需要使用 **Ubuntu 18.04+** 系统上，由于其涉及到内核头文件的安装；~~

~~但可自行实现内核头文件的安装，以避开此要求。~~

需要自行安装：
  * **docker** (或者 **nerdctl** 和 **containerd**) 
  
  * **[buildkit](https://github.com/moby/buildkit/blob/master/examples/systemd/system/buildkit.service)**

## DataKit 开发环境依赖项

详细内容见 Dockerfile

### apt install

1. git make curl tree tzdata
2. clang llvm
3. gcc
4. gcc-multilib (linux amd64 需要安装此)
5. linux-headers-$(uname -r)

### wget/curl

1. golang 1.16.12
2. golangci-lint-1.42.1

### go install

1. packr2@v2.8.3
2. gofumpt@v0.1.1
3. goyacc
4. go-bindata

## 从 Dockerfile 构建镜像

推荐使用 nerdctl + containerd

1. docker 工具

```shell
docker buildx build --platform amd64,arm64 . -t datakit-developer:1.0

# or
# docker buildx build --platform amd64,arm64 . -t datakit-developer:1.0 --build-arg https_proxy="http://localhost:10809"
```
2. nerdctl 工具

```
nerdctl build --platform amd64,arm64 . -t datakit-developer:1.0

# or
# nerdctl build --platform amd64,arm64 . -t datakit-developer:1.0 --build-arg https_proxy="http://localhost:10809"

```

## 启动容器

容器需要挂载的主机目录：
  1. .ssh 目录到 /root/.ssh （实现 git 相关操作）
  2. datakit 目录到 /root/go/src/gitlab.jiagouyun.com/cloudcare-tools/datakit

```
docker run -v <.ssh 文件夹>:/root/.ssh -v <datakit 文件夹>:/root/go/src/gitlab.jiagouyun.com/cloudcare-tools/datakit -ti <镜像 id/tag> /bin/bash
```

容器启动后为时区默认为 UTC +00

## 如何在 x86_64 上跑 arm64 镜像

https://github.com/multiarch/qemu-user-static
