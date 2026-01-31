/**
 * 关卡数据模型
 */

import { Color } from '../constants/Colors';

// 难度类型
export type Difficulty = 'easy' | 'hard';

// 提示模式
export type HintMode = 'mapped' | 'unmapped';

// 提示位置
export type HintPosition = 'bottom' | 'right';

// 关卡配置
export interface Level {
  id: number;                    // 关卡ID (从1开始)
  difficulty: Difficulty;        // 难度
  password: Color[];             // 正确密码 (4位)
  colorCount: number;            // 可用颜色数量 (4-6)
  hintMode: HintMode;            // 提示模式（mapped=简单/困难=unmapped）
  hintPosition: HintPosition;     // 提示位置（bottom=简单/困难=right）
  maxAttempts: number;           // 最大尝试次数
}

// 创建关卡的工厂函数
export function createLevel(
  id: number,
  difficulty: Difficulty,
  password: Color[],
  colorCount: number
): Level {
  return {
    id,
    difficulty,
    password,
    colorCount,
    hintMode: difficulty === 'easy' ? 'mapped' : 'unmapped',
    hintPosition: difficulty === 'easy' ? 'bottom' : 'right',
    maxAttempts: 7
  };
}
