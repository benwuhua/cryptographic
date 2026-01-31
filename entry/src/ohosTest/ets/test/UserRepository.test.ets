/**
 * UserRepository 数据持久化测试
 * 测试用户进度保存、恢复、统计等功能
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { UserRepository, UserStats } from '../../../main/ets/repositories/UserRepository';
import { UserProgress } from '../../../main/ets/models/UserProgress';
import { Context } from '@kit.AbilityKit';

// Mock Context for testing
class MockContext {
  async getPreferences(name: string) {
    return {
      get: async (key: string, defaultValue: any) => {
        // Return empty string for initial state
        if (key === 'userProgress') {
          return '';
        }
        return defaultValue;
      },
      put: async (key: string, value: string) => {
        return;
      },
      flush: async () => {
        return;
      },
      delete: async (key: string) => {
        return;
      }
    };
  }
}

export default function UserRepositoryTest() {
  describe('UserRepositoryTests', () => {
    let mockContext: Context;

    beforeAll(async () => {
      mockContext = new MockContext() as any;
      try {
        await UserRepository.init(mockContext);
      } catch (error) {
        // Ignore initialization errors in test environment
      }
    });

    /**
     * DATA-005: 首次启动测试
     */
    it('should return default progress when no data exists', 0, async () => {
      const progress = await UserRepository.getUserProgress();

      expect(progress.totalGames).assertEqual(0);
      expect(progress.totalWins).assertEqual(0);
      expect(progress.easyUnlocked).assertEqual(1);
      expect(progress.hardUnlocked).assertEqual(0);
    });

    /**
     * DATA-001: 保存游戏进度
     */
    it('should save user progress correctly', 0, async () => {
      const testProgress: UserProgress = {
        totalGames: 10,
        totalWins: 7,
        currentStreak: 3,
        bestStreak: 5,
        easyUnlocked: 15,
        hardUnlocked: 2
      };

      await UserRepository.saveUserProgress(testProgress);
      const loaded = await UserRepository.getUserProgress();

      expect(loaded.totalGames).assertEqual(testProgress.totalGames);
      expect(loaded.totalWins).assertEqual(testProgress.totalWins);
      expect(loaded.currentStreak).assertEqual(testProgress.currentStreak);
      expect(loaded.bestStreak).assertEqual(testProgress.bestStreak);
      expect(loaded.easyUnlocked).assertEqual(testProgress.easyUnlocked);
      expect(loaded.hardUnlocked).assertEqual(testProgress.hardUnlocked);
    });

    /**
     * 测试关卡星级更新
     */
    describe('LevelStarsTests', () => {
      it('should save level stars for easy levels', 0, async () => {
        const levelId = 5;
        const stars = 3;

        await UserRepository.updateLevelStars(levelId, stars);
        const loadedStars = await UserRepository.getLevelStars(levelId);

        expect(loadedStars).assertEqual(stars);
      });

      it('should save level stars for hard levels', 0, async () => {
        const levelId = 105; // Hard level
        const stars = 2;

        await UserRepository.updateLevelStars(levelId, stars);
        const loadedStars = await UserRepository.getLevelStars(levelId);

        expect(loadedStars).assertEqual(stars);
      });

      it('should only keep highest stars for same level', 0, async () => {
        const levelId = 10;

        await UserRepository.updateLevelStars(levelId, 1);
        expect(await UserRepository.getLevelStars(levelId)).assertEqual(1);

        await UserRepository.updateLevelStars(levelId, 3);
        expect(await UserRepository.getLevelStars(levelId)).assertEqual(3);

        // Lower stars should not override
        await UserRepository.updateLevelStars(levelId, 2);
        expect(await UserRepository.getLevelStars(levelId)).assertEqual(3);
      });

      it('should return 0 for level with no stars', 0, async () => {
        const stars = await UserRepository.getLevelStars(999);
        expect(stars).assertEqual(0);
      });

      it('should batch get level stars correctly', 0, async () => {
        const levelIds = [1, 5, 10, 15];

        await UserRepository.updateLevelStars(1, 3);
        await UserRepository.updateLevelStars(5, 2);
        await UserRepository.updateLevelStars(10, 1);
        // Level 15 has no stars

        const starsMap = await UserRepository.getLevelsStars(levelIds);

        expect(starsMap[1]).assertEqual(3);
        expect(starsMap[5]).assertEqual(2);
        expect(starsMap[10]).assertEqual(1);
        expect(starsMap[15]).assertEqual(0);
      });
    });

    /**
     * 测试游戏胜利处理
     */
    describe('GameWinHandlingTests', () => {
      it('should update progress correctly when winning easy level', 0, async () => {
        const levelId = 5;
        const attemptsUsed = 4;
        const maxAttempts = 10;

        await UserRepository.handleGameWin(levelId, attemptsUsed, maxAttempts);
        const progress = await UserRepository.getUserProgress();

        expect(progress.totalGames).assertLarger(0);
        expect(progress.totalWins).assertLarger(0);
        expect(progress.easyUnlocked).assertLarger(1);
      });

      it('should unlock hard mode after completing easy level 100', 0, async () => {
        // Set progress to just before unlocking hard mode
        const progress: UserProgress = {
          totalGames: 100,
          totalWins: 80,
          currentStreak: 0,
          bestStreak: 10,
          easyUnlocked: 100,
          hardUnlocked: 0
        };
        await UserRepository.saveUserProgress(progress);

        // Win level 100
        await UserRepository.handleGameWin(100, 5, 10);
        const updated = await UserRepository.getUserProgress();

        expect(updated.hardUnlocked).assertLarger(0);
      });

      it('should unlock next level when winning', 0, async () => {
        const initialProgress = await UserRepository.getUserProgress();
        const initialUnlocked = initialProgress.easyUnlocked;

        // Win the current unlocked level
        await UserRepository.handleGameWin(initialUnlocked, 5, 10);
        const updated = await UserRepository.getUserProgress();

        expect(updated.easyUnlocked).assertEqual(initialUnlocked + 1);
      });
    });

    /**
     * 测试游戏失败处理
     */
    describe('GameLoseHandlingTests', () => {
      it('should update statistics when losing', 0, async () => {
        const initialProgress = await UserRepository.getUserProgress();
        const initialGames = initialProgress.totalGames;

        await UserRepository.handleGameLose();
        const updated = await UserRepository.getUserProgress();

        expect(updated.totalGames).assertEqual(initialGames + 1);
        expect(updated.currentStreak).assertEqual(0);
      });
    });

    /**
     * 测试用户统计
     */
    describe('UserStatsTests', () => {
      it('should calculate correct statistics', 0, async () => {
        const testProgress: UserProgress = {
          totalGames: 20,
          totalWins: 15,
          currentStreak: 3,
          bestStreak: 8,
          easyUnlocked: 30,
          hardUnlocked: 5
        };

        await UserRepository.saveUserProgress(testProgress);

        // Add some stars
        await UserRepository.updateLevelStars(1, 3);
        await UserRepository.updateLevelStars(2, 2);
        await UserRepository.updateLevelStars(3, 3);

        const stats: UserStats = await UserRepository.getUserStats();

        expect(stats.totalGames).assertEqual(20);
        expect(stats.totalWins).assertEqual(15);
        expect(stats.winRate).assertEqual(75);
        expect(stats.bestStreak).assertEqual(8);
        expect(stats.currentStreak).assertEqual(3);
        expect(stats.easyUnlocked).assertEqual(30);
        expect(stats.hardUnlocked).assertEqual(5);
        expect(stats.totalStars).assertEqual(8); // 3+2+3
      });

      it('should calculate win rate correctly', 0, async () => {
        const testProgress: UserProgress = {
          totalGames: 10,
          totalWins: 7,
          currentStreak: 2,
          bestStreak: 5,
          easyUnlocked: 20,
          hardUnlocked: 0
        };

        await UserRepository.saveUserProgress(testProgress);
        const stats = await UserRepository.getUserStats();

        expect(stats.winRate).assertEqual(70);
      });

      it('should handle zero games correctly', 0, async () => {
        const testProgress: UserProgress = {
          totalGames: 0,
          totalWins: 0,
          currentStreak: 0,
          bestStreak: 0,
          easyUnlocked: 1,
          hardUnlocked: 0
        };

        await UserRepository.saveUserProgress(testProgress);
        const stats = await UserRepository.getUserStats();

        expect(stats.winRate).assertEqual(0);
      });
    });

    /**
     * DATA-003: 清空数据测试
     */
    describe('DataClearTests', () => {
      it('should clear all data correctly', 0, async () => {
        // Set some data
        const testProgress: UserProgress = {
          totalGames: 50,
          totalWins: 40,
          currentStreak: 5,
          bestStreak: 15,
          easyUnlocked: 80,
          hardUnlocked: 20
        };
        await UserRepository.saveUserProgress(testProgress);
        await UserRepository.updateLevelStars(5, 3);

        // Clear data
        await UserRepository.clearAllData();
        const cleared = await UserRepository.getUserProgress();

        expect(cleared.totalGames).assertEqual(0);
        expect(cleared.totalWins).assertEqual(0);
        expect(cleared.easyUnlocked).assertEqual(1);
        expect(cleared.hardUnlocked).assertEqual(0);
      });
    });

    /**
     * 边界测试
     */
    describe('BoundaryTests', () => {
      it('should handle maximum level 200', 0, async () => {
        await UserRepository.updateLevelStars(200, 3);
        const stars = await UserRepository.getLevelStars(200);
        expect(stars).assertEqual(3);
      });

      it('should handle level 1 correctly', 0, async () => {
        await UserRepository.updateLevelStars(1, 3);
        const stars = await UserRepository.getLevelStars(1);
        expect(stars).assertEqual(3);
      });

      it('should handle large number of games', 0, async () => {
        const testProgress: UserProgress = {
          totalGames: 9999,
          totalWins: 8000,
          currentStreak: 100,
          bestStreak: 200,
          easyUnlocked: 100,
          hardUnlocked: 100
        };

        await UserRepository.saveUserProgress(testProgress);
        const loaded = await UserRepository.getUserProgress();

        expect(loaded.totalGames).assertEqual(9999);
        expect(loaded.totalWins).assertEqual(8000);
      });
    });
  });
}
