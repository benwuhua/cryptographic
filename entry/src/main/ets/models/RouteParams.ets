/**
 * 路由参数模型
 */

import { Color } from '../constants/Colors';
import { Difficulty } from './Level';
import { GameMode } from './GameState';

// 关卡选择页参数
export interface LevelSelectParams {
  difficulty: Difficulty;
}

// 游戏页参数
export interface GamePageParams {
  mode: GameMode;
  difficulty?: Difficulty;      // solo模式必填
  levelId?: number;             // solo模式必填
  password?: Color[];           // duel模式: 对手设置的密码
  timeLimit?: number;           // duel模式: 时间限制(秒)
  colorCount?: number;          // practice模式: 颜色数量
}

// 结果页参数
export interface ResultPageParams {
  mode: GameMode;
  isWin: boolean;               // 是否获胜
  attempts: number;             // 使用的猜测次数
  maxAttempts: number;          // 最大猜测次数
  timeSpent: number;            // 用时(毫秒)
  stars?: number;               // 星级 (solo模式)
  levelId?: number;             // 关卡ID (solo模式)
  difficulty?: Difficulty;      // 难度 (solo模式)
  password?: Color[];           // 正确密码 (显示用)
}

// 创建单人模式游戏参数
export function createSoloGameParams(difficulty: Difficulty, levelId: number): GamePageParams {
  return {
    mode: 'solo',
    difficulty,
    levelId
  };
}

// 创建双人模式游戏参数
export function createDuelGameParams(password: Color[], timeLimit?: number): GamePageParams {
  return {
    mode: 'duel',
    password,
    timeLimit
  };
}

// 创建练习模式游戏参数
export function createPracticeGameParams(colorCount: number): GamePageParams {
  return {
    mode: 'practice',
    colorCount
  };
}
