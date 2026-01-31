/**
 * 游戏核心逻辑服务
 * 实现Mastermind密码验证算法
 */

import { Color } from '../constants/Colors';
import { GameConfig } from '../constants/GameConfig';
import { GameState, createInitialGameState, GameMode } from '../models/GameState';
import { Attempt, createAttempt } from '../models/Attempt';
import { Level } from '../models/Level';

interface HintResult {
  state: GameState;
  hint: string;
}

interface EvaluationResult {
  hits: number;
  pseudoHits: number;
}

// 位置级别的评估结果（用于mapped模式）
export type PositionHint = 'hit' | 'pseudoHit' | 'miss';

interface PositionEvaluationResult {
  hits: number;
  pseudoHits: number;
  positionHints: PositionHint[];  // 每个位置的提示
}

export class GameService {
  /**
   * 评估猜测结果 (Mastermind算法)
   * @param guess 玩家的猜测
   * @param password 正确密码
   * @returns 包含hits和pseudoHits的结果
   */
  static evaluateGuess(guess: Color[], password: Color[]): EvaluationResult {
    if (guess.length !== password.length) {
      throw new Error('Guess length must match password length');
    }

    const hits: number = guess.filter((color: Color, index: number) => color === password[index]).length;

    // 调试日志
    console.log(`=== 评估猜测 ===`);
    console.log(`密码: ${password.join(', ')}`);
    console.log(`猜测: ${guess.join(', ')}`);
    console.log(`命中: ${hits}`);

    // 计算pseudoHits需要排除已匹配的hits
    const guessRemaining: Color[] = [];
    const passwordRemaining: Color[] = [];

    for (let i = 0; i < guess.length; i++) {
      if (guess[i] !== password[i]) {
        guessRemaining.push(guess[i]);
        passwordRemaining.push(password[i]);
      }
    }

    console.log(`剩余猜测: ${guessRemaining.join(', ')}`);
    console.log(`剩余密码: ${passwordRemaining.join(', ')}`);

    // 计算伪猜中数（颜色正确但位置错误）
    let pseudoHits: number = 0;
    for (let i = 0; i < guessRemaining.length; i++) {
      const color = guessRemaining[i];
      const index = passwordRemaining.indexOf(color);
      if (index !== -1) {
        passwordRemaining.splice(index, 1); // 移除已匹配的颜色，避免重复计数
        pseudoHits++;
        console.log(`  匹配颜色 ${color} 在位置 ${index}, 伪命中累计: ${pseudoHits}`);
      }
    }

    console.log(`伪命中: ${pseudoHits}`);
    console.log(`================`);

    return { hits, pseudoHits };
  }

  /**
   * 评估猜测结果（位置级别，用于mapped模式）
   * 返回每个位置的具体提示（hit/pseudoHit/miss）
   * @param guess 玩家的猜测
   * @param password 正确密码
   * @returns 包含hits、pseudoHits和每个位置提示的结果
   */
  static evaluateGuessMapped(guess: Color[], password: Color[]): PositionEvaluationResult {
    if (guess.length !== password.length) {
      throw new Error('Guess length must match password length');
    }

    console.log(`=== 评估猜测（位置级别/Mapped模式） ===`);
    console.log(`密码: ${password.join(', ')}`);
    console.log(`猜测: ${guess.join(', ')}`);

    const positionHints: PositionHint[] = [];
    const hits: number = guess.filter((color: Color, index: number) => color === password[index]).length;

    console.log(`命中: ${hits}`);

    // 为每个位置生成提示
    for (let i = 0; i < guess.length; i++) {
      if (guess[i] === password[i]) {
        // 位置和颜色都对
        positionHints.push('hit');
        console.log(`  位置${i + 1}: ${guess[i]} = ${password[i]} → HIT (绿色)`);
      } else if (password.includes(guess[i])) {
        // 颜色对但位置错
        positionHints.push('pseudoHit');
        console.log(`  位置${i + 1}: ${guess[i]} ≠ ${password[i]} (颜色存在) → PSEUDO-HIT (黄色)`);
      } else {
        // 颜色和位置都错
        positionHints.push('miss');
        console.log(`  位置${i + 1}: ${guess[i]} (颜色不存在) → MISS (灰色)`);
      }
    }

    const pseudoHits = positionHints.filter(h => h === 'pseudoHit').length;

    console.log(`伪命中: ${pseudoHits}`);
    console.log(`位置提示: [${positionHints.join(', ')}]`);
    console.log(`================`);

    return { hits, pseudoHits, positionHints };
  }

