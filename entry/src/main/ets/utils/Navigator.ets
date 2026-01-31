/**
 * 导航封装工具
 */

import { router } from '@kit.ArkUI';
import { Routes } from '../constants/Routes';
import { Difficulty } from '../models/Level';
import { GamePageParams, ResultPageParams } from '../models/RouteParams';

export class Navigator {

  /**
   * 跳转到主页（替换当前页面）
   */
  static toHome(): void {
    router.replaceUrl({ url: Routes.HOME });
  }

  /**
   * 跳转到关卡选择页
   */
  static pushLevelSelect(difficulty: Difficulty): void {
    router.pushUrl({
      url: Routes.LEVEL_SELECT,
      params: { difficulty }
    });
  }

  /**
   * 跳转到游戏页
   */
  static pushGame(levelId: number, practiceMode: boolean = false, colorCount?: number): void {
    const params: GamePageParams = {
      mode: practiceMode ? 'practice' : 'solo',
      levelId: levelId,
      difficulty: levelId <= 100 ? 'easy' : 'hard',
      colorCount: colorCount  // 传递colorCount参数
    };
    router.pushUrl({
      url: Routes.GAME,
      params
    });
  }

  /**
   * 替换为游戏页
   */
  static replaceGame(levelId: number): void {
    const params: GamePageParams = {
      mode: 'solo',
      levelId: levelId,
      difficulty: levelId <= 100 ? 'easy' : 'hard'
    };
    router.replaceUrl({
      url: Routes.GAME,
      params
    });
  }

  /**
   * 跳转到结果页（替换当前页面，防止返回到游戏页）
   */
  static pushResult(params: ResultPageParams): void {
    router.replaceUrl({
      url: Routes.RESULT,
      params
    });
  }

  /**
   * 跳转到双人对战设置页
   */
  static pushDuelSetup(): void {
    router.pushUrl({ url: Routes.DUEL_SETUP });
  }

  /**
   * 使用自定义参数跳转到指定页面
   */
  static pushParams<T>(params: T): void {
    router.pushUrl({
      url: Routes.GAME,
      params: params as Object
    });
  }

  /**
   * 跳转到自由练习页
   */
  static pushPractice(): void {
    router.pushUrl({ url: Routes.PRACTICE });
  }

  /**
   * 跳转到设置页
   */
  static pushSettings(): void {
    router.pushUrl({ url: Routes.SETTINGS });
  }

  /**
   * 返回上一页
   */
  static pop(): void {
    router.back();
  }

  /**
   * 返回上一页
   */
  static back(): void {
    router.back();
  }

  /**
   * 返回主页（清空路由栈）
   */
  static backToHome(): void {
    router.clear();
    router.replaceUrl({ url: Routes.HOME });
  }

  /**
   * 获取当前页面参数
   */
  static getParams<T>(): T {
    return router.getParams() as T;
  }

  // === 以下为兼容旧代码的方法 ===

  static toLevelSelect(difficulty: Difficulty): void {
    Navigator.pushLevelSelect(difficulty);
  }

  static toGame(params: GamePageParams): void {
    router.pushUrl({
      url: Routes.GAME,
      params
    });
  }

  static toResult(params: ResultPageParams): void {
    Navigator.pushResult(params);
  }

  static toDuelSetup(): void {
    Navigator.pushDuelSetup();
  }

  static toPractice(): void {
    Navigator.pushPractice();
  }

  static toSettings(): void {
    Navigator.pushSettings();
  }
}
