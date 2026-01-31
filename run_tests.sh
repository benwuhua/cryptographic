#!/bin/bash

# HarmonyOS 自动化测试脚本
# 自动构建、安装并运行测试

set -e  # 遇到错误立即退出

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 工具路径
NODE="/Applications/DevEco-Studio.app/Contents/tools/node/bin/node"
HVIGORW="/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js"
HDC="/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  HarmonyOS 自动化测试脚本${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

# 步骤1：清理构建
echo -e "${YELLOW}[1/5] 清理构建缓存...${NC}"
"$NODE" "$HVIGORW" clean
echo -e "${GREEN}✓ 清理完成${NC}"
echo ""

# 步骤2：构建测试模块
echo -e "${YELLOW}[2/5] 构建测试模块 (ohosTest)...${NC}"
"$NODE" "$HVIGORW" --mode module -p module=entry@ohosTest \
    -p isOhosTest=true -p product=default -p buildMode=test assembleHap
echo -e "${GREEN}✓ 测试模块构建完成${NC}"
echo ""

# 步骤3：构建主模块
echo -e "${YELLOW}[3/5] 构建主应用模块...${NC}"
"$NODE" "$HVIGORW" --mode module -p module=entry \
    -p product=default -p buildMode=test assembleHap
echo -e "${GREEN}✓ 主模块构建完成${NC}"
echo ""

# 步骤4：安装到设备
echo -e "${YELLOW}[4/5] 安装应用到设备...${NC}"
"$HDC" shell bm uninstall com.ryan.mi 2>/dev/null || true
"$HDC" install entry/build/default/outputs/default/entry-default-signed.hap \
    entry/build/default/outputs/ohosTest/entry-ohosTest-signed.hap
echo -e "${GREEN}✓ 安装完成${NC}"
echo ""

# 步骤5：运行测试
echo -e "${YELLOW}[5/5] 运行自动化测试...${NC}"
echo ""

# 运行测试并捕获输出
TEST_OUTPUT=$("$HDC" shell aa test -b com.ryan.mi -m entry_test \
    -s unittest OpenHarmonyTestRunner -s timeout 30000 2>&1)

echo "$TEST_OUTPUT"
echo ""

# 解析测试结果
if echo "$TEST_OUTPUT" | grep -q "Pass: [1-9]"; then
    # 提取通过数量
    PASS_COUNT=$(echo "$TEST_OUTPUT" | grep -oP 'Pass: \K[0-9]+')
    FAILURE_COUNT=$(echo "$TEST_OUTPUT" | grep -oP 'Failure: \K[0-9]+')
    ERROR_COUNT=$(echo "$TEST_OUTPUT" | grep -oP 'Error: \K[0-9]+')

    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  测试完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "  通过: ${GREEN}$PASS_COUNT${NC}"
    echo -e "  失败: ${RED}$FAILURE_COUNT${NC}"
    echo -e "  错误: ${RED}$ERROR_COUNT${NC}"
    echo -e "${GREEN}========================================${NC}"

    # 如果有失败或错误，退出码为1
    if [ "$FAILURE_COUNT" -gt 0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
        exit 1
    fi
else
    echo -e "${RED}✗ 测试运行失败${NC}"
    echo -e "${YELLOW}请检查设备连接和应用状态${NC}"
    exit 1
fi
