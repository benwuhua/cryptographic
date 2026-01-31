/**
 * 用户数据仓库
 * 负责用户进度和设置的持久化存储
 */

import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
import { StorageKeys } from '../constants/StorageKeys';
import {
  UserProgress,
  DEFAULT_USER_PROGRESS,
  updateProgressOnWin,
  updateProgressOnLose,
  getWinRate
} from '../models/UserProgress';
import { GameConfig } from '../constants/GameConfig';

export interface UserStats {
  totalGames: number;
  totalWins: number;
  winRate: number;
  bestStreak: number;
  currentStreak: number;
  easyUnlocked: number;
  hardUnlocked: number;
  totalStars: number;
}

export class UserRepository {
  private static preferences: dataPreferences.Preferences | null = null;

  /**
   * 初始化Preferences
   * @param context 应用上下文
   */
  static async init(context: Context): Promise<void> {
    try {
      UserRepository.preferences = await dataPreferences.getPreferences(context, 'CryptographicGame');
    } catch (error) {
      console.error('Failed to init preferences:', error);
      const err = error as Error;
      throw new Error(err.message);
    }
  }

  /**
   * 确保Preferences已初始化
   */
  private static ensureInitialized(): void {
    if (!UserRepository.preferences) {
      throw new Error('UserRepository not initialized. Call init() first.');
    }
  }

  /**
   * 获取用户进度
   * @returns 用户进度
   */
  static async getUserProgress(): Promise<UserProgress> {
    UserRepository.ensureInitialized();

    try {
      const prefs = UserRepository.preferences!;
      const progressStr = await prefs.get(StorageKeys.USER_PROGRESS, '');
      if (!progressStr || progressStr === '') {
        return DEFAULT_USER_PROGRESS;
      }

      return JSON.parse(progressStr as string) as UserProgress;
    } catch (error) {
      console.error('Failed to get user progress:', error);
      return DEFAULT_USER_PROGRESS;
    }
  }

  /**
   * 保存用户进度
   * @param progress 用户进度
   */
  static async saveUserProgress(progress: UserProgress): Promise<void> {
    UserRepository.ensureInitialized();

    try {
      const prefs = UserRepository.preferences!;
      await prefs.put(StorageKeys.USER_PROGRESS, JSON.stringify(progress));
      await prefs.flush();
    } catch (error) {
      console.error('Failed to save user progress:', error);
      const err = error as Error;
      throw new Error(err.message);
    }
  }

  /**
   * 更新关卡星级
   * @param levelId 关卡ID
   * @param stars 星级 (1-3)
   */
  static async updateLevelStars(levelId: number, stars: number): Promise<void> {
    UserRepository.ensureInitialized();

    try {
      const prefs = UserRepository.preferences!;
      const isEasy = levelId <= GameConfig.EASY_LEVEL_COUNT;
      const key = isEasy ? StorageKeys.EASY_STARS : StorageKeys.HARD_STARS;

      // 获取现有星级数据
      const starsStr = await prefs.get(key, '{}');
      const starsData = JSON.parse(starsStr as string) as Record<number, number>;

      // 只保存最高星级
      const currentStars = starsData[levelId] || 0;
      if (stars > currentStars) {
        starsData[levelId] = stars;
        await prefs.put(key, JSON.stringify(starsData));
        await prefs.flush();
      }
    } catch (error) {
      console.error('Failed to update level stars:', error);
      const err = error as Error;
      throw new Error(err.message);
    }
  }

  /**
   * 获取关卡星级
   * @param levelId 关卡ID
   * @returns 星级 (0-3, 0表示未通关)
   */
  static async getLevelStars(levelId: number): Promise<number> {
    UserRepository.ensureInitialized();

    try {
      const prefs = UserRepository.preferences!;
      const isEasy = levelId <= GameConfig.EASY_LEVEL_COUNT;
      const key = isEasy ? StorageKeys.EASY_STARS : StorageKeys.HARD_STARS;

      const starsStr = await prefs.get(key, '{}');
      const starsData = JSON.parse(starsStr as string) as Record<number, number>;

      return starsData[levelId] || 0;
    } catch (error) {
      console.error('Failed to get level stars:', error);
      return 0;
    }
  }

  /**
   * 批量获取关卡星级
   * @param levelIds 关卡ID数组
   * @returns 星级映射
   */
  static async getLevelsStars(levelIds: number[]): Promise<Record<number, number>> {
    UserRepository.ensureInitialized();

    const result: Record<number, number> = {};

    for (let i = 0; i < levelIds.length; i++) {
      const levelId = levelIds[i];
      result[levelId] = await UserRepository.getLevelStars(levelId);
    }

    return result;
  }

