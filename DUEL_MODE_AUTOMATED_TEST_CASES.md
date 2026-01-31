# 双人对战模式 - 自动化测试用例

**创建日期**: 2026-01-28
**相关Bug**: Bug #1 - DuelSetupPage没有导航，GamePage不支持duel模式

---

## 测试用例清单

### TC-DUEL-001: 双人对战导航测试
**优先级**: P0
**测试类型**: 集成测试

**用户故事**: 作为玩家，我想要从主页进入双人对战，然后开始游戏，以便和朋友一起玩。

**前置条件**:
- [x] 应用已编译
- [x] 应用已启动

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 从主页点击"双人对战"按钮 | 进入DuelSetupPage |
| 2 | 选择颜色数量（4色/5色/6色） | 颜色数量更新 |
| 3 | 点击4个颜色设置密码 | 密码槽位显示选择的颜色 |
| 4 | 点击"开始对战"按钮 | 导航到GamePage |
| 5 | 检查路由参数 | mode='duel', colorCount正确传递 |

**预期结果**:
- ✅ 成功导航到GamePage
- ✅ GamePage正确识别duel模式
- ✅ 游戏使用正确的密码（玩家A设置的）
- ✅ 可用颜色数量与设置匹配

**代码实现**:
```typescript
describe('Duel Mode Navigation Tests', () => {
  it('should navigate to game page with duel mode when clicking start', async () => {
    // Given: 在双人对战设置页设置了4色密码
    const duelSetupPage = new DuelSetupPage();
    duelSetupPage.colorCount = 4;
    duelSetupPage.customPassword = ['red', 'yellow', 'green', 'blue'];

    // When: 点击"开始对战"
    await duelSetupPage.startDuelGame();

    // Then: 应该导航到游戏页面
    const params = Navigator.getParams() as GamePageParamsType;
    expect(params.mode).assertEqual('duel');
    expect(params.colorCount).assertEqual(4);
  });
});
```

---

### TC-DUEL-002: GamePage正确识别duel模式
**优先级**: P0
**测试类型**: 单元测试

**前置条件**:
- [x] GamePage组件已创建
- [x] 路由参数传递了mode='duel'

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | loadGameFromParams()检测到mode='duel' | isDuelMode = true |
| 2 | 调用LevelService.generateDuelLevel() | 生成duel关卡配置 |
| 3 | 创建游戏状态时传递mode='duel' | gameState.mode = 'duel' |
| 4 | 检查关卡密码 | 使用玩家A设置的密码 |

**预期结果**:
- ✅ GamePage正确识别duel模式
- ✅ 不尝试从关卡库加载levelId=0
- ✅ 使用generateDuelLevel()生成关卡
- ✅ 游戏状态中mode字段正确

**代码实现**:
```typescript
describe('GamePage Duel Mode Tests', () => {
  it('should initialize duel game correctly when mode is duel', async () => {
    // Given: 路由参数为duel模式
    const params: GamePageParamsType = {
      mode: 'duel',
      colorCount: 5
    };

    // When: 初始化游戏
    await gamePage.loadGameFromParams();

    // Then: 应该生成duel关卡
    expect(gamePage.gameState.mode).assertEqual('duel');
    expect(gamePage.gameState.level.colorCount).assertEqual(5);

    // And: 关卡密码应该是随机生成或使用自定义密码
    expect(gamePage.gameState.level.password.length).assertEqual(4);
  });
});
```

---

### TC-DUEL-003: DuelSetupPage密码设置完整性检查
**优先级**: P1
**测试类型**: 单元测试

**前置条件**:
- [x] DuelSetupPage已渲染

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 用户未填写任何密码 | isPasswordComplete()返回false |
| 2 | 用户只填写了1个颜色 | isPasswordComplete()返回false |
| 3 | 用户填写了3个颜色 | isPasswordComplete()返回false |
| 4 | 用户填写了4个颜色 | isPasswordComplete()返回true |
| 5 | "开始对战"按钮状态 | 完整时enabled=true，不完整时enabled=false |

**预期结果**:
- ✅ 密码完整性检查准确
- ✅ 按钮状态正确反映密码状态

