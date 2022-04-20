docker buildx build --platform amd64,arm64 . -t datakit-developer:1.0

# or
# nerdctl 导出的镜像文件的压缩比较高
# nerdctl build --platform amd64,arm64 . -t datakit-developer:1.0