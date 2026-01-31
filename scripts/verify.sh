#!/bin/bash

# 密码机项目 - 代码验证脚本
# 用于快速检查项目结构和文件完整性

echo "======================================"
echo "密码机游戏 - 项目验证"
echo "======================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 计数器
total_files=0
missing_files=0

echo "📂 检查项目结构..."
echo ""

# 定义需要检查的文件
declare -a files=(
    # 服务层
    "entry/src/main/ets/services/GameService.ets"
    "entry/src/main/ets/services/LevelService.ets"

    # 数据层
    "entry/src/main/ets/repositories/UserRepository.ets"
    "entry/src/main/ets/repositories/LevelRepository.ets"

    # 组件
    "entry/src/main/ets/components/ColorSlot.ets"
    "entry/src/main/ets/components/ColorPicker.ets"
    "entry/src/main/ets/components/GuessRow.ets"
    "entry/src/main/ets/components/HintIndicator.ets"
    "entry/src/main/ets/components/LevelCard.ets"
    "entry/src/main/ets/components/StarRating.ets"
    "entry/src/main/ets/components/LoadingIndicator.ets"

    # 页面
    "entry/src/main/ets/pages/HomePage.ets"
    "entry/src/main/ets/pages/LevelSelectPage.ets"
    "entry/src/main/ets/pages/GamePage.ets"
    "entry/src/main/ets/pages/ResultPage.ets"
    "entry/src/main/ets/pages/PracticePage.ets"
    "entry/src/main/ets/pages/DuelSetupPage.ets"
    "entry/src/main/ets/pages/SettingsPage.ets"

    # 配置
    "entry/src/main/ets/entryability/EntryAbility.ets"
    "entry/src/main/ets/utils/Navigator.ets"
    "entry/src/main/resources/base/profile/main_pages.json"
)

# 检查每个文件
for file in "${files[@]}"; do
    total_files=$((total_files + 1))
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file (缺失)"
        missing_files=$((missing_files + 1))
    fi
done

echo ""
echo "======================================"
echo "📊 统计结果"
echo "======================================"
echo "总文件数: $total_files"
echo "存在文件: $((total_files - missing_files))"
echo "缺失文件: $missing_files"
echo ""

# 检查关键导入
echo "======================================"
echo "🔍 检查关键导入"
echo "======================================"

check_import() {
    local file=$1
    local import=$2
    if grep -q "$import" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $file 包含 $import"
        return 0
    else
        echo -e "${RED}✗${NC} $file 缺少 $import"
        return 1
    fi
}

check_import "entry/src/main/ets/pages/GamePage.ets" "import.*GameService"
check_import "entry/src/main/ets/pages/HomePage.ets" "import.*UserRepository"
check_import "entry/src/main/ets/entryability/EntryAbility.ets" "import.*UserRepository"

echo ""
echo "======================================"
echo "✅ 验证完成"
echo "======================================"

if [ $missing_files -eq 0 ]; then
    echo -e "${GREEN}所有文件都已就绪！${NC}"
    echo ""
    echo "下一步："
    echo "1. 打开 DevEco Studio"
    echo "2. File → Open → 选择当前目录"
    echo "3. 等待同步完成"
    echo "4. 点击 Build 构建"
    echo "5. 连接模拟器/设备并运行"
    exit 0
else
    echo -e "${RED}发现 $missing_files 个文件缺失${NC}"
    echo "请检查文件是否正确创建"
    exit 1
fi
