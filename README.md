# 密码机游戏 - HarmonyOS应用

一个基于经典Mastermind（珠玑妙算）玩法的密码破解游戏，使用HarmonyOS SDK 6.0.2和ArkTS开发。

## 🎮 游戏简介

玩家需要在7次尝试内破解一个4位的颜色密码。每次猜测后会获得反馈：
- 🖤 **黑点**: 颜色和位置都正确
- ⚪ **白点**: 颜色正确但位置错误
- ⚫ **灰点**: 颜色不在密码中

## ✨ 功能特性

### ✅ 已实现 (MVP)
- [x] **单人闯关模式** - 100个初级关卡 + 500个高级关卡
- [x] **练习模式** - 随机密码，无限练习
- [x] **双人对战** - 面对面PK（设置界面完成）
- [x] **用户进度** - 自动保存通关记录和星级
- [x] **星级评分** - 1-3星评价系统
- [x] **统计数据** - 胜率、连胜记录等

### 🚧 待完善
- [ ] 剩余550关的预设密码
- [ ] 音效和动画效果
- [ ] 设置页面功能实现
- [ ] 成就系统
- [ ] 在线对战模式

## 🏗️ 项目结构

```
cryptographic/
├── entry/
│   └── src/main/
│       ├── ets/
│       │   ├── services/          # 业务逻辑层
│       │   │   ├── GameService.ets      # 核心游戏算法
│       │   │   └── LevelService.ets     # 关卡管理
│       │   ├── repositories/      # 数据层
│       │   │   ├── UserRepository.ets   # 用户数据
│       │   │   └── LevelRepository.ets  # 关卡数据
│       │   ├── components/        # UI组件
│       │   │   ├── ColorSlot.ets
│       │   │   ├── ColorPicker.ets
│       │   │   ├── GuessRow.ets
│       │   │   └── ...
│       │   ├── pages/             # 页面
│       │   │   ├── HomePage.ets
│       │   │   ├── GamePage.ets
│       │   │   └── ...
│       │   ├── models/            # 数据模型
│       │   ├── constants/         # 常量定义
│       │   ├── utils/             # 工具类
│       │   └── entryability/      # 应用入口
│       └── resources/             # 资源文件
├── docs/                         # 项目文档
│   ├── BUILD_GUIDE.md            # 构建指南
│   ├── STATUS.md                 # 当前状态
│   ├── requirements-analysis.md  # 需求分析
│   └── plans/                    # 开发计划
└── scripts/
    └── verify.sh                 # 项目验证脚本
```

## 🚀 快速开始

### 环境要求
- DevEco Studio 4.0+
- HarmonyOS SDK 6.0.2
- Node.js 14+

### 构建步骤

1. **打开项目**
   ```bash
   启动 DevEco Studio
   File → Open → 选择项目目录
   ```

2. **等待同步**
   - DevEco Studio会自动同步项目
   - 等待依赖下载完成

3. **构建项目**
   ```
   Build → Build Hap(s)/APP(s) → Build Hap(s)
   或按 Ctrl+F9 (Cmd+F9)
   ```

4. **运行应用**
   - 连接HarmonyOS设备或启动模拟器
   - 点击运行按钮 (绿色三角形)
   - 或按 `Shift+F10`

### 快速验证
```bash
./scripts/verify.sh
```

## 📊 游戏模式

### 单人闯关
- **初级模式**: 100关，4种颜色
- **高级模式**: 500关，4-6种颜色递增
- 通关初级解锁高级

### 练习模式
- 随机生成密码
- 可选择4/5/6色难度
- 无限次练习

### 双人对战
- 一名玩家设置密码
- 另一名玩家破解
- 面对面PK模式

## 🎯 星级评分

- ⭐⭐⭐ **3星**: 使用 ≤50% 次数 (3-4次)
- ⭐⭐ **2星**: 使用 ≤75% 次数 (5次)
- ⭐ **1星**: 其他情况

## 📖 技术栈

- **框架**: HarmonyOS SDK 6.0.2
- **语言**: ArkTS (TypeScript扩展)
- **UI**: ArkUI声明式组件
- **存储**: Preferences API
- **架构**: 分层架构 (Presentation → Business → Data)

## 📱 应用信息

- **包名**: `com.ryan.mi`
- **目标SDK**: HarmonyOS 6.0.2
- **最低API**: API 9+
- **权限**: 无需特殊权限

## 🛠️ 开发工具

### 验证项目
```bash
./scripts/verify.sh
```

### 代码规范
项目启用了严格的代码检查：
- 无不安全的加密操作
- TypeScript推荐规则
- 性能优化建议

### 文档
- [构建指南](docs/BUILD_GUIDE.md) - 详细的构建和运行说明
- [当前状态](docs/STATUS.md) - 项目进度和待办事项
- [需求分析](docs/requirements-analysis.md) - 完整的需求文档
- [架构设计](docs/plans/2026-01-27-architecture-design.md) - 技术架构说明

## 🐛 已知问题

1. **hvigorw脚本** - 缺失命令行构建脚本（需在DevEco Studio中构建）
2. **双人对战** - 设置页面完成，游戏逻辑需完善
3. **关卡密码** - 51-600关使用算法生成，可补充预设密码

## 📝 待办事项

- [ ] 补充剩余550关的预设密码
- [ ] 实现完整的双人对战流程
- [ ] 添加音效和动画
- [ ] 实现设置页面的开关功能
- [ ] 添加成就系统
- [ ] 实现在线对战模式

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可

本项目仅供学习和研究使用。

---

**开发时间**: 2026-01
**开发工具**: DevEco Studio + Claude Code
**版本**: 1.0.0-alpha