  /**
   * 提交猜测并更新游戏状态
   * @param state 当前游戏状态
   * @param guess 玩家的猜测
   * @returns 更新后的游戏状态
   */
  static submitGuess(state: GameState, guess: Color[]): GameState {
    if (state.status !== 'playing') {
      throw new Error('Game is not in playing state');
    }

    if (guess.length !== GameConfig.PASSWORD_LENGTH) {
      throw new Error('Guess length must be 4');
    }

    // 根据提示模式选择评估方法
    let hits: number;
    let pseudoHits: number;
    let positionHints: PositionHint[] | undefined;

    if (state.level.hintMode === 'mapped') {
      // Mapped模式：使用位置级别评估
      const evaluation = GameService.evaluateGuessMapped(guess, state.level.password);
      hits = evaluation.hits;
      pseudoHits = evaluation.pseudoHits;
      positionHints = evaluation.positionHints;
      console.log(`使用Mapped模式评估，位置提示: [${positionHints.join(', ')}]`);
    } else {
      // Unmapped模式：使用标准评估
      const evaluation = GameService.evaluateGuess(guess, state.level.password);
      hits = evaluation.hits;
      pseudoHits = evaluation.pseudoHits;
      console.log(`使用Unmapped模式评估`);
    }

    // 创建猜测记录
    const attempt: Attempt = createAttempt(guess, hits, pseudoHits, positionHints);

    // 创建新的游戏状态
    const newAttempts = state.attempts.slice();
    newAttempts.push(attempt);

    const newState: GameState = {
      level: state.level,
      attempts: newAttempts,
      currentGuess: [null, null, null, null],
      status: 'playing',
      hintsUsed: state.hintsUsed,
      startTime: state.startTime,
      mode: state.mode
    };

    // 检查游戏是否结束
    if (hits === GameConfig.PASSWORD_LENGTH) {
      newState.status = 'won';
    } else if (newAttempts.length >= state.level.maxAttempts) {
      newState.status = 'lost';
    }

    return newState;
  }

  /**
   * 检查游戏是否结束
   * @param state 游戏状态
   * @returns 游戏是否结束
   */
  static isGameEnd(state: GameState): boolean {
    return state.status !== 'playing';
  }

  /**
   * 获取剩余尝试次数
   * @param state 游戏状态
   * @returns 剩余次数
   */
  static getRemainingAttempts(state: GameState): number {
    return state.level.maxAttempts - state.attempts.length;
  }

  /**
   * 检查玩家是否获胜
   * @param state 游戏状态
   * @returns 是否获胜
   */
  static isWin(state: GameState): boolean {
    return state.status === 'won';
  }

  /**
   * 计算星级评分
   * @param attemptsUsed 使用的尝试次数
   * @param maxAttempts 最大尝试次数
   * @returns 星级 (1-3)
   */
  static calculateStars(attemptsUsed: number, maxAttempts: number): number {
    const ratio = attemptsUsed / maxAttempts;

    if (ratio <= GameConfig.STAR_3_THRESHOLD) {
      return 3;
    } else if (ratio <= GameConfig.STAR_2_THRESHOLD) {
      return 2;
    } else {
      return 1;
    }
  }

  /**
   * 生成随机密码
   * @param colorCount 可用颜色数量 (4-6)
   * @returns 随机密码
   */
  static generatePassword(colorCount: number): Color[] {
    const allColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];
    const colors = allColors.slice(0, colorCount);

    const password: Color[] = [];
    for (let i = 0; i < GameConfig.PASSWORD_LENGTH; i++) {
      const randomIndex = Math.floor(Math.random() * colors.length);
      password.push(colors[randomIndex]);
    }

    return password;
  }

  /**
   * 创建新的游戏
   * @param level 关卡配置
   * @param mode 游戏模式
   * @returns 初始游戏状态
   */
  static createGame(level: Level, mode: GameMode): GameState {
    return createInitialGameState(level, mode);
  }

  /**
   * 更新当前猜测的某个槽位
   * @param state 当前游戏状态
   * @param slotIndex 槽位索引 (0-3)
   * @param color 选择的颜色
   * @returns 更新后的游戏状态
   */
  static updateCurrentGuess(state: GameState, slotIndex: number, color: Color): GameState {
    if (slotIndex < 0 || slotIndex >= GameConfig.PASSWORD_LENGTH) {
      throw new Error('Invalid slot index');
    }

    const newGuess: (Color | null)[] = [];
    for (let i = 0; i < state.currentGuess.length; i++) {
      if (i === slotIndex) {
        newGuess.push(color);
      } else {
        newGuess.push(state.currentGuess[i]);
      }
    }

    const newState: GameState = {
      level: state.level,
      attempts: state.attempts,
      currentGuess: newGuess,
      status: state.status,
      hintsUsed: state.hintsUsed,
      startTime: state.startTime,
      mode: state.mode
    };

    return newState;
  }

  /**
   * 清空当前猜测
   * @param state 当前游戏状态
   * @returns 更新后的游戏状态
   */
  static clearCurrentGuess(state: GameState): GameState {
    const newState: GameState = {
      level: state.level,
      attempts: state.attempts,
      currentGuess: [null, null, null, null],
      status: state.status,
      hintsUsed: state.hintsUsed,
      startTime: state.startTime,
      mode: state.mode
    };

    return newState;
  }

  /**
   * 检查当前猜测是否完整
   * @param state 游戏状态
   * @returns 是否完整
   */
  static isCurrentGuessComplete(state: GameState): boolean {
    return state.currentGuess.every((color: Color | null) => color !== null);
  }

  /**
   * 使用提示
   * @param state 游戏状态
   * @param hintFunction 提示函数
   * @returns 更新后的游戏状态和提示内容
   */
  static useHint(
    state: GameState,
    hintFunction: (password: Color[]) => string
  ): HintResult {
    if (state.level.hintMode === 'unmapped') {
      throw new Error('This level does not support hints');
    }

    const hint = hintFunction(state.level.password);

    const newState: GameState = {
      level: state.level,
      attempts: state.attempts,
      currentGuess: state.currentGuess,
      status: state.status,
      hintsUsed: state.hintsUsed + 1,
      startTime: state.startTime,
      mode: state.mode
    };

    return {
      state: newState,
      hint: hint
    };
  }
}
