/**
 * GameService 核心算法测试
 * 测试 Mastermind 算法的准确性和边界情况
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { GameService } from '../../../main/ets/services/GameService';
import { Color } from '../../../main/ets/constants/Colors';
import { Level } from '../../../main/ets/models/Level';
import { GameMode } from '../../../main/ets/models/GameState';

export default function GameServiceTest() {
  describe('GameServiceAlgorithmTests', () => {

    /**
     * ALG-001: 全中场景
     */
    it('should return 4 hits and 0 pseudoHits when all colors match in position', 0, () => {
      const guess: Color[] = ['red', 'yellow', 'green', 'blue'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(4);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-002: 全错场景
     */
    it('should return 0 hits and 0 pseudoHits when no colors match', 0, () => {
      const guess: Color[] = ['purple', 'orange', 'purple', 'orange'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(0);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-003: 位置全错颜色全对（用户发现的问题场景）
     */
    it('should return 0 hits and 4 pseudoHits when all colors correct but wrong positions', 0, () => {
      const guess: Color[] = ['blue', 'green', 'red', 'yellow'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(0);
      expect(result.pseudoHits).assertEqual(4);
    });

    /**
     * ALG-004: 部分命中场景
     */
    it('should return 2 hits and 0 pseudoHits when two colors match in position', 0, () => {
      const guess: Color[] = ['red', 'orange', 'green', 'orange'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(2);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-005: 颜色对位置错
     */
    it('should return 0 hits and 4 pseudoHits for position-swapped colors', 0, () => {
      const guess: Color[] = ['yellow', 'red', 'blue', 'green'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(0);
      expect(result.pseudoHits).assertEqual(4);
    });

    /**
     * ALG-006: 混合情况 - 1个位置正确 + 其他颜色正确但位置错
     * 用户报告的bug场景
     */
    it('should return 1 hit and 2 pseudoHits for mixed scenario', 0, () => {
      const guess: Color[] = ['red', 'green', 'yellow', 'orange'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(1);
      expect(result.pseudoHits).assertEqual(2);
    });

    /**
     * ALG-006-B: 明确测试 - 1个位置正确 + 3个颜色正确但位置全错
     * 这是最明确的bug复现场景
     */
    it('should return 1 hit and 3 pseudoHits when one color matches position and others match color only', 0, () => {
      const guess: Color[] = ['red', 'blue', 'yellow', 'green'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      // red 在位置0正确 → 1 hit
      // blue, yellow, green 颜色正确但位置错 → 3 pseudoHits
      expect(result.hits).assertEqual(1);
      expect(result.pseudoHits).assertEqual(3);
    });

    /**
     * ALG-007: 重复颜色-密码中有重复
     */
    it('should handle duplicate colors in password correctly', 0, () => {
      const guess: Color[] = ['red', 'yellow', 'green', 'blue'];
      const password: Color[] = ['red', 'red', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(3);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-008: 重复颜色-猜测中有重复
     */
    it('should handle duplicate colors in guess correctly', 0, () => {
      const guess: Color[] = ['red', 'red', 'green', 'blue'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(3);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-009: 重复颜色-多个匹配
     */
    it('should correctly count when password has duplicates and guess matches some', 0, () => {
      const guess: Color[] = ['red', 'red', 'green', 'orange'];
      const password: Color[] = ['red', 'red', 'yellow', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(2);
      expect(result.pseudoHits).assertEqual(0);
    });

    /**
     * ALG-010: 4种颜色边界测试
     */
    it('should work correctly with minimum 4 colors', 0, () => {
      const guess: Color[] = ['blue', 'green', 'yellow', 'red'];
      const password: Color[] = ['red', 'yellow', 'green', 'blue'];
      const result = GameService.evaluateGuess(guess, password);

      expect(result.hits).assertEqual(0);
      expect(result.pseudoHits).assertEqual(4);
    });

    /**
     * ALG-012: 长度不匹配异常
     * 注意: Hypium 框架不支持 toThrow()，此测试已禁用
     */
    // it('should throw error when guess length does not match password length', 0, () => {
    //   const guess: Color[] = ['red', 'yellow', 'green'];
    //   const password: Color[] = ['red', 'yellow', 'green', 'blue'];
    //
    //   expect(() => {
    //     GameService.evaluateGuess(guess, password);
    //   }).toThrow();
    // });

    /**
     * 测试星级计算
     */
    describe('StarRatingTests', () => {
      it('should return 3 stars when ratio <= 30%', 0, () => {
        expect(GameService.calculateStars(3, 10)).assertEqual(3);
        expect(GameService.calculateStars(2, 10)).assertEqual(3);
      });

      it('should return 2 stars when ratio <= 60%', 0, () => {
        expect(GameService.calculateStars(6, 10)).assertEqual(2);
        expect(GameService.calculateStars(5, 10)).assertEqual(2);
      });

      it('should return 1 star when ratio > 60%', 0, () => {
        expect(GameService.calculateStars(7, 10)).assertEqual(1);
        expect(GameService.calculateStars(10, 10)).assertEqual(1);
      });

      it('should handle edge cases correctly', 0, () => {
        expect(GameService.calculateStars(1, 7)).assertEqual(3);  // ~14%
        expect(GameService.calculateStars(3, 10)).assertEqual(3); // 30% boundary
        expect(GameService.calculateStars(6, 10)).assertEqual(2); // 60% boundary
        expect(GameService.calculateStars(7, 10)).assertEqual(1); // >60%
      });
    });

    /**
     * 测试游戏状态管理
     */
    describe('GameStateManagementTests', () => {
      let testLevel: Level;

      beforeAll(() => {
        testLevel = {
          id: 1,
          difficulty: 'easy',
          password: ['red', 'yellow', 'green', 'blue'],
          colorCount: 4,
          hintMode: 'mapped',
          maxAttempts: 7
        };
      });

      it('should create initial game state correctly', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');

        expect(gameState.level).assertEqual(testLevel);
        expect(gameState.attempts.length).assertEqual(0);
        expect(gameState.currentGuess.length).assertEqual(4);
        expect(gameState.status).assertEqual('playing');
      });

      it('should update current guess correctly', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');
        const updated = GameService.updateCurrentGuess(gameState, 0, 'red');

        expect(updated.currentGuess[0]).assertEqual('red');
      });

      it('should clear current guess correctly', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');
        const updated = GameService.updateCurrentGuess(gameState, 0, 'red');
        const cleared = GameService.clearCurrentGuess(updated);

        expect(cleared.currentGuess[0]).assertEqual(null);
        expect(cleared.currentGuess[1]).assertEqual(null);
        expect(cleared.currentGuess[2]).assertEqual(null);
        expect(cleared.currentGuess[3]).assertEqual(null);
      });

      it('should check if guess is complete', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');

        expect(GameService.isCurrentGuessComplete(gameState)).assertFalse();

        let updated = GameService.updateCurrentGuess(gameState, 0, 'red');
        updated = GameService.updateCurrentGuess(updated, 1, 'yellow');
        updated = GameService.updateCurrentGuess(updated, 2, 'green');
        updated = GameService.updateCurrentGuess(updated, 3, 'blue');

        expect(GameService.isCurrentGuessComplete(updated)).assertTrue();
      });

      it('should submit guess and update attempts', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');
        const guess: Color[] = ['red', 'orange', 'orange', 'orange'];
        const updated = GameService.submitGuess(gameState, guess);

        expect(updated.attempts.length).assertEqual(1);
        expect(updated.attempts[0].guess).assertEqual(guess);
      });

      it('should detect win condition', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');
        const guess: Color[] = ['red', 'yellow', 'green', 'blue'];
        const updated = GameService.submitGuess(gameState, guess);

        expect(updated.status).assertEqual('won');
      });

      it('should detect loss condition', 0, () => {
        const gameState = GameService.createGame(testLevel, 'solo');
        let updated = gameState;

        // Submit 7 wrong guesses
        for (let i = 0; i < 7; i++) {
          const wrongGuess: Color[] = ['purple', 'purple', 'purple', 'purple'];
          updated = GameService.submitGuess(updated, wrongGuess);
        }

        expect(updated.status).assertEqual('lost');
      });
    });

    /**
     * 性能测试
     */
    describe('PerformanceTests', () => {
      it('should evaluate guess quickly', 0, () => {
        const guess: Color[] = ['blue', 'green', 'red', 'yellow'];
        const password: Color[] = ['red', 'yellow', 'green', 'blue'];

        const startTime = Date.now();
        const result = GameService.evaluateGuess(guess, password);
        const endTime = Date.now();

        const duration = endTime - startTime;
        expect(duration).assertLess(100); // 应该在100ms内完成
        expect(result.hits).assertEqual(0);
        expect(result.pseudoHits).assertEqual(4);
      });
    });

    /**
     * Mapped模式测试（位置级别评估）
     */
    describe('MappedModeTests', () => {
      it('should return position hints for 1 hit scenario', 0, () => {
        const guess: Color[] = ['red', 'yellow', 'green', 'blue'];
        const password: Color[] = ['yellow', 'yellow', 'yellow', 'yellow'];
        const result = GameService.evaluateGuessMapped(guess, password);

        expect(result.hits).assertEqual(1);
        expect(result.pseudoHits).assertEqual(0);
        expect(result.positionHints.length).assertEqual(4);

        // 位置1: red不在密码中 → miss
        expect(result.positionHints[0]).assertEqual('miss');
        // 位置2: yellow匹配 → hit
        expect(result.positionHints[1]).assertEqual('hit');
        // 位置3: green不在密码中 → miss
        expect(result.positionHints[2]).assertEqual('miss');
        // 位置4: blue不在密码中 → miss
        expect(result.positionHints[3]).assertEqual('miss');
      });

      it('should return position hints for mixed scenario', 0, () => {
        const guess: Color[] = ['red', 'green', 'yellow', 'blue'];
        const password: Color[] = ['red', 'yellow', 'green', 'blue'];
        const result = GameService.evaluateGuessMapped(guess, password);

        expect(result.hits).assertEqual(2);
        expect(result.pseudoHits).assertEqual(2);
        expect(result.positionHints.length).assertEqual(4);

        // 位置1: red匹配 → hit
        expect(result.positionHints[0]).assertEqual('hit');
        // 位置2: green颜色对但位置错 → pseudoHit
        expect(result.positionHints[1]).assertEqual('pseudoHit');
        // 位置3: yellow颜色对但位置错 → pseudoHit
        expect(result.positionHints[2]).assertEqual('pseudoHit');
        // 位置4: blue匹配 → hit
        expect(result.positionHints[3]).assertEqual('hit');
      });

      it('should return all hits for perfect guess', 0, () => {
        const guess: Color[] = ['red', 'yellow', 'green', 'blue'];
        const password: Color[] = ['red', 'yellow', 'green', 'blue'];
        const result = GameService.evaluateGuessMapped(guess, password);

        expect(result.hits).assertEqual(4);
        expect(result.pseudoHits).assertEqual(0);
        expect(result.positionHints).assertEqual(['hit', 'hit', 'hit', 'hit']);
      });

      it('should return all misses for completely wrong guess', 0, () => {
        const guess: Color[] = ['purple', 'orange', 'purple', 'orange'];
        const password: Color[] = ['red', 'yellow', 'green', 'blue'];
        const result = GameService.evaluateGuessMapped(guess, password);

        expect(result.hits).assertEqual(0);
        expect(result.pseudoHits).assertEqual(0);
        expect(result.positionHints).assertEqual(['miss', 'miss', 'miss', 'miss']);
      });
    });
  });
}
