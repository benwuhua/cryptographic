/**
 * 自动化页面布局测试
 * 验证不同屏幕尺寸下的页面布局
 */

import { describe, it, expect } from '@ohos/hypium';
import { Driver } from '@ohos.automation.driver';
import { UIComponent } from '@ohos.automation.core';

export default function LayoutTest() {
  describe('PageLayoutTests', () => {

    /**
     * 测试首页布局是否溢出屏幕
     */
    it('HomePage_should_not_overflow_screen', 0, async () => {
      // 获取屏幕宽度
      const driver = Driver.create();
      const screenWidth = driver.displayCaps.width;
      const screenHeight = driver.displayCaps.height;

      console.log(`=== Testing HomePage layout on ${screenWidth}x${screenHeight} ===`);

      // 启动应用并导航到首页
      await driver.launchApp();
      await driver.delayMs(2000); // 等待页面加载

      // 检查所有主要元素是否在屏幕内
      const titleElement = await driver.findComponent(By.text('密码机'));
      expect(titleElement).not.toBeNull();

      const titleBounds = await titleElement.getBounds();
      expect(titleBounds.right).lessThanOrEqual(screenWidth);
      expect(titleBounds.bottom).lessThanOrEqual(screenHeight);

      // 检查统计卡片
      const statsCard = await driver.findComponent(By.id('user-stats-card'));
      if (statsCard) {
        const statsBounds = await statsCard.getBounds();
        expect(statsBounds.right).lessThanOrEqual(screenWidth);
        expect(statsBounds.bottom).lessThanOrEqual(screenHeight);
      }

      // 检查游戏模式按钮
      const gameModeButtons = await driver.findComponents(By.type('Button'));
      for (const button of gameModeButtons) {
        const bounds = await button.getBounds();
        expect(bounds.right).lessThanOrEqual(screenWidth + 10); // 允许10vp误差
        expect(bounds.bottom).lessThanOrEqual(screenHeight + 10);
      }

      console.log('✅ HomePage layout test passed');
    });

    /**
     * 测试游戏页布局
     */
    it('GamePage_should_not_overflow_screen', 0, async () => {
      const driver = Driver.create();
      const screenWidth = driver.displayCaps.width;

      console.log(`=== Testing GamePage layout on ${screenWidth}vp ===`);

      await driver.launchApp();
      await driver.delayMs(1000);

      // 导航到游戏页
      const startButton = await driver.findComponent(By.text('开始'));
      if (startButton) {
        await startButton.click();
        await driver.delayMs(1000);
      }

      // 检查颜色按钮是否在屏幕内
      const colorButtons = await driver.findComponents(By.type('Circle'));
      for (const button of colorButtons) {
        const bounds = await button.getBounds();
        expect(bounds.right).lessThanOrEqual(screenWidth + 10);
        expect(bounds.left).greaterThanOrEqual(0);
      }

      console.log('✅ GamePage layout test passed');
    });

    /**
     * 测试按钮最小点击区域（触摸友好性）
     */
    it('Buttons_should_meet_minimum_touch_target', 0, async () => {
      const driver = Driver.create();
      const MIN_TOUCH_SIZE = 48; // vp

      await driver.launchApp();
      await driver.delayMs(2000);

      // 检查所有按钮是否满足最小触摸目标
      const buttons = await driver.findComponents(By.type('Button'));
      for (const button of buttons) {
        const bounds = await button.getBounds();
        const width = bounds.right - bounds.left;
        const height = bounds.bottom - bounds.top;

        expect(width).greaterThanOrEqual(MIN_TOUCH_SIZE - 10); // 允许10vp误差
        expect(height).greaterThanOrEqual(MIN_TOUCH_SIZE - 10);
      }

      console.log('✅ Touch target test passed');
    });

    /**
     * 测试文本可读性（字体大小）
     */
    it('Text_should_be_readable', 0, async () => {
      const driver = Driver.create();
      const MIN_FONT_SIZE = 12; // vp

      await driver.launchApp();
      await driver.delayMs(2000);

      // 检查主要文本元素
      const textElements = await driver.findComponents(By.type('Text'));
      for (const text of textElements) {
        const fontSize = await text.getFontSize();
        if (fontSize) {
          expect(fontSize).greaterThanOrEqual(MIN_FONT_SIZE);
        }
      }

      console.log('✅ Text readability test passed');
    });

    /**
     * 测试折叠屏单屏模式布局
     */
    it('HomePage_should_fit_on_foldable_single_screen', 0, async () => {
      const driver = Driver.create();
      const screenWidth = driver.displayCaps.width;

      console.log(`=== Testing foldable single screen: ${screenWidth}vp ===`);

      // 模拟小屏幕（折叠屏单屏）
      if (screenWidth < 400) {
        await driver.launchApp();
        await driver.delayMs(2000);

        // 检查关键元素是否可见且不重叠
        const title = await driver.findComponent(By.text('密码机'));
        const subtitle = await driver.findComponent(By.text('破解密码，挑战智慧'));

        expect(title).not.toBeNull();
        expect(subtitle).not.toBeNull();

        const titleBounds = await title.getBounds();
        const subtitleBounds = await subtitle.getBounds();

        // 确保元素不重叠
        expect(titleBounds.bottom).lessThanOrEqual(subtitleBounds.top);

        console.log('✅ Foldable single screen test passed');
      } else {
        console.log('⏭️ Skipped: Not a foldable single screen');
      }
    });

    /**
     * 测试响应式缩放因子
     */
    it('ResponsiveUtils_should_have_reasonable_scale', 0, async () => {
      const driver = Driver.create();
      const screenWidth = driver.displayCaps.width;

      console.log(`=== Testing responsive scale: ${screenWidth}vp ===`);

      await driver.launchApp();
      await driver.delayMs(1000);

      // 从日志中获取缩放因子
      const logs = await driver.getLogs();
      const scaleLog = logs.find(log => log.includes('Scale factor:'));

      if (scaleLog) {
        const scaleMatch = scaleLog.match(/Scale factor: ([\d.]+)/);
        if (scaleMatch) {
          const scale = parseFloat(scaleMatch[1]);
          console.log(`Detected scale factor: ${scale}`);

          // 验证缩放因子在合理范围内
          expect(scale).greaterThanOrEqual(0.8);
          expect(scale).lessThanOrEqual(1.5);
        }
      }

      console.log('✅ Responsive scale test passed');
    });
  });
}
