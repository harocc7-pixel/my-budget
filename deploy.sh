#!/bin/bash
# 部署脚本：初始化仓库并推送到 GitHub
# 使用前请先安装 Xcode 命令行工具：xcode-select --install

set -e

REPO_NAME="my-budget"
GITHUB_USER="${GITHUB_USER:-harocc7-pixel}"  # 可提前设置：export GITHUB_USER=你的用户名

cd "$(dirname "$0")"

echo "→ 初始化 Git 仓库..."
git init
git add index.html deploy.sh
git commit -m "$(cat <<'EOF'
Add single-file budget tracking web app.

Ins-style monthly budget tracker with localStorage persistence and category rollover.
EOF
)"

if [ -z "$GITHUB_USER" ]; then
  echo ""
  echo "请设置你的 GitHub 用户名："
  read -r GITHUB_USER
fi

echo "→ 在 GitHub 创建仓库 $GITHUB_USER/$REPO_NAME ..."
if command -v gh &>/dev/null; then
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
  echo "→ 开启 GitHub Pages..."
  gh api repos/"$GITHUB_USER"/"$REPO_NAME"/pages -X POST -f source[branch]=main -f source[path]=/
  echo ""
  echo "✅ 部署完成！访问地址："
  echo "   https://$GITHUB_USER.github.io/$REPO_NAME/"
else
  echo ""
  echo "未检测到 gh CLI，请手动操作："
  echo "1. 在 https://github.com/new 创建仓库 $REPO_NAME（不要勾选 README）"
  echo "2. 运行以下命令："
  echo ""
  echo "   git branch -M main"
  echo "   git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git"
  echo "   git push -u origin main"
  echo ""
  echo "3. 进入仓库 Settings → Pages → Source 选 main 分支 / root"
  echo "4. 访问 https://$GITHUB_USER.github.io/$REPO_NAME/"
fi
