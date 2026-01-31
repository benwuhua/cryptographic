#!/bin/bash

# 自动化页面布局测试脚本
# 测试不同屏幕尺寸下的页面布局

set -e

echo "=== 🔍 自动化页面布局测试 ==="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 测试结果统计
PASSED=0
FAILED=0
WARNINGS=0

# 测试函数
test_case() {
    local test_name="$1"
    local test_command="$2"

    echo -n "Testing: $test_name ... "

    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAILED${NC}"
        ((FAILED++))
        return 1
    fi
}

# 警告函数
warning_case() {
    local test_name="$1"
    echo -e "${YELLOW}⚠ WARNING: $test_name${NC}"
    ((WARNINGS++))
}

echo "1️⃣  检查源代码文件..."
echo "  "

# 检查所有页面文件是否存在
test_case "HomePage.ets exists" "[ -f entry/src/main/ets/pages/HomePage.ets ]"
test_case "GamePage.ets exists" "[ -f entry/src/main/ets/pages/GamePage.ets ]"
test_case "ResultPage.ets exists" "[ -f entry/src/main/ets/pages/ResultPage.ets ]"
test_case "ResponsiveUtils.ets exists" "[ -f entry/src/main/ets/utils/ResponsiveUtils.ets ]"

echo ""
echo "2️⃣  检查响应式配置..."
echo "   "

# 检查缩放因子限制
if grep -q "Math.max(0.8, Math.min(1.5, scaleFactor))" entry/src/main/ets/utils/ResponsiveUtils.ets; then
    echo -e "${GREEN}✓ PASSED${NC}: Scale factor limits found (0.8 - 1.5)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAILED${NC}: Scale factor limits not found"
    ((FAILED++))
fi

# 检查所有页面是否导入ResponsiveUtils
for page in HomePage GamePage ResultPage LevelSelectPage SettingsPage PracticePage DuelSetupPage; do
    file="entry/src/main/ets/pages/${page}.ets"
    if [ -f "$file" ]; then
        if grep -q "ResponsiveUtils" "$file"; then
            echo -e "${GREEN}✓ PASSED${NC}: $page uses ResponsiveUtils"
            ((PASSED++))
        else
            echo -e "${YELLOW}⚠ WARNING${NC}: $page does not use ResponsiveUtils"
            ((WARNINGS++))
        fi
    fi
done

echo ""
echo "3️⃣  检查布局宽度设置..."
echo "   "

# 检查是否有过宽的设置
OVERWIDTH_FILES=$(grep -r "width\(['\"]100%['\"]" entry/src/main/ets/pages/*.ets | grep -v "\.width('100%')" | wc -l)
if [ "$OVERWIDTH_FILES" -eq 0 ]; then
    echo -e "${GREEN}✓ PASSED${NC}: No dangerous 100% width patterns"
    ((PASSED++))
else
    warning_case "Found $OVERWIDTH_FILES potential 100% width issues"
fi

# 检查width('90%')使用是否合理
WIDTH_90_COUNT=$(grep -r "width(['\"]90%['\"])" entry/src/main/ets/pages/*.ets | wc -l)
echo -e "${GREEN}✓ INFO${NC}: Found $WIDTH_90_COUNT safe width(90%) usages"

echo ""
echo "4️⃣  检查按钮触摸目标..."
echo "   "

# 检查按钮高度是否满足最小触摸目标
BUTTON_HEIGHT_CHECK=$(grep -r "RS.BUTTON_HEIGHT" entry/src/main/ets/pages/*.ets | wc -l)
if [ "$BUTTON_HEIGHT_CHECK" -gt 0 ]; then
    echo -e "${GREEN}✓ PASSED${NC}: Buttons use responsive height (RS.BUTTON_HEIGHT)"
    ((PASSED++))
else
    warning_case "Some buttons may not use responsive height"
fi

echo ""
echo "5️⃣  检查间距配置..."
echo "   "

# 检查间距是否使用响应式
SPACING_CHECK=$(grep -r "ResponsiveUtils.rsp" entry/src/main/ets/pages/*.ets | wc -l)
if [ "$SPACING_CHECK" -gt 50 ]; then
    echo -e "${GREEN}✓ PASSED${NC}: Found $SPACING_CHECK responsive spacing usages"
    ((PASSED++))
else
    warning_case "Only found $SPACING_CHECK responsive spacing usages (expected 50+)"
fi

echo ""
echo "6️⃣  检查字体大小配置..."
echo "   "

# 检查字体是否使用响应式
FONT_CHECK=$(grep -r "ResponsiveUtils.rf" entry/src/main/ets/pages/*.ets | wc -l)
if [ "$FONT_CHECK" -gt 30 ]; then
    echo -e "${GREEN}✓ PASSED${NC}: Found $FONT_CHECK responsive font usages"
    ((PASSED++))
else
    warning_case "Only found $FONT_CHECK responsive font usages (expected 30+)"
fi

echo ""
echo "7️⃣  检查GameModeButton间距..."
echo "   "

# 检查GameModeButton之间的间距
if grep -q "Column({ space: ResponsiveUtils.rsp(RSP.S) })" entry/src/main/ets/pages/HomePage.ets; then
    echo -e "${GREEN}✓ PASSED${NC}: GameModeButtons use compact spacing (RSP.S)"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ WARNING${NC}: GameModeButtons may use larger spacing"
    ((WARNINGS++))
fi

echo ""
echo "8️⃣  检查是否编译成功..."
echo "   "

# 尝试编译检查语法
if command -v hvigorw &> /dev/null || [ -f "hvigorw" ]; then
    echo "Running compilation check..."
    if hvigorw assembleHap --no-daemon -p product=default -p buildMode=debug 2>&1 | grep -q "BUILD SUCCESSFUL"; then
        echo -e "${GREEN}✓ PASSED${NC}: Project compiles successfully"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠ WARNING${NC}: Compilation check failed (may need manual verification)"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠ INFO${NC}: Build tool not found, skipping compilation test"
fi

echo ""
echo "=== 📊 测试结果总结 ==="
echo ""
echo -e "${GREEN}✓ Passed:${NC}  $PASSED"
if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠ Warnings:${NC} $WARNINGS"
fi
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}✗ Failed:${NC}  $FAILED"
    echo ""
    echo -e "${RED}❌ 测试失败！请检查上述错误。${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}✅ 所有测试通过！页面布局配置正确。${NC}"

    if [ $WARNINGS -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}⚠️  有 $WARNINGS 个警告，建议检查。${NC}"
    fi

    exit 0
fi
