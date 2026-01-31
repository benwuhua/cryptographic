import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

export default function minimalTest() {
  describe('MinimalTests', () => {
    beforeAll(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'MinimalTests beforeAll called');
    })

    beforeEach(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'MinimalTests beforeEach called');
    })

    afterEach(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'MinimalTests afterEach called');
    })

    afterAll(() => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'MinimalTests afterAll called');
    })

    it('testPass', 0, () => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'testPass called');
      let a = 1;
      let b = 1;
      expect(a).assertEqual(b);
    })
  })
}
