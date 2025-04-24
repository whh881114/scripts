#!/bin/bash
#
# find-pods-by-image.sh
#
# 描述:
#   在所有命名空间中查找使用特定镜像关键字的 Pod。
#   适用于 Kubernetes 环境，依赖 kubectl 和 jq。
#
# 用法:
#   ./find-pods-by-image.sh <镜像名称关键字>
#
# 示例:
#   ./find-pods-by-image.sh nginx
#
# 依赖:
#   - kubectl
#   - jq
#
# 作者: chatgpt
# 日期: 2025-04-24
#


if [ -z "$1" ]; then
  echo "用法: $0 <镜像名称关键字>"
  exit 1
fi

IMAGE_NAME_KEYWORD="$1"

echo "Searching for pods using images containing '$IMAGE_NAME_KEYWORD'..."

kubectl get pods --all-namespaces -o json | jq -r --arg keyword "$IMAGE_NAME_KEYWORD" '
  .items[] |
  {
    namespace: .metadata.namespace,
    pod: .metadata.name,
    containers: (
      .spec.containers[] | select(.image | test($keyword; "i")) | .image
    )
  } |
  select(.containers != null) |
  "\(.namespace)\t\(.pod)\t\(.containers)"
' | column -t
