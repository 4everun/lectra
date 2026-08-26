#!/usr/bin/env bash
# 安装脚本（install 阶段调用）：准备文档站点所需的 Python 虚拟环境与依赖。
# 设计为“幂等”——重复运行也不会出错或产生副作用。
set -euo pipefail

cd "$(dirname "$0")/.."

# 1) 确保系统自带 venv 模块（Debian/Ubuntu 默认镜像可能缺少 python3-venv）
if ! python3 -c "import ensurepip" >/dev/null 2>&1; then
  echo "[setup] 缺少 python3-venv，正在通过 apt 安装…"
  sudo apt-get update -qq
  sudo apt-get install -y -qq python3-venv
fi

# 2) 创建虚拟环境（已存在则跳过）
if [ ! -d ".venv" ]; then
  echo "[setup] 创建 Python 虚拟环境 .venv"
  python3 -m venv .venv
fi

# 3) 安装/更新固定版本的依赖
echo "[setup] 安装文档站点依赖（mkdocs-material、jieba）"
.venv/bin/pip install --upgrade pip -q
.venv/bin/pip install -q -r requirements.txt

echo "[setup] 完成。可用 '.venv/bin/mkdocs serve' 启动本地预览。"
