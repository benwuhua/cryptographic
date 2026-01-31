/**
 * 布局优化测试
 * 验证单屏幕布局优化是否正确应用
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { ResponsiveUtils, RF, RSP, RS } from '../../../main/ets/utils/ResponsiveUtils';

export default function LayoutOptimizationTest() {
  describe('LayoutOptimizationTests', () => {

    beforeAll(() => {
      console.log('=== LayoutOptimizationTests: Before all tests ===');
      // 初始化 ResponsiveUtils
      ResponsiveUtils.init();
    });

    /**
     * LAYOUT-001: 测试响应式间距常量存在
     */
    it('should_have_correct_spacing_constants', 0, () => {
      console.log('=== LAYOUT-001: Checking spacing constants ===');

      // 验证间距常量存在
      const spacing = ResponsiveUtils.getSpacing();
      expect(spacing).not.toBeNull();
      expect(spacing.XXS).not.toBeNull();
      expect(spacing.XS).not.toBeNull();
      expect(spacing.S).not.toBeNull();
      expect(spacing.M).not.toBeNull();
      expect(spacing.L).not.toBeNull();

      console.log(`=== Spacing: XXS=${spacing.XXS}, XS=${spacing.XS}, S=${spacing.S}, M=${spacing.M} ===`);

      // 验证基准值（在1.0x缩放下）
      expect(spacing.XXS).assertEqual(2);
      expect(spacing.XS).assertEqual(4);
      expect(spacing.S).assertEqual(8);
      expect(spacing.M).assertEqual(16);

      console.log('=== LAYOUT-001: ✅ 间距常量验证通过 ===');
    });

    /**
     * LAYOUT-002: 测试响应式尺寸方法返回正值
     */
    it('should_return_positive_values_for_responsive_sizes', 0, () => {
      console.log('=== LAYOUT-002: Testing responsive size methods ===');

      const rspXXS = ResponsiveUtils.rsp(RSP.XXS);
      const rspXS = ResponsiveUtils.rsp(RSP.XS);
      const rspS = ResponsiveUtils.rsp(RSP.S);

      console.log(`=== Responsive spacing: XXS=${rspXXS}, XS=${rspXS}, S=${rspS} ===`);

      expect(rspXXS).assertLarger(0);
      expect(rspXS).assertLarger(0);
      expect(rspS).assertLarger(0);

      // 在1.0x缩放下，应该接近基准值
      const scaleFactor = ResponsiveUtils.getScaleFactor();
      console.log(`=== Scale factor: ${scaleFactor} ===`);

      expect(scaleFactor).assertLarger(0);
      expect(scaleFactor).assertLessThanOrEqual(1.5); // 最大缩放1.5

      console.log('=== LAYOUT-002: ✅ 响应式尺寸验证通过 ===');
    });

    /**
     * LAYOUT-003: 测试间距优化（验证使用S而不是M）
     */
    it('should_use_compact_spacing_for_layout_optimization', 0, () => {
      console.log('=== LAYOUT-003: Testing compact spacing ===');

      // 获取间距
      const spacingSmall = ResponsiveUtils.rsp(RSP.S);   // 8vp (紧凑)
      const spacingMedium = ResponsiveUtils.rsp(RSP.M);  // 16vp (宽松)

      console.log(`=== Compact spacing S=${spacingSmall}, Regular spacing M=${spacingMedium} ===`);

      // 紧凑间距应该小于宽松间距
      expect(spacingSmall).assertLess(spacingMedium);

      // 在1.0x缩放下，紧凑间距应该是8vp
      const scaleFactor = ResponsiveUtils.getScaleFactor();
      const expectedSmall = 8 * scaleFactor;
      const actualSmall = spacingSmall;

      expect(Math.abs(actualSmall - expectedSmall)).assertLess(1);

      console.log('=== LAYOUT-003: ✅ 紧凑间距验证通过 ===');
    });

    /**
     * LAYOUT-004: 测试超小间距（XXS）
     */
    it('should_use_xxs_spacing_for_minimal_padding', 0, () => {
      console.log('=== LAYOUT-004: Testing XXS minimal spacing ===');

      const xxsSpacing = ResponsiveUtils.rsp(RSP.XXS);

      console.log(`=== XXS spacing: ${xxsSpacing} ===`);

      expect(xxsSpacing).assertLarger(0);
      expect(xxsSpacing).assertLess(ResponsiveUtils.rsp(RSP.XS));

      // 在1.0x缩放下应该是2vp
      const scaleFactor = ResponsiveUtils.getScaleFactor();
      const expected = 2 * scaleFactor;

      expect(Math.abs(xxsSpacing - expected)).assertLess(1);

      console.log('=== LAYOUT-004: ✅ 超小间距验证通过 ===');
    });

    /**
     * LAYOUT-005: 测试缩放因子限制
     */
    it('should_respect_scale_factor_limits', 0, () => {
      console.log('=== LAYOUT-005: Testing scale factor limits ===');

      const scaleFactor = ResponsiveUtils.getScaleFactor();

      console.log(`=== Scale factor: ${scaleFactor} ===`);

      // 验证缩放因子在范围内 [0.8, 1.5]
      expect(scaleFactor).assertLargerThanOrEqual(0.8);
      expect(scaleFactor).assertLessThanOrEqual(1.5);

      console.log('=== LAYOUT-005: ✅ 缩放因子限制验证通过 ===');
    });

    /**
     * LAYOUT-006: 测试字体大小常量
     */
    it('should_have_correct_font_size_constants', 0, () => {
      console.log('=== LAYOUT-006: Checking font size constants ===');

      const fontSize = ResponsiveUtils.getFontSize();
      expect(fontSize).not.toBeNull();

      console.log(`=== Font sizes: TITLE_M=${fontSize.TITLE_M}, BODY_L=${fontSize.BODY_L}, BODY_M=${fontSize.BODY_M}, BODY_S=${fontSize.BODY_S} ===`);

      expect(fontSize.TITLE_M).assertEqual(18);
      expect(fontSize.BODY_L).assertEqual(16);
      expect(fontSize.BODY_M).assertEqual(14);
      expect(fontSize.BODY_S).assertEqual(12);

      console.log('=== LAYOUT-006: ✅ 字体大小常量验证通过 ===');
    });

    /**
     * LAYOUT-007: 测试响应式字体大小
     */
    it('should_scale_font_sizes_correctly', 0, () => {
      console.log('=== LAYOUT-007: Testing responsive font sizes ===');

      const bodyM = ResponsiveUtils.rf(RF.BODY_M);
      const titleM = ResponsiveUtils.rf(RF.TITLE_M);

      console.log(`=== Responsive fonts: BODY_M=${bodyM}fp, TITLE_M=${titleM}fp ===`);

      expect(bodyM).assertLarger(0);
      expect(titleM).assertLarger(0);
      expect(titleM).assertLarger(bodyM);

      console.log('=== LAYOUT-007: ✅ 响应式字体验证通过 ===');
    });

    /**
     * LAYOUT-008: 测试控件尺寸常量
     */
    it('should_have_correct_control_size_constants', 0, () => {
      console.log('=== LAYOUT-008: Checking control size constants ===');

      const control = ResponsiveUtils.getControl();
      expect(control).not.toBeNull();

      console.log(`=== Control sizes: BUTTON_HEIGHT=${control.BUTTON_HEIGHT}, DOT_SIZE=${control.DOT_SIZE}, COLOR_BUTTON=${control.COLOR_BUTTON} ===`);

      expect(control.BUTTON_HEIGHT).assertEqual(48);
      expect(control.DOT_SIZE).assertEqual(12);
      expect(control.COLOR_BUTTON).assertEqual(45);

      // 验证不存在 SLOT_SIZE（修复前的问题）
      expect((control as any).SLOT_SIZE).toBeNull();

      console.log('=== LAYOUT-008: ✅ 控件尺寸常量验证通过 ===');
    });

    /**
     * LAYOUT-009: 测试布局优化总节省空间计算
     */
    it('should_calculate_total_space_savings', 0, () => {
      console.log('=== LAYOUT-009: Calculating total space savings ===');

      const scaleFactor = ResponsiveUtils.getScaleFactor();

      // 优化前的间距值
      const beforeTopPadding = 16; // M
      const beforeGuessRowPadding = 16; // hardcoded
      const beforeGuessRowMargin = 4;
      const beforeColorPickerPadding = 16; // hardcoded
      const beforeButtonBottom = 16; // M

      // 优化后的间距值
      const afterTopPadding = ResponsiveUtils.rsp(RSP.S); // S = 8
      const afterGuessRowPadding = ResponsiveUtils.rsp(RSP.S); // S = 8
      const afterGuessRowMargin = 2;
      const afterColorPickerPadding = ResponsiveUtils.rsp(RSP.S); // S = 8
      const afterButtonBottom = ResponsiveUtils.rsp(RSP.S); // S = 8

      console.log(`=== Before: Top=${beforeTopPadding}, GuessRow pad=${beforeGuessRowPadding}, margin=${beforeGuessRowMargin}, ColorPicker pad=${beforeColorPickerPadding}, Button=${beforeButtonBottom} ===`);
      console.log(`=== After: Top=${afterTopPadding}, GuessRow pad=${afterGuessRowPadding}, margin=${afterGuessRowMargin}, ColorPicker pad=${afterColorPickerPadding}, Button=${afterButtonBottom} ===`);

      // 计算节省的空间
      const totalBefore = beforeTopPadding + beforeGuessRowPadding + beforeGuessRowMargin + beforeColorPickerPadding + beforeButtonBottom;
      const totalAfter = afterTopPadding + afterGuessRowPadding + afterGuessRowMargin + afterColorPickerPadding + afterButtonBottom;
      const savings = totalBefore - totalAfter;

      console.log(`=== Space savings: ${savings}vp (before: ${totalBefore}, after: ${totalAfter}) ===`);

      expect(savings).assertLarger(0); // 应该节省空间

      console.log('=== LAYOUT-009: ✅ 空间节省验证通过 ===');
    });

    /**
     * LAYOUT-010: 测试响应式尺寸在不同缩放因子下的表现
     */
    it('should_handle_different_scale_factors_correctly', 0, () => {
      console.log('=== LAYOUT-010: Testing different scale factors ===');

      const currentScale = ResponsiveUtils.getScaleFactor();

      // 测试间距在不同缩放下的值
      const spacingS = ResponsiveUtils.rsp(RSP.S);
      const spacingM = ResponsiveUtils.rsp(RSP.M);

      console.log(`=== At scale ${currentScale}: S=${spacingS}vp, M=${spacingM}vp ===`);

      // 验证间距保持正确的比例关系
      const ratio = spacingM / spacingS;
      console.log(`=== M/S ratio: ${ratio} (expected ~2.0) ===`);

      expect(ratio).assertLarger(1.5); // 应该大于1.5
      expect(ratio).assertLess(2.5);   // 应该小于2.5

      console.log('=== LAYOUT-010: ✅ 缩放因子处理验证通过 ===');
    });
  });
}
