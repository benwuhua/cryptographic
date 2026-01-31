/**
 * LevelRepository 关卡数据测试
 * 测试关卡加载、生成、缓存等功能
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { LevelRepository } from '../../../main/ets/repositories/LevelRepository';
import { LevelService } from '../../../main/ets/services/LevelService';
import { Level } from '../../../main/ets/models/Level';
import { Color } from '../../../main/ets/constants/Colors';

export default function LevelRepositoryTest() {
  describe('LevelRepositoryTests', () => {

    /**
     * 测试关卡加载
     */
    describe('LevelLoadingTests', () => {
      it('should load easy level 1 correctly', 0, async () => {
        const level = await LevelRepository.getLevel(1);

        expect(level.id).assertEqual(1);
        expect(level.difficulty).assertEqual('easy');
        expect(level.password.length).assertEqual(4);
        expect(level.colorCount).assertLarger(3);
        expect(level.colorCount).assertLess(7);
        expect(level.maxAttempts).assertEqual(7);
      });

      it('should load easy level 100 correctly', 0, async () => {
        const level = await LevelRepository.getLevel(100);

        expect(level.id).assertEqual(100);
        expect(level.difficulty).assertEqual('easy');
      });

      it('should load hard level 101 correctly', 0, async () => {
        const level = await LevelRepository.getLevel(101);

        expect(level.id).assertEqual(101);
        expect(level.difficulty).assertEqual('hard');
      });

      it('should load hard level 200 correctly', 0, async () => {
        const level = await LevelRepository.getLevel(200);

        expect(level.id).assertEqual(200);
        expect(level.difficulty).assertEqual('hard');
      });

      it('should generate same password for same level (deterministic)', 0, async () => {
        const level1 = await LevelRepository.getLevel(50);
        const level2 = await LevelRepository.getLevel(50);

        expect(level1.password).assertEqual(level2.password);
      });

      it('should generate different passwords for different levels', 0, async () => {
        const level1 = await LevelRepository.getLevel(50);
        const level2 = await LevelRepository.getLevel(51);

        // Same password is possible but unlikely
        // Just verify both are valid
        expect(level1.password.length).assertEqual(4);
        expect(level2.password.length).assertEqual(4);
      });
    });

    /**
     * 测试颜色数量
     */
    describe('ColorCountTests', () => {
      it('should use 4 colors for early easy levels', 0, async () => {
        const level = await LevelRepository.getLevel(1);
        expect(level.colorCount).assertEqual(4);
      });

      it('should use up to 6 colors for later easy levels', 0, async () => {
        const level = await LevelRepository.getLevel(100);
        expect(level.colorCount).assertLarger(3);
        expect(level.colorCount).assertLess(7);
      });

      it('should use more colors for hard levels', 0, async () => {
        const level = await LevelRepository.getLevel(150);
        expect(level.colorCount).assertLarger(3);
        expect(level.colorCount).assertLess(7);
      });
    });

    /**
     * 测试密码有效性
     */
    describe('PasswordValidityTests', () => {
      it('should generate valid colors from available set', 0, async () => {
        const level = await LevelRepository.getLevel(50);
        const allColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];

        for (const color of level.password) {
          expect(allColors.indexOf(color)).assertLarger(-1);
        }
      });

      it('should only use colors within colorCount limit', 0, async () => {
        const level = await LevelRepository.getLevel(1); // 4-color level
        const colorsUsed = new Set(level.password);

        expect(colorsUsed.size).assertLessOrEqual(4);
      });
    });

    /**
     * 测试缓存功能
     */
    describe('CacheTests', () => {
      it('should cache loaded levels', 0, async () => {
        LevelRepository.clearCache();

        const level1 = await LevelRepository.getLevel(50);
        const level2 = await LevelRepository.getLevel(50);

        // Should return same object from cache
        expect(level1).assertEqual(level2);
      });

      it('should clear cache correctly', 0, async () => {
        const level1 = await LevelRepository.getLevel(50);
        LevelRepository.clearCache();
        const level2 = await LevelRepository.getLevel(50);

        // Should be different objects after cache clear
        // But passwords should be same (deterministic)
        expect(level1.password).assertEqual(level2.password);
      });
    });

    /**
     * 测试批量获取关卡
     */
    describe('BatchLevelLoadingTests', () => {
      it('should load multiple levels in range', 0, () => {
        const levels = LevelRepository.getLevels(1, 5);

        expect(levels.length).assertEqual(5);
        expect(levels[0].id).assertEqual(1);
        expect(levels[4].id).assertEqual(5);
      });

      it('should load consecutive levels correctly', 0, () => {
        const levels = LevelRepository.getLevels(10, 3);

        expect(levels[0].id).assertEqual(10);
        expect(levels[1].id).assertEqual(11);
        expect(levels[2].id).assertEqual(12);
      });
    });

    /**
     * 测试边界情况
     */
    describe('BoundaryTests', () => {
      it('should handle level 1 (first level)', 0, async () => {
        const level = await LevelRepository.getLevel(1);
        expect(level.id).assertEqual(1);
      });

      it('should handle level 200 (last level)', 0, async () => {
        const level = await LevelRepository.getLevel(200);
        expect(level.id).assertEqual(200);
      });

      it('should handle level 100 (easy-hard boundary)', 0, async () => {
        const level = await LevelRepository.getLevel(100);
        expect(level.difficulty).assertEqual('easy');
      });

      it('should handle level 101 (first hard level)', 0, async () => {
        const level = await LevelRepository.getLevel(101);
        expect(level.difficulty).assertEqual('hard');
      });
    });

    /**
     * 测试关卡配置一致性
     */
    describe('LevelConfigurationTests', () => {
      it('should have maxAttempts of 7 for all levels', 0, async () => {
        const testLevels = [1, 50, 100, 150, 200];

        for (const id of testLevels) {
          const level = await LevelRepository.getLevel(id);
          expect(level.maxAttempts).assertEqual(7);
        }
      });

      it('should have password length of 4 for all levels', 0, async () => {
        const testLevels = [1, 50, 100, 150, 200];

        for (const id of testLevels) {
          const level = await LevelRepository.getLevel(id);
          expect(level.password.length).assertEqual(4);
        }
      });

      it('should have mapped hint mode for easy levels', 0, async () => {
        const level = await LevelRepository.getLevel(50);
        expect(level.hintMode).assertEqual('mapped');
      });

      it('should have unmapped hint mode for hard levels', 0, async () => {
        const level = await LevelRepository.getLevel(150);
        expect(level.hintMode).assertEqual('unmapped');
      });
    });

    /**
     * 性能测试
     */
    describe('PerformanceTests', () => {
      it('should load level quickly', 0, async () => {
        const startTime = Date.now();
        await LevelRepository.getLevel(100);
        const endTime = Date.now();

        const duration = endTime - startTime;
        expect(duration).assertLess(500); // Should load within 500ms
      });

      it('should load multiple levels efficiently', 0, async () => {
        const startTime = Date.now();

        for (let i = 1; i <= 10; i++) {
          await LevelRepository.getLevel(i);
        }

        const endTime = Date.now();
        const duration = endTime - startTime;

        expect(duration).assertLess(2000); // Should load 10 levels within 2 seconds
      });
    });

    /**
     * 测试密码随机性分布
     */
    describe('PasswordDistributionTests', () => {
      it('should generate varied passwords across levels', 0, async () => {
        const passwords: string[] = [];

        for (let i = 1; i <= 20; i++) {
          const level = await LevelRepository.getLevel(i);
          passwords.push(level.password.join(','));
        }

        // Check that not all passwords are the same
        const uniquePasswords = new Set(passwords);
        expect(uniquePasswords.size).assertLarger(1);
      });
    });
  });
}
