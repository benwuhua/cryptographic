/**
 * 关卡管理服务
 * 负责关卡获取、解锁、星级更新等逻辑
 */

import { Level, Difficulty, createLevel } from '../models/Level';
import { GameConfig } from '../constants/GameConfig';
import { GameService } from './GameService';
import { Color } from '../constants/Colors';

export class LevelService {
  /**
   * 根据关卡ID获取难度
   * @param levelId 关卡ID (1-600)
   * @returns 难度类型
   */
  static getDifficultyByLevelId(levelId: number): Difficulty {
    if (levelId >= 1 && levelId <= GameConfig.EASY_LEVEL_COUNT) {
      return 'easy';
    } else if (levelId > GameConfig.EASY_LEVEL_COUNT &&
               levelId <= GameConfig.EASY_LEVEL_COUNT + GameConfig.HARD_LEVEL_COUNT) {
      return 'hard';
    }
    throw new Error(`Invalid level ID: ${levelId}`);
  }

  /**
   * 根据关卡ID获取颜色数量
   * @param levelId 关卡ID
   * @param difficulty 难度
   * @returns 颜色数量
   */
  static getColorCount(levelId: number, difficulty: Difficulty): number {
    if (difficulty === 'easy') {
      return GameConfig.EASY_COLOR_COUNT;
    } else {
      // 高级模式根据关卡数递增颜色
      if (levelId <= GameConfig.HARD_COLOR_5_THRESHOLD) {
        return 4;
      } else if (levelId <= GameConfig.HARD_COLOR_6_THRESHOLD) {
        return 5;
      } else {
        return 6;
      }
    }
  }

  /**
   * 获取关卡总数
   * @param difficulty 难度
   * @returns 关卡总数
   */
  static getTotalLevels(difficulty: Difficulty): number {
    return difficulty === 'easy' ? GameConfig.EASY_LEVEL_COUNT : GameConfig.HARD_LEVEL_COUNT;
  }

  /**
   * 检查关卡是否解锁
   * @param levelId 要检查的关卡ID
   * @param unlockedLevels 已解锁的最高关卡
   * @returns 是否解锁
   */
  static isLevelUnlocked(levelId: number, unlockedLevels: number): boolean {
    return levelId <= unlockedLevels;
  }

  /**
   * 计算解锁的下一关卡
   * @param currentLevelId 当前关卡ID
   * @returns 下一关卡的ID
   */
  static getNextLevelId(currentLevelId: number): number | null {
    const totalLevels = GameConfig.EASY_LEVEL_COUNT + GameConfig.HARD_LEVEL_COUNT;
    if (currentLevelId < totalLevels) {
      return currentLevelId + 1;
    }
    return null; // 已通关所有关卡
  }

  /**
   * 计算通关百分比
   * @param unlockedLevels 已解锁关卡数
   * @param totalLevels 总关卡数
   * @returns 百分比 (0-100)
   */
  static getProgressPercentage(unlockedLevels: number, totalLevels: number): number {
    return Math.min(100, Math.round((unlockedLevels / totalLevels) * 100));
  }

  /**
   * 生成练习模式的关卡
   * @param colorCount 颜色数量 (4-6)
   * @returns 练习关卡配置
   */
  static generatePracticeLevel(colorCount: number = 4): Level {
    const password = GameService.generatePassword(colorCount);
    return createLevel(0, 'easy', password, colorCount);
  }

  /**
   * 生成双人对战模式的关卡
   * @param colorCount 颜色数量
   * @param password 自定义密码
   * @returns 对战关卡配置
   */
  static generateDuelLevel(colorCount: number, password?: Color[]): Level {
    const finalPassword = password || GameService.generatePassword(colorCount);
    return createLevel(0, 'hard', finalPassword, colorCount);
  }

  /**
   * 将关卡ID转换为关卡数字（用于显示）
   * @param levelId 关卡ID
   * @returns 显示用的关卡数字
   */
  static formatLevelNumber(levelId: number): number {
    return levelId;
  }

  /**
   * 获取难度显示名称
   * @param difficulty 难度
   * @returns 中文名称
   */
  static getDifficultyName(difficulty: Difficulty): string {
    return difficulty === 'easy' ? '初级' : '高级';
  }

  /**
   * 获取关卡范围信息
   * @param difficulty 难度
   * @returns 关卡范围描述
   */
  static getLevelRange(difficulty: Difficulty): string {
    if (difficulty === 'easy') {
      return `1-${GameConfig.EASY_LEVEL_COUNT}`;
    } else {
      return `${GameConfig.EASY_LEVEL_COUNT + 1}-${GameConfig.EASY_LEVEL_COUNT + GameConfig.HARD_LEVEL_COUNT}`;
    }
  }

  /**
   * 检查关卡是否为该难度的第一关
   * @param levelId 关卡ID
   * @param difficulty 难度
   * @returns 是否为第一关
   */
  static isFirstLevelOfDifficulty(levelId: number, difficulty: Difficulty): boolean {
    if (difficulty === 'easy') {
      return levelId === 1;
    } else {
      return levelId === GameConfig.EASY_LEVEL_COUNT + 1;
    }
  }

  /**
   * 获取该难度的起始关卡ID
   * @param difficulty 难度
   * @returns 起始ID
   */
  static getStartLevelId(difficulty: Difficulty): number {
    return difficulty === 'easy' ? 1 : GameConfig.EASY_LEVEL_COUNT + 1;
  }
}