**代码实现**:
```typescript
describe('DuelSetupPage Password Tests', () => {
  it('should disable start button when password is incomplete', () => {
    const duelSetupPage = new DuelSetupPage();

    // 测试部分填充
    duelSetupPage.customPassword = ['red', null, null, null];
    expect(duelSetupPage.isPasswordComplete()).assertFalse();
    // 按钮应该是禁用的

    // 测试完整填充
    duelSetupPage.customPassword = ['red', 'yellow', 'green', 'blue'];
    expect(duelSetupPage.isPasswordComplete()).assertTrue();
    // 按钮应该是启用的
  });
});
```

---

### TC-DUEL-004: 颜色数量切换重置密码
**优先级**: P1
**测试类型**: UI测试

**前置条件**:
- [x] DuelSetupPage已渲染
- [x] 用户已设置部分密码

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 用户设置了3个颜色 | 密码部分填充 |
| 2 | 点击"5色"按钮 | 密码清空为[null, null, null, null] |
| 3 | 点击"6色"按钮 | 密码清空为[null, null, null, null] |
| 4 | 点击"4色"按钮 | 密码清空为[null, null, null, null] |

**预期结果**:
- ✅ 切换颜色数量时密码被清空
- ✅ 用户必须重新设置密码

**代码实现**:
```typescript
describe('DuelSetupPage Color Count Tests', () => {
  it('should reset password when color count changes', () => {
    const duelSetupPage = new DuelSetupPage();
    duelSetupPage.customPassword = ['red', 'yellow', null, null];
    duelSetupPage.currentSlotIndex = 2;

    // When: 切换颜色数量
    duelSetupPage.colorCount = 5; // 触发reset

    // Then: 密码应该被清空
    expect(duelSetupPage.customPassword).assertEqual([null, null, null, null]);
    expect(duelSetupPage.currentSlotIndex).assertEqual(0);
  });
});
```

---

### TC-DUEL-005: GamePage在duel模式下显示正确的颜色数量
**优先级**: P1
**测试类型**: UI测试

**前置条件**:
- [x] GamePage处于duel模式
- [x] colorCount参数为5

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 进入duel模式游戏 | getAvailableColors()返回颜色数组 |
| 2 | 检查返回的颜色数量 | 应该为5 |
| 3 | 检查具体颜色 | 应该是red,yellow,green,blue,purple |

**预期结果**:
- ✅ 颜色选择器显示正确的颜色数量
- ✅ 所有颜色都在有效范围内

**代码实现**:
```typescript
describe('GamePage Duel Color Count Tests', () => {
  it('should show correct number of colors in duel mode', async () => {
    const gamePage = new GamePage();

    // Given: 进入duel模式，5色
    await gamePage.loadGameFromParams({
      mode: 'duel',
      colorCount: 5
    });

    // Then: 可用颜色应该是5个
    const availableColors = gamePage.getAvailableColors();
    expect(availableColors.length).assertEqual(5);
    expect(availableColors).assertEqual(['red', 'yellow', 'green', 'blue', 'purple']);
  });
});
```

---

### TC-DUEL-006: Navigator.pushParams支持duel模式
**优先级**: P0
**测试类型**: 集成测试

**前置条件**:
- [x] Navigator工具已导入

**测试步骤**:
| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 调用Navigator.pushParams()传递duel参数 | 路由push成功 |
| 2 | 检查router.pushUrl调用 | 使用了Routes.GAME作为url |
| 3 | 检查params | params包含mode='duel', colorCount=4 |

**预期结果**:
- ✅ pushParams方法支持任意参数类型
- ✅ 正确传递到GamePage

**代码实现**:
```typescript
describe('Navigator pushParams Tests', () => {
  it('should support duel mode parameters', () => {
    // Given: 准备duel模式参数
    const params = {
      mode: 'duel' as GameMode,
      colorCount: 4
    };

    // When: 调用pushParams
    Navigator.pushParams(params);

    // Then: 应该调用router.pushUrl
    // 实际测试需要mock router.pushUrl
    // expect(router.pushUrl).toHaveBeenCalledWith({
    //   url: Routes.GAME,
    //   params
    // });
  });
});
```

---

## 测试数据

### Duel模式密码示例
```typescript
const duelPasswords = {
  fourColors: ['red', 'yellow', 'green', 'blue'],
  fiveColors: ['red', 'yellow', 'green', 'blue', 'purple'],
  sixColors: ['red', 'yellow', 'green', 'blue', 'purple', 'orange']
};
```

### 预期的关卡配置
```typescript
const expectedDuelLevel: Level = {
  id: 0,
  difficulty: 'hard',
  password: duelPasswords.fourColors,
  colorCount: 4,
  hintMode: 'unmapped',
  maxAttempts: 7
};
```

