import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

export default function abilityTest() {
  describe('BasicTests', () => {
    beforeAll(() => {
      console.info('BasicTests beforeAll called');
    })

    afterAll(() => {
      console.info('BasicTests afterAll called');
    })

    beforeEach(() => {
      console.info('BasicTests beforeEach called');
    })

    afterEach(() => {
      console.info('BasicTests afterEach called');
    })

    it('testBasicAssertion', 0, () => {
      console.info('testBasicAssertion called');
      let a = 1;
      let b = 1;
      expect(a).assertEqual(b);
    })

    it('testStringAssertion', 0, () => {
      console.info('testStringAssertion called');
      let str = 'Hello World';
      expect(str).assertContain('Hello');
    })
  })
}
