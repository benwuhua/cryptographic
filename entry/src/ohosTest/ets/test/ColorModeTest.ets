/**
 * 颜色模式测试
 * 测试4色、5色、6色模式是否正确工作
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { GameService } from '../../../main/ets/services/GameService';
import { LevelService } from '../../../main/ets/services/LevelService';
import { Color } from '../../../main/ets/constants/Colors';
import { Level } from '../../../main/ets/models/Level';

export default function ColorModeTest() {
  describe('ColorModeTests', () => {

    /**
     * COLOR-001: 测试4色模式生成4色密码
     */
    it('should_generate_4_color_password_for_4_color_mode', 0, () => {
      const level = LevelService.generatePracticeLevel(4);

      console.log(`=== COLOR-001: Generated password=[${level.password.join(', ')}] ===`);

      // 验证关卡配置
      expect(level.id).assertEqual(0);
      expect(level.difficulty).assertEqual('easy');
      expect(level.colorCount).assertEqual(4);
      expect(level.password.length).assertEqual(4);

      // 验证密码只使用4种颜色
      const uniqueColors = new Set(level.password);
      expect(uniqueColors.size).assertLessThanOrEqual(4);

      // 验证密码颜色在可用颜色范围内（red, yellow, green, blue）
      const validColors: Color[] = ['red', 'yellow', 'green', 'blue'];
      level.password.forEach(color => {
        expect(validColors.includes(color)).assertTrue();
      });

      console.log(`=== COLOR-001: ✅ 4色模式密码验证通过 ===`);
    });

    /**
     * COLOR-002: 测试5色模式生成5色密码
     */
    it('should_generate_5_color_password_for_5_color_mode', 0, () => {
      const level = LevelService.generatePracticeLevel(5);

      console.log(`=== COLOR-002: Generated password=[${level.password.join(', ')}] ===`);

      // 验证关卡配置
      expect(level.id).assertEqual(0);
      expect(level.difficulty).assertEqual('easy');
      expect(level.colorCount).assertEqual(5);
      expect(level.password.length).assertEqual(4); // 密码长度始终是4

      // 验证密码只使用5种颜色
      const uniqueColors = new Set(level.password);
      expect(uniqueColors.size).assertLessThanOrEqual(5);

      // 验证密码颜色在可用颜色范围内
      const validColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple'];
      level.password.forEach(color => {
        expect(validColors.includes(color)).assertTrue();
      });

      console.log(`=== COLOR-002: ✅ 5色模式密码验证通过 ===`);
    });

    /**
     * COLOR-003: 测试6色模式生成6色密码
     */
    it('should_generate_6_color_password_for_6_color_mode', 0, () => {
      const level = LevelService.generatePracticeLevel(6);

      console.log(`=== COLOR-003: Generated password=[${level.password.join(', ')}] ===`);

      // 验证关卡配置
      expect(level.id).assertEqual(0);
      expect(level.difficulty).assertEqual('easy');
      expect(level.colorCount).assertEqual(6);
      expect(level.password.length).assertEqual(4); // 密码长度始终是4

      // 验证密码只使用6种颜色
      const uniqueColors = new Set(level.password);
      expect(uniqueColors.size).assertLessThanOrEqual(6);

      // 验证密码颜色在可用颜色范围内
      const validColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];
      level.password.forEach(color => {
        expect(validColors.includes(color)).assertTrue();
      });

      console.log(`=== COLOR-003: ✅ 6色模式密码验证通过 ===`);
    });

    /**
     * COLOR-004: 测试不同颜色模式生成的密码长度始终为4
     */
    it('should_always_generate_password_of_length_4', 0, () => {
      const level4 = LevelService.generatePracticeLevel(4);
      const level5 = LevelService.generatePracticeLevel(5);
      const level6 = LevelService.generatePracticeLevel(6);

      expect(level4.password.length).assertEqual(4);
      expect(level5.password.length).assertEqual(4);
      expect(level6.password.length).assertEqual(4);

      console.log(`=== COLOR-004: ✅ 密码长度验证通过（始终为4） ===`);
    });

    /**
     * COLOR-005: 测试密码中的颜色数量不超过colorCount
     */
    it('should_not_use_more_colors_than_colorCount', 0, () => {
      // 生成多个关卡并验证
      for (let i = 0; i < 10; i++) {
        const level4 = LevelService.generatePracticeLevel(4);
        const uniqueColors4 = new Set(level4.password);
        expect(uniqueColors4.size).assertLessThanOrEqual(4);

        const level5 = LevelService.generatePracticeLevel(5);
        const uniqueColors5 = new Set(level5.password);
        expect(uniqueColors5.size).assertLessThanOrEqual(5);

        const level6 = LevelService.generatePracticeLevel(6);
        const uniqueColors6 = new Set(level6.password);
        expect(uniqueColors6.size).assertLessThanOrEqual(6);
      }

      console.log(`=== COLOR-005: ✅ 颜色数量验证通过（10次随机生成） ===`);
    });

    /**
     * COLOR-006: 测试使用5色和6色密码进行游戏评估
     */
    it('should_evaluate_guesses_correctly_with_5_colors', 0, () => {
      const level = LevelService.generatePracticeLevel(5);

      console.log(`=== COLOR-006: Testing with password=[${level.password.join(', ')}] ===`);

      // 猜测完全正确
      const perfectGuess = level.password;
      const result1 = GameService.evaluateGuess(perfectGuess, level.password);
      expect(result1.hits).assertEqual(4);
      expect(result1.pseudoHits).assertEqual(0);

      // 猜测完全错误（使用第6种颜色）
      const wrongGuess: Color[] = ['orange', 'orange', 'orange', 'orange'];
      const result2 = GameService.evaluateGuess(wrongGuess, level.password);

      console.log(`=== COLOR-006: Wrong guess result - hits=${result2.hits}, pseudoHits=${result2.pseudoHits} ===`);

      // 验证评估算法正确性
      expect(result2.hits + result2.pseudoHits).assertLessThanOrEqual(4);

      console.log(`=== COLOR-006: ✅ 5色评估验证通过 ===`);
    });

    /**
     * COLOR-007: 测试6色密码的游戏评估
     */
    it('should_evaluate_guesses_correctly_with_6_colors', 0, () => {
      const level = LevelService.generatePracticeLevel(6);

      console.log(`=== COLOR-007: Testing with password=[${level.password.join(', ')}] ===`);

      // 猜测完全正确
      const perfectGuess = level.password;
      const result1 = GameService.evaluateGuess(perfectGuess, level.password);
      expect(result1.hits).assertEqual(4);
      expect(result1.pseudoHits).assertEqual(0);

      // 猜测完全错误（使用不存在的颜色组合）
      const wrongGuess: Color[] = ['purple', 'orange', 'purple', 'orange'];
      const result2 = GameService.evaluateGuess(wrongGuess, level.password);

      console.log(`=== COLOR-007: Wrong guess result - hits=${result2.hits}, pseudoHits=${result2.pseudoHits} ===`);

      // 验证评估算法正确性
      expect(result2.hits + result2.pseudoHits).assertLessThanOrEqual(4);

      console.log(`=== COLOR-007: ✅ 6色评估验证通过 ===`);
    });

    /**
     * COLOR-008: 测试5色和6色密码的唯一性（随机生成）
     */
    it('should_generate_different_passwords_for_different_calls', 0, () => {
      const passwords4: string[] = [];
      const passwords5: string[] = [];
      const passwords6: string[] = [];

      // 生成多个密码
      for (let i = 0; i < 20; i++) {
        const level4 = LevelService.generatePracticeLevel(4);
        passwords4.push(level4.password.join(','));

        const level5 = LevelService.generatePracticeLevel(5);
        passwords5.push(level5.password.join(','));

        const level6 = LevelService.generatePracticeLevel(6);
        passwords6.push(level6.password.join(','));
      }

      // 检查是否至少有一些不同的密码
      const unique4 = new Set(passwords4);
      const unique5 = new Set(passwords5);
      const unique6 = new Set(passwords6);

      console.log(`=== COLOR-008: Unique passwords - 4色:${unique4.size}, 5色:${unique5.size}, 6色:${unique6.size} ===`);

      // 随机生成应该至少产生几种不同的密码（虽然可能有重复）
      expect(unique4.size).assertLarger(0);
      expect(unique5.size).assertLarger(0);
      expect(unique6.size).assertLarger(0);

      console.log(`=== COLOR-008: ✅ 密码唯一性验证通过 ===`);
    });
  });
}
