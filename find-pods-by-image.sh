#!/bin/bash

# 检查是否提供了镜像名称关键字参数
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
