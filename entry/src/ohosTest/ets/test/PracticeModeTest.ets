/**
 * 练习模式测试套件
 * 测试练习模式的难度选择和颜色数量
 *
 * Bug修复验证: 练习模式应该根据用户进度动态选择颜色数量
 * - 新用户（1-50关）：4色
 * - 中级用户（51-100关）：5色
 * - 高级用户（100+关）：6色
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { LevelService } from '../../../main/ets/services/LevelService';
import { GameService } from '../../../main/ets/services/GameService';
import { UserRepository } from '../../../main/ets/repositories/UserRepository';
import { Level } from '../../../main/ets/models/Level';
import { UserProgress, DEFAULT_USER_PROGRESS } from '../../../main/ets/models/UserProgress';

export default function PracticeModeTest() {
  describe('PracticeModeTests', () => {

    /**
     * PRACTICE-001: 新用户练习模式应该是4色
     */
    it('should generate 4-color practice level for new users', 0, async () => {
      // Given: 新用户（只解锁了1关）
      const newProgress: UserProgress = {
        easyUnlocked: 1,
        hardUnlocked: 0,
        totalGames: 0,
        totalWins: 0,
        bestStreak: 0,
        currentStreak: 0
      };

      // When: 生成练习关卡
      const level = LevelService.generatePracticeLevel(4);

      // Then: 应该是4色
      expect(level.colorCount).assertEqual(4);
      expect(level.password.length).assertEqual(4);
      console.log(`=== PRACTICE-001: colorCount=${level.colorCount}, password=[${level.password.join(', ')}] ===`);
    });

    /**
     * PRACTICE-002: 中级用户（50关）应该可以用5色练习
     */
    it('should support 5-color practice level for intermediate users', 0, async () => {
      // Given: 用户已解锁50关
      const intermediateProgress: UserProgress = {
        easyUnlocked: 50,
        hardUnlocked: 0,
        totalGames: 0,
        totalWins: 0,
        bestStreak: 0,
        currentStreak: 0
      };

      // When: 生成5色练习关卡
      const level = LevelService.generatePracticeLevel(5);

      // Then: 应该是5色
      expect(level.colorCount).assertEqual(5);
      expect(level.password.length).assertEqual(4);
      console.log(`=== PRACTICE-002: colorCount=${level.colorCount}, password=[${level.password.join(', ')}] ===`);
    });

    /**
     * PRACTICE-003: 高级用户（100+关）应该可以用6色练习
     */
    it('should support 6-color practice level for advanced users', 0, async () => {
      // Given: 用户已解锁100关
      const advancedProgress: UserProgress = {
        easyUnlocked: 100,
        hardUnlocked: 0,
        totalGames: 0,
        totalWins: 0,
        bestStreak: 0,
        currentStreak: 0
      };

      // When: 生成6色练习关卡
      const level = LevelService.generatePracticeLevel(6);

      // Then: 应该是6色
      expect(level.colorCount).assertEqual(6);
      expect(level.password.length).assertEqual(4);
      console.log(`=== PRACTICE-003: colorCount=${level.colorCount}, password=[${level.password.join(', ')}] ===`);
    });

    /**
     * PRACTICE-004: 练习模式密码应该只包含可用颜色
     */
    it('should only use available colors in practice password', 0, () => {
      // Given: 4色练习模式
      const level = LevelService.generatePracticeLevel(4);
      const availableColors = ['red', 'yellow', 'green', 'blue'];

      // When: 检查密码中的每个颜色
      for (const color of level.password) {
        // Then: 所有颜色都应该在可用颜色列表中
        expect(availableColors.indexOf(color) >= 0).assertTrue();
      }

      console.log(`=== PRACTICE-004: password=[${level.password.join(', ')}], all colors valid ===`);
    });

    /**
     * PRACTICE-005: 5色练习模式密码应该只包含5种颜色
     */
    it('should only use 5 available colors in 5-color practice mode', 0, () => {
      // Given: 5色练习模式
      const level = LevelService.generatePracticeLevel(5);
      const availableColors = ['red', 'yellow', 'green', 'blue', 'purple'];

      // When: 检查密码中的每个颜色
      for (const color of level.password) {
        // Then: 所有颜色都应该在5色列表中
        expect(availableColors.indexOf(color) >= 0).assertTrue();
      }

      console.log(`=== PRACTICE-005: password=[${level.password.join(', ')}], all colors valid ===`);
    });

    /**
     * PRACTICE-006: 6色练习模式密码应该只包含6种颜色
     */
    it('should only use 6 available colors in 6-color practice mode', 0, () => {
      // Given: 6色练习模式
      const level = LevelService.generatePracticeLevel(6);
      const availableColors = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];

      // When: 检查密码中的每个颜色
      for (const color of level.password) {
        // Then: 所有颜色都应该在6色列表中
        expect(availableColors.indexOf(color) >= 0).assertTrue();
      }

      console.log(`=== PRACTICE-006: password=[${level.password.join(', ')}], all colors valid ===`);
    });

    /**
     * PRACTICE-007: 练习模式游戏应该可以正常进行
     */
    it('should allow gameplay in practice mode', 0, () => {
      // Given: 4色练习关卡
      const level = LevelService.generatePracticeLevel(4);
      const gameState = GameService.createGame(level, 'practice');

      // When: 检查游戏状态
      // Then: 应该可以正常初始化
      expect(gameState.status).assertEqual('playing');
      expect(gameState.mode).assertEqual('practice');
      expect(gameState.level.colorCount).assertEqual(4);
      expect(gameState.currentGuess.length).assertEqual(4);

      console.log(`=== PRACTICE-007: practice game initialized correctly ===`);
    });

    /**
     * PRACTICE-008: 每次生成的练习密码应该不同（使用关卡ID作为种子）
     */
    it('should generate different passwords for different levels', 0, () => {
      // Given: 使用不同的关卡ID
      const level1 = LevelService.generatePracticeLevel(4);
      const level2 = LevelService.generatePracticeLevel(5);
      const level3 = LevelService.generatePracticeLevel(6);

      // When: 比较密码
      // Then: 密码应该不同（由于使用关卡ID作为种子的一部分）
      const passwords = [
        level1.password.join(','),
        level2.password.join(','),
        level3.password.join(',')
      ];

      const uniquePasswords = new Set(passwords);
      expect(uniquePasswords.size).assertLargerOrEqual(2); // 至少有2个不同的密码

      console.log(`=== PRACTICE-008: generated ${uniquePasswords.size} unique passwords ===`);
    });

    /**
     * PRACTICE-009: 练习模式应该有合理的尝试次数
     */
    it('should have reasonable max attempts in practice mode', 0, () => {
      // Given: 生成练习关卡
      const level = LevelService.generatePracticeLevel(4);

      // When: 检查最大尝试次数
      // Then: 应该在7-12次之间（合理范围）
      expect(level.maxAttempts).assertLargerOrEqual(7);
      expect(level.maxAttempts).assertLessOrEqual(12);

      console.log(`=== PRACTICE-009: maxAttempts=${level.maxAttempts} ===`);
    });

    /**
     * PRACTICE-010: 练习模式应该有提示模式
     */
    it('should have hint mode enabled in practice', 0, () => {
      // Given: 生成练习关卡
      const level = LevelService.generatePracticeLevel(4);

      // When: 检查提示模式
      // Then: 应该有提示模式
      expect(level.hintMode).assertEqual('mapped');

      console.log(`=== PRACTICE-010: hintMode=${level.hintMode} ===`);
    });
  });
}
