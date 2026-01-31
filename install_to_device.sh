#!/bin/bash

# HarmonyOS 应用真机安装脚本
# 用于将应用安装到连接的真机设备

set -e  # 遇到错误立即退出

echo "=========================================="
echo "  HarmonyOS 应用真机安装工具"
echo "=========================================="
echo ""

# 配置
HDC="/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc"
HAP_PATH="entry/build/default/outputs/default/entry-default-signed.hap"
BUNDLE_NAME="com.ryan.mi"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查设备连接
echo -e "${YELLOW}[1/4] 检查设备连接...${NC}"
DEVICE_ID=$($HDC list targets)

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}✗ 未检测到设备！${NC}"
    echo ""
    echo "请确保："
    echo "1. 设备已通过 USB 连接到电脑"
    echo "2. 设备已开启 USB 调试模式"
    echo "3. 设备已通过 USB 调试授权"
    exit 1
fi

echo -e "${GREEN}✓ 设备已连接: $DEVICE_ID${NC}"
echo ""

# 检查 HAP 文件是否存在
echo -e "${YELLOW}[2/4] 检查安装包...${NC}"
if [ ! -f "$HAP_PATH" ]; then
    echo -e "${RED}✗ 未找到 HAP 文件: $HAP_PATH${NC}"
    echo ""
    echo "请先运行以下命令构建应用："
    echo "  ./build.sh"
    echo ""
    echo "或在 DevEco Studio 中："
    echo "  Build → Build Hap(s) / APP(s) → Build Hap(s)"
    exit 1
fi

HAP_SIZE=$(du -h "$HAP_PATH" | cut -f1)
echo -e "${GREEN}✓ 找到安装包: $HAP_PATH ($HAP_SIZE)${NC}"
echo ""

# 卸载旧版本（如果存在）
echo -e "${YELLOW}[3/4] 检查并卸载旧版本...${NC}"
INSTALLED=$($HDC shell bm list -b "$BUNDLE_NAME" 2>/dev/null || echo "")

if [ -n "$INSTALLED" ]; then
    echo "发现已安装的版本，正在卸载..."
    $HDC uninstall "$BUNDLE_NAME"
    echo -e "${GREEN}✓ 旧版本已卸载${NC}"
else
    echo -e "${GREEN}✓ 未安装旧版本${NC}"
fi
echo ""

# 安装新版本
echo -e "${YELLOW}[4/4] 安装应用...${NC}"
$HDC install "$HAP_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✓ 应用安装成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "包名: $BUNDLE_NAME"
    echo "设备: $DEVICE_ID"
    echo ""
    echo "您现在可以在设备上找到并运行应用了！"
    echo ""
    echo "常用操作："
    echo "  启动应用: $HDC shell aa start -a EntryAbility -b $BUNDLE_NAME"
    echo "  停止应用: $HDC shell aa force-stop $BUNDLE_NAME"
    echo "  卸载应用: $HDC uninstall $BUNDLE_NAME"
    echo "  查看日志: $HDC shell hilog | grep 'com.ryan.mi'"
else
    echo -e "${RED}✗ 安装失败${NC}"
    echo ""
    echo "可能的原因："
    echo "1. 设备存储空间不足"
    echo "2. 签名配置问题"
    echo "3. 设备系统版本不兼容"
    echo "4. USB 连接不稳定"
    exit 1
fi
