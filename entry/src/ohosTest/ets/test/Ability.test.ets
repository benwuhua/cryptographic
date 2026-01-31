import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

// 导入简化测试
import minimalTest from './MinimalTest.test';
import basicTest from './BasicTest.test';
import simpleTest from './SimpleTest.test';

// 导入业务测试（验证算法 bug）
import gameServiceTest from './GameService.test';

// 导入新增的测试套件
import practiceModeTest from './PracticeModeTest';
import gamePageLifecycleTest from './GamePageLifecycleTest';
import uiIntegrationTest from './UIIntegrationTest';

export default function abilityTest() {
  // 注册所有测试套件
  minimalTest();
  basicTest();
  simpleTest();

  // 注册业务测试（验证核心算法）
  console.log('========== 注册 GameService 算法测试 ==========');
  gameServiceTest();

  // 注册新增的测试套件
  console.log('========== 注册练习模式测试 ==========');
  practiceModeTest();

  console.log('========== 注册页面生命周期测试 ==========');
  gamePageLifecycleTest();

  console.log('========== 注册UI集成测试 ==========');
  uiIntegrationTest();

  // 系统测试套件
  describe('ActsAbilityTest', () => {
    beforeAll(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityTest beforeAll');
    })

    beforeEach(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityTest beforeEach');
    })

    afterEach(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityTest afterEach');
    })

    afterAll(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityTest afterAll');
    })

    it('assertContain', 0, () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'AbilityTest it begin');
      let a = 'abc';
      let b = 'b';
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    })
  })
}