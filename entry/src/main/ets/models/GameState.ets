/**
 * 游戏状态模型
 */

import { Color } from '../constants/Colors';
import { Level } from './Level';
import { Attempt } from './Attempt';

// 游戏状态枚举
export type GameStatus = 'playing' | 'won' | 'lost';

// 游戏模式
export type GameMode = 'solo' | 'duel' | 'practice';

// 完整游戏状态
export interface GameState {
  level: Level;                      // 当前关卡配置
  attempts: Attempt[];               // 猜测历史记录
  currentGuess: (Color | null)[];    // 当前输入 (null表示空槽)
  status: GameStatus;                // 游戏状态
  hintsUsed: number;                 // 已使用提示次数
  startTime: number;                 // 游戏开始时间戳
  mode: GameMode;                    // 游戏模式
}

// 创建初始游戏状态
export function createInitialGameState(level: Level, mode: GameMode): GameState {
  return {
    level,
    attempts: [],
    currentGuess: [null, null, null, null],
    status: 'playing',
    hintsUsed: 0,
    startTime: Date.now(),
    mode
  };
}

// 检查当前猜测是否完整（所有槽位都已填充）
export function isGuessComplete(currentGuess: (Color | null)[]): boolean {
  return currentGuess.every(color => color !== null);
}

// 获取剩余尝试次数
export function getRemainingAttempts(state: GameState): number {
  return state.level.maxAttempts - state.attempts.length;
}
