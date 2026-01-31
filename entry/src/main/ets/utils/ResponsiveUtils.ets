/**
 * 响应式布局工具类
 * 根据屏幕宽度动态计算尺寸，实现多屏幕适配
 */

import { display } from '@kit.ArkUI';

/**
 * 断点配置接口
 */
interface BreakpointsConfig {
  SMALL: number;
  MEDIUM: number;
  LARGE: number;
}

/**
 * 字体大小配置接口
 */
interface FontSizeConfig {
  TITLE_XL: number;
  TITLE_L: number;
  TITLE_M: number;
  BODY_L: number;
  BODY_M: number;
  BODY_S: number;
}

/**
 * 间距配置接口
 */
interface SpacingConfig {
  XXS: number;
  XS: number;
  S: number;
  M: number;
  L: number;
  XL: number;
  XXL: number;
}

/**
 * 控件尺寸配置接口
 */
interface ControlConfig {
  BUTTON_HEIGHT: number;
  BUTTON_SMALL: number;
  ICON_SIZE: number;
  DOT_SIZE: number;
  COLOR_BUTTON: number;
  INPUT_HEIGHT: number;
}

/**
 * 响应式配置
 */
export class ResponsiveConfig {
  // 屏幕断点（单位：vp）
  static readonly BREAKPOINTS: BreakpointsConfig = {
    SMALL: 360,   // 小屏手机
    MEDIUM: 480,  // 中屏手机
    LARGE: 720    // 大屏手机/平板
  };

  // 基准宽度（单位：vp）
  static readonly BASE_WIDTH = 360;

  // 基准字体大小（单位：fp）
  static readonly FONT_SIZE: FontSizeConfig = {
    TITLE_XL: 32,  // 超大标题 (36 → 32)
    TITLE_L: 24,   // 大标题 (28 → 24)
    TITLE_M: 16,   // 中等标题 (18 → 16)
    BODY_L: 14,   // 大正文 (16 → 14)
    BODY_M: 12,   // 中等正文 (14 → 12)
    BODY_S: 10    // 小正文 (12 → 10)
  };

  // 基准间距（单位：vp）
  static readonly SPACING: SpacingConfig = {
    XXS: 2,  // 超小
    XS: 4,   // 小
    S: 8,    // 中小
    M: 16,   // 中等
    L: 24,   // 大
    XL: 32,  // 超大
    XXL: 48   // 特大
  };

  // 基准控件尺寸（单位：vp）
  static readonly CONTROL: ControlConfig = {
    BUTTON_HEIGHT: 44,  // (48 → 44)
    BUTTON_SMALL: 32,   // (36 → 32)
    ICON_SIZE: 20,      // (24 → 20)
    DOT_SIZE: 10,       // (12 → 10)
    COLOR_BUTTON: 40,   // (45 → 40)
    INPUT_HEIGHT: 44    // (48 → 44)
  };
}

/**
 * 响应式工具类
 */
export class ResponsiveUtils {
  private static scaleFactor: number = 1.0;
  private static initialized: boolean = false;

