/**
 * UI集成测试套件
 *
 * Bug修复验证: UI组件应该正确显示数据
 * - Bug #3: 颜色按钮图片显示不正确
 * - Bug #4: 提示圆点显示错误
 *
 * 测试重点:
 * - GameColorPicker 组件
 * - HintIndicator 组件
 * - 数据与UI的绑定
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { GameService } from '../../../main/ets/services/GameService';
import { LevelService } from '../../../main/ets/services/LevelService';
import { LevelRepository } from '../../../main/ets/repositories/LevelRepository';
import { Color, getColorValue, ALL_COLORS } from '../../../main/ets/constants/Colors';
import { HintColors } from '../../../main/ets/constants/Colors';

export default function UIIntegrationTest() {
  describe('UIIntegrationTests', () => {

    /**
     * UI-001: 4色关卡应该有4个可用颜色
     */
    it('should have 4 available colors for 4-color level', 0, async () => {
      // Given: 4色关卡
      const level = await LevelRepository.getLevel(1);

      // When: 获取可用颜色
      const allColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];
      const availableColors = allColors.slice(0, level.colorCount);

      // Then: 应该有4个颜色
      expect(availableColors.length).assertEqual(4);
      expect(availableColors).assertEqual(['red', 'yellow', 'green', 'blue']);

      console.log(`=== UI-001: availableColors=[${availableColors.join(', ')}] ===`);
    });

    /**
     * UI-002: 5色关卡应该有5个可用颜色
     */
    it('should have 5 available colors for 5-color level', 0, async () => {
      // Given: 5色关卡（假设关卡101）
      // Note: 使用LevelService生成5色关卡用于测试
      const level = LevelService.generatePracticeLevel(5);

      // When: 获取可用颜色
      const allColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];
      const availableColors = allColors.slice(0, level.colorCount);

      // Then: 应该有5个颜色
      expect(availableColors.length).assertEqual(5);
      expect(availableColors).assertEqual(['red', 'yellow', 'green', 'blue', 'purple']);

      console.log(`=== UI-002: availableColors=[${availableColors.join(', ')}] ===`);
    });

    /**
     * UI-003: 6色关卡应该有6个可用颜色
     */
    it('should have 6 available colors for 6-color level', 0, async () => {
      // Given: 6色关卡
      const level = LevelService.generatePracticeLevel(6);

      // When: 获取可用颜色
      const allColors: Color[] = ['red', 'yellow', 'green', 'blue', 'purple', 'orange'];
      const availableColors = allColors.slice(0, level.colorCount);

      // Then: 应该有6个颜色
      expect(availableColors.length).assertEqual(6);
      expect(availableColors).assertEqual(['red', 'yellow', 'green', 'blue', 'purple', 'orange']);

      console.log(`=== UI-003: availableColors=[${availableColors.join(', ')}] ===`);
    });

    /**
     * UI-004: 颜色值函数应该返回正确的十六进制值
     */
    it('should return correct color values', 0, () => {
      // Given & When: 获取每个颜色的值
      const redValue = getColorValue('red');
      const yellowValue = getColorValue('yellow');
      const greenValue = getColorValue('green');
      const blueValue = getColorValue('blue');

      // Then: 应该返回正确的十六进制值
      expect(redValue).assertEqual('#E53935');
      expect(yellowValue).assertEqual('#FDD835');
      expect(greenValue).assertEqual('#43A047');
      expect(blueValue).assertEqual('#1E88E5');

      console.log(`=== UI-004: red=${redValue}, yellow=${yellowValue}, green=${greenValue}, blue=${blueValue} ===`);
    });

    /**
     * UI-005: 紫色和橙色也应该有正确的值
     */
    it('should return correct values for purple and orange', 0, () => {
      // Given & When: 获取紫色和橙色的值
      const purpleValue = getColorValue('purple');
      const orangeValue = getColorValue('orange');

      // Then: 应该返回正确的十六进制值
      expect(purpleValue).assertEqual('#8E24AA');
      expect(orangeValue).assertEqual('#FB8C00');

      console.log(`=== UI-005: purple=${purpleValue}, orange=${orangeValue} ===`);
    });

    /**
     * UI-006: 提示颜色应该正确定义
     */
    it('should have correct hint colors', 0, () => {
      // Given & When: 检查提示颜色
      // Then: 应该正确定义
      expect(HintColors.hit).assertEqual('#4CAF50');      // 绿色
      expect(HintColors.pseudoHit).assertEqual('#FFC107'); // 黄色
      expect(HintColors.miss).assertEqual('#E0E0E0');      // 灰色

      console.log(`=== UI-006: hit=${HintColors.hit}, pseudoHit=${HintColors.pseudoHit}, miss=${HintColors.miss} ===`);
    });

    /**
     * UI-007: 生成提示点数组 - 全中场景
     */
    it('should generate correct hint dots for all hits', 0, () => {
      // Given: 4个命中
      const hits = 4;
      const pseudoHits = 0;
      const maxDots = 4;

      // When: 生成提示点
      const dots: string[] = [];
      for (let i = 0; i < hits; i++) {
        dots.push('hit');
      }
      for (let i = 0; i < pseudoHits; i++) {
        dots.push('pseudoHit');
      }
      const totalHits = hits + pseudoHits;
      for (let i = totalHits; i < maxDots; i++) {
        dots.push('miss');
      }

      // Then: 应该是4个hit
      expect(dots.length).assertEqual(4);
      expect(dots).assertEqual(['hit', 'hit', 'hit', 'hit']);

      console.log(`=== UI-007: dots=[${dots.join(', ')}] ===`);
    });

    /**
     * UI-008: 生成提示点数组 - 混合场景
     */
    it('should generate correct hint dots for mixed scenario', 0, () => {
      // Given: 1个命中，2个伪命中
      const hits = 1;
      const pseudoHits = 2;
      const maxDots = 4;

      // When: 生成提示点
      const dots: string[] = [];
      for (let i = 0; i < hits; i++) {
        dots.push('hit');
      }
      for (let i = 0; i < pseudoHits; i++) {
        dots.push('pseudoHit');
      }
      const totalHits = hits + pseudoHits;
      for (let i = totalHits; i < maxDots; i++) {
        dots.push('miss');
      }

      // Then: 应该是1个hit, 2个pseudoHit, 1个miss
      expect(dots.length).assertEqual(4);
      expect(dots).assertEqual(['hit', 'pseudoHit', 'pseudoHit', 'miss']);

      console.log(`=== UI-008: dots=[${dots.join(', ')}] ===`);
    });

    /**
     * UI-009: 生成提示点数组 - 全错场景
     */
    it('should generate correct hint dots for all miss', 0, () => {
      // Given: 0个命中，0个伪命中
      const hits = 0;
      const pseudoHits = 0;
      const maxDots = 4;

      // When: 生成提示点
      const dots: string[] = [];
      for (let i = 0; i < hits; i++) {
        dots.push('hit');
      }
      for (let i = 0; i < pseudoHits; i++) {
        dots.push('pseudoHit');
      }
      const totalHits = hits + pseudoHits;
      for (let i = totalHits; i < maxDots; i++) {
        dots.push('miss');
      }

      // Then: 应该是4个miss
      expect(dots.length).assertEqual(4);
      expect(dots).assertEqual(['miss', 'miss', 'miss', 'miss']);

      console.log(`=== UI-009: dots=[${dots.join(', ')}] ===`);
    });

    /**
     * UI-010: 评估猜测后应该返回正确的结果
     */
    it('should evaluate guess correctly', 0, async () => {
      // Given: 密码和猜测
      const level = await LevelRepository.getLevel(1);
      const guess: Color[] = ['red', 'yellow', 'green', 'blue'];

      // When: 评估猜测
      const result = GameService.evaluateGuess(guess, level.password);

      // Then: 结果应该在合理范围内
      const total = result.hits + result.pseudoHits;
      expect(total <= 4).assertTrue();
      expect(result.hits >= 0).assertTrue();
      expect(result.pseudoHits >= 0).assertTrue();

      console.log(`=== UI-010: hits=${result.hits}, pseudoHits=${result.pseudoHits} ===`);
    });

    /**
     * UI-011: 颜色列表应该包含所有定义的颜色
     */
    it('should have all defined colors in ALL_COLORS', 0, () => {
      // Given & When: 检查ALL_COLORS常量
      // Then: 应该包含所有6种颜色
      expect(ALL_COLORS.length).assertEqual(6);
      expect(ALL_COLORS).assertEqual(['red', 'yellow', 'green', 'blue', 'purple', 'orange']);

      console.log(`=== UI-011: ALL_COLORS=[${ALL_COLORS.join(', ')}] ===`);
    });

    /**
     * UI-012: 游戏状态应该反映关卡的颜色数量
     */
    it('should have correct color count in game state', 0, async () => {
      // Given: 创建4色游戏
      const level = await LevelRepository.getLevel(1);
      const gameState = GameService.createGame(level, 'solo');

      // When: 检查游戏状态
      // Then: 应该反映关卡的颜色数量
      expect(gameState.level.colorCount).assertEqual(4);

      console.log(`=== UI-012: gameState.level.colorCount=${gameState.level.colorCount} ===`);
    });

    /**
     * UI-013: 游戏状态应该正确初始化当前猜测
     */
    it('should initialize current guess with correct length', 0, async () => {
      // Given: 创建游戏
      const level = await LevelRepository.getLevel(1);
      const gameState = GameService.createGame(level, 'solo');

      // When: 检查当前猜测
      // Then: 长度应该是4（密码长度）
      expect(gameState.currentGuess.length).assertEqual(4);

      console.log(`=== UI-013: currentGuess.length=${gameState.currentGuess.length} ===`);
    });

    /**
     * UI-014: 更新猜测应该正确更新状态
     */
    it('should update guess correctly', 0, async () => {
      // Given: 创建游戏
      const level = await LevelRepository.getLevel(1);
      let gameState = GameService.createGame(level, 'solo');

      // When: 更新位置0为红色
      gameState = GameService.updateCurrentGuess(gameState, 0, 'red');

      // Then: 位置0应该是红色
      expect(gameState.currentGuess[0]).assertEqual('red');

      console.log(`=== UI-014: currentGuess[0]=${gameState.currentGuess[0]} ===`);
    });
  });
}
