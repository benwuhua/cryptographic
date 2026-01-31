/**
 * 简单测试文件 - 验证测试框架
 */

import { describe, it, expect } from '@ohos/hypium';

export default function SimpleTest() {
  describe('SimpleTests', () => {
    it('should pass a simple test', 0, () => {
      const a = 1;
      const b = 1;
      expect(a).assertEqual(b);
    });

    it('should test addition', 0, () => {
      const result = 2 + 2;
      expect(result).assertEqual(4);
    });
  });
}
