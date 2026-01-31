/**
 * 颜色类型定义与色值常量
 */

// 游戏中使用的颜色类型
export type Color = 'red' | 'yellow' | 'green' | 'blue' | 'purple' | 'orange';

// 颜色值接口
export interface ColorValuesType {
  red: string;
  yellow: string;
  green: string;
  blue: string;
  purple: string;
  orange: string;
}

// 颜色名称接口
export interface ColorNamesType {
  red: string;
  yellow: string;
  green: string;
  blue: string;
  purple: string;
  orange: string;
}

// 提示颜色接口
export interface HintColorsType {
  hit: string;
  pseudoHit: string;
  miss: string;
}

// 所有可用颜色列表
export const ALL_COLORS: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];

// 颜色对应的十六进制色值
export const ColorValues: ColorValuesType = {
  red: '#E53935',
  yellow: '#FDD835',
  green: '#43A047',
  blue: '#1E88E5',
  purple: '#8E24AA',
  orange: '#FB8C00'
};

// 颜色对应的中文名称
export const ColorNames: ColorNamesType = {
  red: '红色',
  yellow: '黄色',
  green: '绿色',
  blue: '蓝色',
  purple: '紫色',
  orange: '橙色'
};

// 提示指示器颜色
export const HintColors: HintColorsType = {
  hit: '#4CAF50',      // 猜中 - 绿色
  pseudoHit: '#FFC107', // 伪猜中 - 黄色
  miss: '#E0E0E0'      // 未猜中 - 浅灰色
};

/**
 * 获取颜色的十六进制值
 * @param color 颜色类型
 * @returns 十六进制色值
 */
export function getColorValue(color: Color): string {
  switch (color) {
    case 'red':
      return ColorValues.red;
    case 'yellow':
      return ColorValues.yellow;
    case 'green':
      return ColorValues.green;
    case 'blue':
      return ColorValues.blue;
    case 'purple':
      return ColorValues.purple;
    case 'orange':
      return ColorValues.orange;
    default:
      return '#000000';
  }
}

/**
 * 获取颜色的中文名称
 * @param color 颜色类型
 * @returns 中文名称
 */
export function getColorName(color: Color): string {
  switch (color) {
    case 'red':
      return ColorNames.red;
    case 'yellow':
      return ColorNames.yellow;
    case 'green':
      return ColorNames.green;
    case 'blue':
      return ColorNames.blue;
    case 'purple':
      return ColorNames.purple;
    case 'orange':
      return ColorNames.orange;
    default:
      return '未知';
  }
}