  /**
   * 初始化（获取屏幕尺寸并计算缩放因子）
   */
  static init() {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      const screenWidth = displayInfo.width;
      let scaleFactor = screenWidth / ResponsiveConfig.BASE_WIDTH;

      // 限制缩放因子范围，避免在大屏或折叠屏上过度缩放
      // 最小0.8倍，最大1.5倍
      scaleFactor = Math.max(0.8, Math.min(1.5, scaleFactor));

      ResponsiveUtils.scaleFactor = scaleFactor;
      ResponsiveUtils.initialized = true;

      console.log(`=== ResponsiveUtils initialized ===`);
      console.log(`Screen width: ${screenWidth}vp`);
      console.log(`Scale factor: ${ResponsiveUtils.scaleFactor}`);
    } catch (error) {
      console.error('Failed to initialize ResponsiveUtils:', error);
      ResponsiveUtils.scaleFactor = 1.0;
      ResponsiveUtils.initialized = true;
    }
  }

  /**
   * 确保已初始化
   */
  private static ensureInitialized() {
    if (!ResponsiveUtils.initialized) {
      ResponsiveUtils.init();
    }
  }

  /**
   * 响应式字体大小（Responsive Font Size）
   * @param size 基准字体大小（fp）
   * @returns 响应式字体大小字符串
   */
  static rf(size: number): number {
    ResponsiveUtils.ensureInitialized();
    return Math.floor(size * ResponsiveUtils.scaleFactor);
  }

  /**
   * 响应式间距（Responsive Spacing）
   * @param size 基准间距（vp）
   * @returns 响应式间距值
   */
  static rsp(size: number): number {
    ResponsiveUtils.ensureInitialized();
    return Math.floor(size * ResponsiveUtils.scaleFactor);
  }

  /**
   * 响应式尺寸（Responsive Size）
   * @param size 基准尺寸（vp）
   * @returns 响应式尺寸值
   */
  static rs(size: number): number {
    ResponsiveUtils.ensureInitialized();
    return Math.floor(size * ResponsiveUtils.scaleFactor);
  }

  /**
   * 获取当前屏幕类型
   * @returns 屏幕类型：small/medium/large
   */
  static getScreenType(): 'small' | 'medium' | 'large' {
    ResponsiveUtils.ensureInitialized();
    const screenWidth = ResponsiveConfig.BASE_WIDTH * ResponsiveUtils.scaleFactor;

    if (screenWidth < ResponsiveConfig.BREAKPOINTS.MEDIUM) {
      return 'small';
    } else if (screenWidth < ResponsiveConfig.BREAKPOINTS.LARGE) {
      return 'medium';
    } else {
      return 'large';
    }
  }

  /**
   * 是否为小屏
   */
  static isSmallScreen(): boolean {
    return ResponsiveUtils.getScreenType() === 'small';
  }

  /**
   * 是否为中等屏幕
   */
  static isMediumScreen(): boolean {
    return ResponsiveUtils.getScreenType() === 'medium';
  }

  /**
   * 是否为大屏
   */
  static isLargeScreen(): boolean {
    return ResponsiveUtils.getScreenType() === 'large';
  }

  /**
   * 响应式宽度（根据屏幕类型返回不同宽度）
   * @param small 小屏宽度
   * @param medium 中屏宽度
   * @param large 大屏宽度
   * @returns 响应式宽度值（vp）
   */
  static responsiveWidth(small: number, medium: number, large: number): number {
    const screenType = ResponsiveUtils.getScreenType();
    switch (screenType) {
      case 'small':
        return ResponsiveUtils.rs(small);
      case 'medium':
        return ResponsiveUtils.rs(medium);
      case 'large':
        return ResponsiveUtils.rs(large);
      default:
        return ResponsiveUtils.rs(small);
    }
  }

  /**
   * 响应式字体（根据屏幕类型返回不同大小）
   * @param small 小屏字体
   * @param medium 中屏字体
   * @param large 大屏字体
   * @returns 响应式字体大小（fp）
   */
  static responsiveFont(small: number, medium: number, large: number): number {
    const screenType = ResponsiveUtils.getScreenType();
    switch (screenType) {
      case 'small':
        return ResponsiveUtils.rf(small);
      case 'medium':
        return ResponsiveUtils.rf(medium);
      case 'large':
        return ResponsiveUtils.rf(large);
      default:
        return ResponsiveUtils.rf(small);
    }
  }

  /**
   * 获取缩放因子
   */
  static getScaleFactor(): number {
    ResponsiveUtils.ensureInitialized();
    return ResponsiveUtils.scaleFactor;
  }
}

/**
 * 响应式尺寸常量（从ResponsiveConfig导出）
 */
export const RF = ResponsiveConfig.FONT_SIZE;
export const RSP = ResponsiveConfig.SPACING;
export const RS = ResponsiveConfig.CONTROL;