---

## 边界测试

### TC-DUEL-EDGE-001: 最小颜色数量（4色）
**优先级**: P1
**测试场景**: 用户选择4色模式

**测试步骤**:
1. 设置colorCount=4
2. 验证只显示4个颜色选项
3. 验证生成的关卡colorCount=4

**预期结果**:
- ✅ 只显示red, yellow, green, blue
- ✅ 关卡配置正确

---

### TC-DUEL-EDGE-002: 最大颜色数量（6色）
**优先级**: P1
**测试场景**: 用户选择6色模式

**测试步骤**:
1. 设置colorCount=6
2. 验证显示全部6个颜色
3. 验证生成的关卡colorCount=6

**预期结果**:
- ✅ 显示red, yellow, green, blue, purple, orange
- ✅ 关卡配置正确

---

## 异常测试

### TC-DUEL-EXC-001: 无效的路由参数
**优先级**: P2
**测试场景**: GamePage接收到不完整的参数

**测试步骤**:
1. 导航到GamePage但不传递mode参数
2. 调用loadGameFromParams()

**预期结果**:
- ✅ 使用默认mode='solo'
- ✅ 不会崩溃
- ✅ 显示错误日志

---

### TC-DUEL-EXC-002: colorCount参数缺失
**优先级**: P2
**测试场景**: Duel模式但没有传递colorCount

**测试步骤**:
1. 调用Navigator.pushParams({mode: 'duel'})不传colorCount
2. GamePage处理缺失参数

**预期结果**:
- ✅ 使用默认colorCount=4
- ✅ 不会崩溃

---

## 执行计划

### 阶段1: 导航流程测试
1. TC-DUEL-001: 完整导航流程
2. TC-DUEL-006: Navigator.pushParams测试

### 阶段2: GamePage初始化测试
1. TC-DUEL-002: duel模式识别
2. TC-DUEL-005: 颜色数量显示

### 阶段3: UI交互测试
1. TC-DUEL-003: 密码设置
2. TC-DUEL-004: 颜色数量切换

### 阶段4: 边界和异常测试
1. TC-DUEL-EDGE-001: 4色模式
2. TC-DUEL-EDGE-002: 6色模式
3. TC-DUEL-EXC-001: 参数缺失测试

---

## 测试覆盖

### 覆盖的功能点
- [x] DuelSetupPage导航逻辑
- [x] GamePage模式识别
- [x] 密码完整性检查
- [x] 颜色数量切换
- [ ] Navigator.pushParams实现（需要mock）
- [ ] 路由参数传递验证（需要mock）

### 覆盖的代码路径
- [x] DuelSetupPage.startDuelGame()
- [x] GamePage.initGame() - duel分支
- [x] LevelService.generateDuelLevel()
- [ ] Navigator.pushParams()
- [ ] 路由参数解析

---

## 验收标准

### 通过条件
- [ ] 所有TC-DUEL-001到TC-DUEL-006通过
- [ ] 边界测试通过
- [ ] 异常测试不会导致崩溃
- [ ] 日志输出清晰

### 失败条件
- 任何导航测试失败
- 模式识别错误
- 崩溃或未捕获异常

---

## 回归测试

### 修复前的问题
1. 点击"开始对战"后没有导航
2. GamePage无法识别duel模式

### 修复后验证
1. [ ] 导航到GamePage成功
2. [ ] 游戏正确进入duel模式
3. [ ] 颜色数量正确

---

## 依赖项

### 需要mock的服务
- router.pushUrl - 需要mock以验证导航调用
- LevelRepository.getLevel - duel模式不应调用

### 需要的测试工具
- HarmonyOS测试框架
- 日志收集工具

---

## 已知问题

### 当前限制
- 无法在单元测试中验证真实路由跳转
- 需要集成测试验证完整流程

### 后续优化
- 添加E2E测试验证完整用户流程
- 添加性能测试
- 添加可访问性测试

---

**相关文件**:
- /entry/src/main/ets/pages/DuelSetupPage.ets
- /entry/src/main/ets/pages/GamePage.ets
- /entry/src/main/ets/utils/Navigator.ets
- /entry/src/main/ets/services/LevelService.ets
- /entry/src/main/ets/models/GameState.ets

**创建者**: AI Assistant
**版本**: 1.0
