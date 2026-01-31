/**
 * 猜测记录模型
 */

import { Color } from '../constants/Colors';
import { PositionHint } from '../services/GameService';

// 单次猜测记录
export interface Attempt {
  guess: Color[];        // 猜测的颜色序列
  hits: number;          // 猜中数（颜色和位置都正确）
  pseudoHits: number;    // 伪猜中数（颜色正确但位置错误）
  positionHints?: PositionHint[];  // 位置级别的提示（用于mapped模式）
  timestamp: number;     // 猜测时间戳
}

// 猜测评估结果
export interface EvaluationResult {
  hits: number;
  pseudoHits: number;
}

// 创建猜测记录
export function createAttempt(
  guess: Color[],
  hits: number,
  pseudoHits: number,
  positionHints?: PositionHint[]
): Attempt {
  return {
    guess,
    hits,
    pseudoHits,
    positionHints,
    timestamp: Date.now()
  };
}
