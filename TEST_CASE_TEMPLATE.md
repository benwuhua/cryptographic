# 📋 测试用例设计模板

本模板用于设计新的测试用例，确保测试覆盖完整。

---

## 测试用例元数据

### 基本信息
- **用例ID**: [TC-XXX]
- **用例名称**: [简短描述]
- **优先级**: P0/P1/P2/P3
- **测试类型**: 单元测试/集成测试/E2E测试/UI测试
- **状态**: 草稿/评审中/已批准/已实现

### 关联信息
- **需求ID**: [REQ-XXX]
- **用户故事**: [描述用户场景]
- **相关Bug**: [Bug ID]
- **相关用例**: [TC-YYY, TC-ZZZ]

---

## 测试场景描述

### 用户故事
作为 [角色]，我想要 [功能]，以便 [目标]。

### 业务价值
为什么这个功能重要？对用户的影响是什么？

---

## 测试用例详情

### 1. 前置条件
在执行此测试前需要满足的条件：
- [ ] 条件1
- [ ] 条件2
- [ ] 条件3

### 2. 测试数据
```typescript
// 测试数据示例
const testData = {
  // ...
};
```

### 3. 测试步骤

| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | [操作描述] | [预期结果] |
| 2 | [操作描述] | [预期结果] |
| 3 | [操作描述] | [预期结果] |

### 4. 预期结果
- **主要结果**: [描述主要预期结果]
- **次要结果**: [描述次要预期结果]

### 5. 边界条件
- **最小值**: [描述最小边界]
- **最大值**: [描述最大边界]
- **特殊值**: [描述特殊值]

### 6. 异常场景
- **异常1**: [描述异常场景及预期行为]
- **异常2**: [描述异常场景及预期行为]

---

## 测试实现

### 代码结构
```typescript
it('should [expected behavior]', 0, async () => {
  // Given: 前置条件
  const testData = { /* ... */ };

  // When: 执行操作
  const result = await functionUnderTest(testData);

  // Then: 验证结果
  expect(result).assertEqual(expected);
});
```

### 依赖项
- 需要模拟的服务/组件
- 需要的测试数据
- 需要的测试工具

---

## 测试覆盖

### 覆盖的功能点
- [ ] 功能点1
- [ ] 功能点2
- [ ] 功能点3

### 覆盖的代码路径
- [ ] 正常路径
- [ ] 异常路径
- [ ] 边界条件

### 覆盖的用户场景
- [ ] 主要场景
- [ ] 次要场景
- [ ] 边缘场景

---

## 验收标准

### 通过条件
- [ ] 所有测试步骤执行成功
- [ ] 所有预期结果得到验证
- [ ] 没有错误或警告
- [ ] 代码覆盖率达到要求

### 失败条件
- 任何预期结果不匹配
- 出现未处理的异常
- 测试数据不正确

---

## 示例：完整的测试用例

### TC-PRACTICE-001: 新用户练习模式应该是4色

#### 元数据
- **用例ID**: TC-PRACTICE-001
- **用例名称**: 新用户练习模式应该是4色
- **优先级**: P0
- **测试类型**: 集成测试
- **相关Bug**: Bug #2

#### 用户故事
作为新用户，我想要从4色练习模式开始，以便逐步学习游戏规则。

#### 前置条件
- [ ] 用户已安装应用
- [ ] 用户首次使用应用
- [ ] 用户进度：easyUnlocked=1, hardUnlocked=0

#### 测试数据
```typescript
const newProgress: UserProgress = {
  ...DEFAULT_USER_PROGRESS,
  easyUnlocked: 1,
  hardUnlocked: 0
};
```

#### 测试步骤

| 步骤 | 操作 | 预期结果 |
|------|------|----------|
| 1 | 生成4色练习关卡 | `colorCount=4` |
| 2 | 检查密码长度 | `password.length=4` |
| 3 | 验证密码颜色 | 所有颜色在['red','yellow','green','blue']中 |

#### 预期结果
- **主要结果**: 练习关卡有4种可用颜色
- **次要结果**: 密码只使用这4种颜色

#### 测试实现
```typescript
it('should generate 4-color practice level for new users', 0, async () => {
  // Given: 新用户（只解锁了1关）
  const newProgress: UserProgress = {
    ...DEFAULT_USER_PROGRESS,
    easyUnlocked: 1,
    hardUnlocked: 0
  };

  // When: 生成练习关卡
  const level = LevelService.generatePracticeLevel(4);

  // Then: 应该是4色
  expect(level.colorCount).assertEqual(4);
  expect(level.password.length).assertEqual(4);
});
```

---

## 测试用例检查清单

### 设计阶段
- [ ] 用例ID唯一
- [ ] 优先级明确
- [ ] 用户故事清晰
- [ ] 前置条件完整
- [ ] 测试数据准备

### 实现阶段
- [ ] 代码结构清晰
- [ ] Given-When-Then模式
- [ ] 日志输出充分
- [ ] 断言完整

### 验证阶段
- [ ] 测试通过
- [ ] 边界条件覆盖
- [ ] 异常场景测试
- [ ] 代码覆盖率达标

### 维护阶段
- [ ] 文档更新
- [ ] 依赖项记录
- [ ] 失败原因分析
- [ ] 优化建议

---

## 最佳实践

### 1. 命名规范
- **文件名**: `[Feature]Test.ets`
- **测试套件**: `describe('[Feature]Tests', () => { ... })`
- **测试用例**: `it('should [expected behavior]', 0, () => { ... })`

### 2. 测试结构
```typescript
describe('FeatureTests', () => {
  it('should do something when condition', 0, () => {
    // Given: 前置条件
    // When: 执行操作
    // Then: 验证结果
  });
});
```

### 3. 日志规范
```typescript
console.log(`=== [TEST-ID]: description ===`);
```

### 4. 断言规范
```typescript
expect(actual).assertEqual(expected);           // 相等
expect(actual).assertTrue();                    // 为真
expect(actual).assertFalse();                   // 为假
expect(actual).assertLargerThan(value);         // 大于
expect(actual).assertLessThan(value);           // 小于
```

---

## 常见测试场景

### 功能测试
- 正常功能流程
- 功能组合场景
- 功能依赖关系

### 边界测试
- 最小值
- 最大值
- 空值/Null
- 零值

### 异常测试
- 错误输入
- 网络异常
- 权限异常
- 并发冲突

### 性能测试
- 响应时间
- 吞吐量
- 资源占用
- 内存泄漏

### UI测试
- 组件渲染
- 用户交互
- 数据绑定
- 状态更新

---

## 相关文档

- [TEST_COVERAGE_ANALYSIS.md](./TEST_COVERAGE_ANALYSIS.md) - 测试覆盖率分析
- [TEST_RESULTS.md](./TEST_RESULTS.md) - 测试执行结果
- [GAME_SERVICE_TEST_RESULTS.md](./GAME_SERVICE_TEST_RESULTS.md) - GameService测试结果

---

**版本**: 1.0
**最后更新**: 2025-01-27
**维护者**: Claude Code
