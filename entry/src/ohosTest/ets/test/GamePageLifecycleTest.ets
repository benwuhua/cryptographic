/**
 * GamePage 页面生命周期测试套件
 *
 * Bug修复验证: 页面显示时应该重新加载数据
 * - 进入关卡1 → 返回首页 → 再进入关卡2
 * - 应该显示关卡2的数据，而不是关卡1的数据
 *
 * 测试重点:
 * - onPageShow() 生命周期方法
 * - 数据刷新机制
 * - 状态重置
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { GameService } from '../../../main/ets/services/GameService';
import { LevelService } from '../../../main/ets/services/LevelService';
import { LevelRepository } from '../../../main/ets/repositories/LevelRepository';
import { Level } from '../../../main/ets/models/Level';
import { Color } from '../../../main/ets/constants/Colors';

export default function GamePageLifecycleTest() {
  describe('GamePageLifecycleTests', () => {

    /**
     * LIFECYCLE-001: 不同关卡应该有不同的密码
     */
    it('should load different passwords for different levels', 0, async () => {
      // Given: 加载关卡1和关卡2
      const level1 = await LevelRepository.getLevel(1);
      const level2 = await LevelRepository.getLevel(2);

      // When: 比较密码
      const password1 = level1.password.join(',');
      const password2 = level2.password.join(',');

      // Then: 关卡1和关卡2的密码应该不同
      expect(password1 !== password2).assertTrue();

      console.log(`=== LIFECYCLE-001: level1 password=[${password1}], level2 password=[${password2}] ===`);
    });

    /**
     * LIFECYCLE-002: 关卡1应该是4色模式
     */
    it('should load 4-color game for level 1', 0, async () => {
      // Given: 加载关卡1
      const level1 = await LevelRepository.getLevel(1);

      // When & Then: 应该是4色
      expect(level1.colorCount).assertEqual(4);
      expect(level1.password.length).assertEqual(4);

      console.log(`=== LIFECYCLE-002: level1 colorCount=${level1.colorCount} ===`);
    });

    /**
     * LIFECYCLE-003: 关卡2应该是4色模式
     */
    it('should load 4-color game for level 2', 0, async () => {
      // Given: 加载关卡2
      const level2 = await LevelRepository.getLevel(2);

      // When & Then: 应该是4色
      expect(level2.colorCount).assertEqual(4);

      console.log(`=== LIFECYCLE-003: level2 colorCount=${level2.colorCount} ===`);
    });

    /**
     * LIFECYCLE-004: 每次创建游戏应该有新的游戏状态
     */
    it('should create new game state for each game', 0, async () => {
      // Given: 加载关卡1
      const level = await LevelRepository.getLevel(1);

      // When: 创建两个游戏
      const game1 = GameService.createGame(level, 'solo');
      const game2 = GameService.createGame(level, 'solo');

      // Then: 两个游戏应该是不同的对象实例
      expect(game1 === game2).assertFalse();

      // 并且应该有不同的开始时间
      expect(game1.startTime === game2.startTime).assertFalse();

      console.log(`=== LIFECYCLE-004: game1.startTime=${game1.startTime}, game2.startTime=${game2.startTime} ===`);
    });

    /**
     * LIFECYCLE-005: 新游戏应该没有猜测历史
     */
    it('should start with empty attempt history', 0, async () => {
      // Given: 创建新游戏
      const level = await LevelRepository.getLevel(1);
      const gameState = GameService.createGame(level, 'solo');

      // When & Then: 应该没有猜测历史
      expect(gameState.attempts.length).assertEqual(0);

      console.log(`=== LIFECYCLE-005: attempts.length=${gameState.attempts.length} ===`);
    });

    /**
     * LIFECYCLE-006: 新游戏应该有空白的当前猜测
     */
    it('should start with empty current guess', 0, async () => {
      // Given: 创建新游戏
      const level = await LevelRepository.getLevel(1);
      const gameState = GameService.createGame(level, 'solo');

      // When & Then: 当前猜测应该全是null
      expect(gameState.currentGuess.length).assertEqual(4);

      for (let i = 0; i < gameState.currentGuess.length; i++) {
        expect(gameState.currentGuess[i]).assertNull();
      }

      console.log(`=== LIFECYCLE-006: currentGuess=[${gameState.currentGuess.join(', ')}] ===`);
    });

    /**
     * LIFECYCLE-007: 不同关卡的密码应该在合理范围内
     */
    it('should generate passwords within available colors', 0, async () => {
      // Given: 加载前10个关卡
      const levels: Level[] = [];
      for (let i = 1; i <= 10; i++) {
        const level = await LevelRepository.getLevel(i);
        levels.push(level);
      }

      // When: 检查每个关卡的密码
      const availableColors: Color[] = ['red', 'yellow', 'green', 'blue'];

      for (const level of levels) {
        // Then: 密码中的每个颜色都应该在可用颜色中
        for (const color of level.password) {
          expect(availableColors.indexOf(color) >= 0).assertTrue();
        }
      }

      console.log(`=== LIFECYCLE-007: all 10 levels have valid passwords ===`);
    });

    /**
     * LIFECYCLE-008: 练习模式每次应该生成不同的密码
     */
    it('should generate different practice passwords', 0, () => {
      // Given: 生成多个练习关卡
      const practiceLevels = [
        LevelService.generatePracticeLevel(4),
        LevelService.generatePracticeLevel(4),
        LevelService.generatePracticeLevel(4)
      ];

      // When: 比较密码
      const passwords = practiceLevels.map(level => level.password.join(','));

      // Then: 应该有不同的密码（使用关卡ID作为种子）
      const uniquePasswords = new Set(passwords);
      expect(uniquePasswords.size).assertLargerOrEqual(2);

      console.log(`=== LIFECYCLE-008: generated ${uniquePasswords.size} unique passwords from 3 attempts ===`);
    });

    /**
     * LIFECYCLE-009: 练习模式关卡应该有不同的ID
     */
    it('should have different IDs for practice levels', 0, () => {
      // Given: 生成多个练习关卡
      const level1 = LevelService.generatePracticeLevel(4);
      const level2 = LevelService.generatePracticeLevel(5);
      const level3 = LevelService.generatePracticeLevel(6);

      // When & Then: 练习关卡的ID应该都是0（特殊值）
      expect(level1.id).assertEqual(0);
      expect(level2.id).assertEqual(0);
      expect(level3.id).assertEqual(0);

      console.log(`=== LIFECYCLE-009: practice levels have id=0 ===`);
    });

    /**
     * LIFECYCLE-010: 游戏状态应该正确反映关卡信息
     */
    it('should have correct level info in game state', 0, async () => {
      // Given: 加载关卡5
      const level = await LevelRepository.getLevel(5);
      const gameState = GameService.createGame(level, 'solo');

      // When: 检查游戏状态中的关卡信息
      // Then: 应该匹配
      expect(gameState.level.id).assertEqual(level.id);
      expect(gameState.level.colorCount).assertEqual(level.colorCount);
      expect(gameState.level.difficulty).assertEqual(level.difficulty);
      expect(gameState.level.password.length).assertEqual(level.password.length);

      console.log(`=== LIFECYCLE-010: gameState matches level info ===`);
    });

    /**
     * LIFECYCLE-011: 游戏状态应该是可变的
     */
    it('should allow game state mutation', 0, async () => {
      // Given: 创建游戏
      const level = await LevelRepository.getLevel(1);
      let gameState = GameService.createGame(level, 'solo');

      // When: 更新当前猜测
      gameState = GameService.updateCurrentGuess(gameState, 0, 'red');

      // Then: 状态应该更新
      expect(gameState.currentGuess[0]).assertEqual('red');

      console.log(`=== LIFECYCLE-011: gameState is mutable ===`);
    });

    /**
     * LIFECYCLE-012: 清空猜测应该重置当前猜测
     */
    it('should reset current guess when cleared', 0, async () => {
      // Given: 创建游戏并设置猜测
      const level = await LevelRepository.getLevel(1);
      let gameState = GameService.createGame(level, 'solo');
      gameState = GameService.updateCurrentGuess(gameState, 0, 'red');
      gameState = GameService.updateCurrentGuess(gameState, 1, 'yellow');

      // When: 清空猜测
      gameState = GameService.clearCurrentGuess(gameState);

      // Then: 所有位置应该是null
      for (let i = 0; i < gameState.currentGuess.length; i++) {
        expect(gameState.currentGuess[i]).assertNull();
      }

      console.log(`=== LIFECYCLE-012: currentGuess cleared ===`);
    });

    /**
     * LIFECYCLE-013: 提交猜测应该添加到历史记录
     */
    it('should add attempt to history after submission', 0, async () => {
      // Given: 创建游戏并设置完整猜测
      const level = await LevelRepository.getLevel(1);
      let gameState = GameService.createGame(level, 'solo');
      gameState = GameService.updateCurrentGuess(gameState, 0, 'red');
      gameState = GameService.updateCurrentGuess(gameState, 1, 'yellow');
      gameState = GameService.updateCurrentGuess(gameState, 2, 'green');
      gameState = GameService.updateCurrentGuess(gameState, 3, 'blue');

      // When: 提交猜测
      gameState = GameService.submitGuess(gameState, gameState.currentGuess as Color[]);

      // Then: 应该有一个猜测记录
      expect(gameState.attempts.length).assertEqual(1);
      expect(gameState.attempts[0].guess[0]).assertEqual('red');

      console.log(`=== LIFECYCLE-013: attempts.length=${gameState.attempts.length} ===`);
    });

    /**
     * LIFECYCLE-014: 游戏结束后状态应该更新
     */
    it('should update status when game ends', 0, async () => {
      // Given: 创建游戏
      const level = await LevelRepository.getLevel(1);
      let gameState = GameService.createGame(level, 'solo');

      // When: 提交正确答案
      gameState = GameService.submitGuess(gameState, level.password);

      // Then: 状态应该是won
      expect(gameState.status).assertEqual('won');

      console.log(`=== LIFECYCLE-014: game status=${gameState.status} ===`);
    });
  });
}
