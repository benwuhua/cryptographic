/**
 * 应用设置模型
 */

// 主题类型
export type ThemeMode = 'light' | 'dark' | 'system';

// 应用设置
export interface AppSettings {
  soundEnabled: boolean;       // 音效开关
  vibrationEnabled: boolean;   // 振动开关
  theme: ThemeMode;            // 主题模式
  colorBlindMode: boolean;     // 色盲模式
}

// 默认设置
export const DEFAULT_SETTINGS: AppSettings = {
  soundEnabled: true,
  vibrationEnabled: true,
  theme: 'system',
  colorBlindMode: false
};