  /**
   * 处理游戏胜利
   * @param levelId 关卡ID
   * @param attemptsUsed 使用次数
   * @param maxAttempts 最大次数
   */
  static async handleGameWin(
    levelId: number,
    attemptsUsed: number,
    maxAttempts: number
  ): Promise<void> {
    // 更新用户进度
    const progress = await UserRepository.getUserProgress();
    const updatedProgress = updateProgressOnWin(progress);

    // 计算星级
    const ratio = attemptsUsed / maxAttempts;
    let stars: number;
    if (ratio <= GameConfig.STAR_3_THRESHOLD) {
      stars = 3;
    } else if (ratio <= GameConfig.STAR_2_THRESHOLD) {
      stars = 2;
    } else {
      stars = 1;
    }

    // 更新关卡星级
    await UserRepository.updateLevelStars(levelId, stars);

    // 解锁下一关
    const isEasy = levelId <= GameConfig.EASY_LEVEL_COUNT;
    if (isEasy) {
      const nextLevel = levelId + 1;
      if (nextLevel <= GameConfig.EASY_LEVEL_COUNT && nextLevel > updatedProgress.easyUnlocked) {
        updatedProgress.easyUnlocked = nextLevel;

        // 如果通关初级模式，解锁高级模式
        if (nextLevel > GameConfig.EASY_LEVEL_COUNT && updatedProgress.hardUnlocked === 0) {
          updatedProgress.hardUnlocked = 1;
        }
      }
    } else {
      const hardLevelId = levelId - GameConfig.EASY_LEVEL_COUNT;
      const nextHardLevel = hardLevelId + 1;
      if (nextHardLevel <= GameConfig.HARD_LEVEL_COUNT && nextHardLevel > updatedProgress.hardUnlocked) {
        updatedProgress.hardUnlocked = nextHardLevel;
      }
    }

    await UserRepository.saveUserProgress(updatedProgress);
  }

  /**
   * 处理游戏失败
   */
  static async handleGameLose(): Promise<void> {
    const progress = await UserRepository.getUserProgress();
    const updatedProgress = updateProgressOnLose(progress);
    await UserRepository.saveUserProgress(updatedProgress);
  }

  /**
   * 获取用户统计数据
   * @returns 统计信息
   */
  static async getUserStats(): Promise<UserStats> {
    const progress = await UserRepository.getUserProgress();

    // 计算总星级数
    const prefs = UserRepository.preferences!;
    const easyStarsStr = await prefs.get(StorageKeys.EASY_STARS, '{}');
    const hardStarsStr = await prefs.get(StorageKeys.HARD_STARS, '{}');
    const easyStars = JSON.parse(easyStarsStr as string) as Record<number, number>;
    const hardStars = JSON.parse(hardStarsStr as string) as Record<number, number>;

    let totalStars: number = 0;

    // 计算初级关卡星级
    const easyKeys = Object.keys(easyStars);
    for (let i = 0; i < easyKeys.length; i++) {
      const key: string = easyKeys[i] as string;
      const value: number | undefined = easyStars[key];
      if (value !== undefined) {
        totalStars += value;
      }
    }

    // 计算高级关卡星级
    const hardKeys = Object.keys(hardStars);
    for (let j = 0; j < hardKeys.length; j++) {
      const key: string = hardKeys[j] as string;
      const value: number | undefined = hardStars[key];
      if (value !== undefined) {
        totalStars += value;
      }
    }

    const stats: UserStats = {
      totalGames: progress.totalGames,
      totalWins: progress.totalWins,
      winRate: getWinRate(progress),
      bestStreak: progress.bestStreak,
      currentStreak: progress.currentStreak,
      easyUnlocked: progress.easyUnlocked,
      hardUnlocked: progress.hardUnlocked,
      totalStars
    };

    return stats;
  }

  /**
   * 清除所有数据（用于测试或重置）
   */
  static async clearAllData(): Promise<void> {
    UserRepository.ensureInitialized();

    try {
      const prefs = UserRepository.preferences!;
      await prefs.delete(StorageKeys.USER_PROGRESS);
      await prefs.delete(StorageKeys.EASY_STARS);
      await prefs.delete(StorageKeys.HARD_STARS);
      await prefs.flush();
    } catch (error) {
      console.error('Failed to clear all data:', error);
      const err = error as Error;
      throw new Error(err.message);
    }
  }
}
