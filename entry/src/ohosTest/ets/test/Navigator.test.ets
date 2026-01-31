/**
 * Navigator 导航测试
 * 测试页面跳转、路由参数传递等功能
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Navigator } from '../../../main/ets/utils/Navigator';
import { Routes } from '../../../main/ets/constants/Routes';
import { router } from '@kit.ArkUI';

// Mock router for testing
const mockRouter = {
  pushUrl: (params: any) => {
    console.log('Mock pushUrl:', params);
  },
  replaceUrl: (params: any) => {
    console.log('Mock replaceUrl:', params);
  },
  back: () => {
    console.log('Mock back');
  },
  clear: () => {
    console.log('Mock clear');
  },
  getParams: () => {
    return {};
  }
};

export default function NavigatorTest() {
  describe('NavigatorTests', () => {

    /**
     * NAV-001: 主页导航测试
     */
    describe('HomeNavigationTests', () => {
      it('should navigate to home correctly', 0, () => {
        const originalReplaceUrl = router.replaceUrl;
        router.replaceUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.HOME);
          mockRouter.replaceUrl(params);
        };

        Navigator.toHome();

        router.replaceUrl = originalReplaceUrl;
      });
    });

    /**
     * NAV-101, NAV-102: 关卡选择导航测试
     */
    describe('LevelSelectNavigationTests', () => {
      it('should navigate to easy level select', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.LEVEL_SELECT);
          expect(params.params.difficulty).assertEqual('easy');
          mockRouter.pushUrl(params);
        };

        Navigator.pushLevelSelect('easy');

        router.pushUrl = originalPushUrl;
      });

      it('should navigate to hard level select', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.LEVEL_SELECT);
          expect(params.params.difficulty).assertEqual('hard');
          mockRouter.pushUrl(params);
        };

        Navigator.pushLevelSelect('hard');

        router.pushUrl = originalPushUrl;
      });
    });

    /**
     * NAV-201: 游戏页导航测试
     */
    describe('GameNavigationTests', () => {
      it('should navigate to game page with correct params', 0, () => {
        const originalPushUrl = router.pushUrl;
        const levelId = 50;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.GAME);
          expect(params.params.levelId).assertEqual(levelId);
          expect(params.params.mode).assertEqual('solo');
          mockRouter.pushUrl(params);
        };

        Navigator.pushGame(levelId);

        router.pushUrl = originalPushUrl;
      });

      it('should replace to game page', 0, () => {
        const originalReplaceUrl = router.replaceUrl;
        const levelId = 75;
        router.replaceUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.GAME);
          expect(params.params.levelId).assertEqual(levelId);
          mockRouter.replaceUrl(params);
        };

        Navigator.replaceGame(levelId);

        router.replaceUrl = originalReplaceUrl;
      });
    });

    /**
     * NAV-301, NAV-302: 结果页导航测试
     */
    describe('ResultNavigationTests', () => {
      it('should navigate to result page with win status', 0, () => {
        const originalReplaceUrl = router.replaceUrl;
        const params = {
          levelId: 10,
          isWin: true,
          attempts: 3,
          maxAttempts: 10,
          timeSpent: 45000,
          mode: 'solo' as const,
          password: ['red', 'yellow', 'green', 'blue'] as any
        };

        router.replaceUrl = (callParams: any) => {
          expect(callParams.url).assertEqual(Routes.RESULT);
          expect(callParams.params.isWin).assertEqual(true);
          mockRouter.replaceUrl(callParams);
        };

        Navigator.pushResult(params);

        router.replaceUrl = originalReplaceUrl;
      });

      it('should navigate to result page with lose status', 0, () => {
        const originalReplaceUrl = router.replaceUrl;
        const params = {
          levelId: 10,
          isWin: false,
          attempts: 10,
          maxAttempts: 10,
          timeSpent: 120000,
          mode: 'solo' as const,
          password: ['red', 'yellow', 'green', 'blue'] as any
        };

        router.replaceUrl = (callParams: any) => {
          expect(callParams.url).assertEqual(Routes.RESULT);
          expect(callParams.params.isWin).assertEqual(false);
          mockRouter.replaceUrl(callParams);
        };

        Navigator.pushResult(params);

        router.replaceUrl = originalReplaceUrl;
      });
    });

    /**
     * NAV-005: 练习模式导航测试
     */
    it('should navigate to practice page', 0, () => {
      const originalPushUrl = router.pushUrl;
      router.pushUrl = (params: any) => {
        expect(params.url).assertEqual(Routes.PRACTICE);
        mockRouter.pushUrl(params);
      };

      Navigator.pushPractice();

      router.pushUrl = originalPushUrl;
    });

    /**
     * NAV-006: 双人对战导航测试
     */
    it('should navigate to duel setup page', 0, () => {
      const originalPushUrl = router.pushUrl;
      router.pushUrl = (params: any) => {
        expect(params.url).assertEqual(Routes.DUEL_SETUP);
        mockRouter.pushUrl(params);
      };

      Navigator.pushDuelSetup();

      router.pushUrl = originalPushUrl;
    });

    /**
     * NAV-007: 设置页导航测试
     */
    it('should navigate to settings page', 0, () => {
      const originalPushUrl = router.pushUrl;
      router.pushUrl = (params: any) => {
        expect(params.url).assertEqual(Routes.SETTINGS);
        mockRouter.pushUrl(params);
      };

      Navigator.pushSettings();

      router.pushUrl = originalPushUrl;
    });

    /**
     * NAV-003, NAV-103: 返回导航测试
     */
    describe('BackNavigationTests', () => {
      it('should navigate back', 0, () => {
        const originalBack = router.back;
        let backCalled = false;
        router.back = () => {
          backCalled = true;
          mockRouter.back();
        };

        Navigator.pop();

        expect(backCalled).assertTrue();
        router.back = originalBack;
      });

      it('should navigate back (alias method)', 0, () => {
        const originalBack = router.back;
        let backCalled = false;
        router.back = () => {
          backCalled = true;
          mockRouter.back();
        };

        Navigator.back();

        expect(backCalled).assertTrue();
        router.back = originalBack;
      });
    });

    /**
     * NAV-108: 返回主页清空路由栈
     */
    it('should clear and navigate to home', 0, () => {
      const originalClear = router.clear;
      const originalReplaceUrl = router.replaceUrl;
      let clearCalled = false;

      router.clear = () => {
        clearCalled = true;
        mockRouter.clear();
      };

      router.replaceUrl = (params: any) => {
        expect(clearCalled).assertTrue();
        expect(params.url).assertEqual(Routes.HOME);
        mockRouter.replaceUrl(params);
      };

      Navigator.backToHome();

      router.clear = originalClear;
      router.replaceUrl = originalReplaceUrl;
    });

    /**
     * 测试路由参数获取
     */
    describe('RouteParametersTests', () => {
      it('should get route parameters', 0, () => {
        const originalGetParams = router.getParams;
        const testParams = { levelId: 50, practiceMode: false };

        router.getParams = () => {
          return testParams;
        };

        const params = Navigator.getParams();
        expect(params).assertEqual(testParams);

        router.getParams = originalGetParams;
      });
    });

    /**
     * 兼容性测试 - 旧方法名
     */
    describe('BackwardCompatibilityTests', () => {
      it('should support old toLevelSelect method', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.LEVEL_SELECT);
          mockRouter.pushUrl(params);
        };

        Navigator.toLevelSelect('easy');

        router.pushUrl = originalPushUrl;
      });

      it('should support old toGame method', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.GAME);
          mockRouter.pushUrl(params);
        };

        Navigator.toGame({ levelId: 10, mode: 'solo', difficulty: 'easy' });

        router.pushUrl = originalPushUrl;
      });

      it('should support old toResult method', 0, () => {
        const originalReplaceUrl = router.replaceUrl;
        router.replaceUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.RESULT);
          mockRouter.replaceUrl(params);
        };

        Navigator.toResult({
          levelId: 10,
          isWin: true,
          attempts: 3,
          maxAttempts: 10,
          timeSpent: 30000,
          mode: 'solo'
        });

        router.replaceUrl = originalReplaceUrl;
      });

      it('should support old toPractice method', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.PRACTICE);
          mockRouter.pushUrl(params);
        };

        Navigator.toPractice();

        router.pushUrl = originalPushUrl;
      });

      it('should support old toDuelSetup method', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.DUEL_SETUP);
          mockRouter.pushUrl(params);
        };

        Navigator.toDuelSetup();

        router.pushUrl = originalPushUrl;
      });

      it('should support old toSettings method', 0, () => {
        const originalPushUrl = router.pushUrl;
        router.pushUrl = (params: any) => {
          expect(params.url).assertEqual(Routes.SETTINGS);
          mockRouter.pushUrl(params);
        };

        Navigator.toSettings();

        router.pushUrl = originalPushUrl;
      });
    });
  });
}
