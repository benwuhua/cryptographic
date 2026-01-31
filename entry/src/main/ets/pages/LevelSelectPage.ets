/**
 * 关卡选择页面
 * 显示所有关卡供玩家选择
 */

import { Navigator } from '../utils/Navigator';
import { LevelRepository } from '../repositories/LevelRepository';
import { UserRepository } from '../repositories/UserRepository';
import { LevelService } from '../services/LevelService';
import { Difficulty } from '../models/Level';
import { GameConfig } from '../constants/GameConfig';
import { LevelCard } from '../components/LevelCard';
import { ResponsiveUtils, RF, RSP, RS } from '../utils/ResponsiveUtils';

interface UserProgressType {
  easyUnlocked: number;
  hardUnlocked: number;
}

interface LevelSelectParamsType {
  difficulty?: Difficulty;
}

@Entry
@Component
struct LevelSelectPage {
  @State difficulty: Difficulty = 'easy';
  @State userProgress: UserProgressType = {
    easyUnlocked: 1,
    hardUnlocked: 0
  };
  @State levelStars: Record<number, number> = {};
  @State currentLevel: number = 1;
  @State isLoading: boolean = true;

  private readonly LEVELS_PER_PAGE = 20;

  async aboutToAppear() {
    ResponsiveUtils.init();
    // 从路由参数获取难度
    const params = Navigator.getParams() as LevelSelectParamsType;
    if (params?.difficulty) {
      this.difficulty = params.difficulty;
    }

    await this.loadData();
  }

  /**
   * 加载数据
   */
  async loadData() {
    try {
      // 加载用户进度
      const progress = await UserRepository.getUserProgress();
      this.userProgress = {
        easyUnlocked: progress.easyUnlocked,
        hardUnlocked: progress.hardUnlocked
      };

      // 加载当前关卡
      this.currentLevel = this.difficulty === 'easy'
        ? progress.easyUnlocked
        : GameConfig.EASY_LEVEL_COUNT + progress.hardUnlocked;

      // 加载关卡星级
      const totalLevels = LevelService.getTotalLevels(this.difficulty);
      const startLevelId = LevelService.getStartLevelId(this.difficulty);
      const levelIds: number[] = [];
      for (let i = 0; i < totalLevels; i++) {
        levelIds.push(startLevelId + i);
      }
      this.levelStars = await UserRepository.getLevelsStars(levelIds);

      this.isLoading = false;
    } catch (error) {
      console.error('Failed to load data:', error);
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('<')
          .fontSize(ResponsiveUtils.rf(RF.BODY_L))
          .fontColor('#212121')
          .onClick(() => {
            Navigator.pop();
          })

        Text(this.difficulty === 'easy' ? '初级模式' : '高级模式')
          .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位，保持标题居中
        Text('')
          .width(ResponsiveUtils.rs(24))
      }
      .width('100%')
      .padding({ left: ResponsiveUtils.rsp(RSP.M), right: ResponsiveUtils.rsp(RSP.M), top: ResponsiveUtils.rsp(RSP.XS), bottom: ResponsiveUtils.rsp(RSP.XS) })
      .backgroundColor('#FFFFFF')

      if (this.isLoading) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(ResponsiveUtils.rs(50))
            .height(ResponsiveUtils.rs(50))
            .color('#2196F3')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // 进度信息
        Row() {
          Text(`已解锁: ${this.getUnlockedCount()}/${LevelService.getTotalLevels(this.difficulty)}`)
            .fontSize(ResponsiveUtils.rf(RF.BODY_M))
            .fontColor('#757575')

          Blank()

          Text(`通关进度: ${LevelService.getProgressPercentage(
            this.difficulty === 'easy' ? this.userProgress.easyUnlocked : this.userProgress.hardUnlocked,
            LevelService.getTotalLevels(this.difficulty)
          )}%`)
            .fontSize(ResponsiveUtils.rf(RF.BODY_M))
            .fontColor('#2196F3')
        }
        .width('90%')
        .padding(ResponsiveUtils.rsp(RSP.XS))
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ top: ResponsiveUtils.rsp(RSP.M), bottom: ResponsiveUtils.rsp(RSP.M) })

        // 关卡网格
        Scroll() {
          Grid() {
            ForEach(this.getLevelNumbers(), (levelNumber: number, index?: number) => {
              GridItem() {
                LevelCard({
                  levelNumber: levelNumber,
                  stars: this.levelStars[levelNumber] || 0,
                  isUnlocked: this.isLevelUnlocked(levelNumber),
                  isCurrent: levelNumber === this.currentLevel,
                  onLevelClick: () => {
                    this.startGame(levelNumber);
                  }
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .rowsGap(ResponsiveUtils.rsp(RSP.S))
          .columnsGap(ResponsiveUtils.rsp(RSP.S))
          .width('90%')
          .height('100%')
          .padding({ bottom: ResponsiveUtils.rsp(RSP.L) })
        }
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .align(Alignment.Top)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  /**
   * 获取关卡数字列表
   */
  private getLevelNumbers(): number[] {
    const totalLevels = LevelService.getTotalLevels(this.difficulty);
    const result: number[] = [];
    for (let i = 1; i <= totalLevels; i++) {
      result.push(i);
    }
    return result;
  }

  /**
   * 检查关卡是否解锁
   */
  private isLevelUnlocked(levelNumber: number): boolean {
    const unlockedCount = this.difficulty === 'easy'
      ? this.userProgress.easyUnlocked
      : this.userProgress.hardUnlocked;
    return levelNumber <= unlockedCount;
  }

  /**
   * 获取已解锁关卡数
   */
  private getUnlockedCount(): number {
    return this.difficulty === 'easy'
      ? this.userProgress.easyUnlocked
      : this.userProgress.hardUnlocked;
  }

  /**
   * 开始游戏
   */
  private startGame(levelNumber: number) {
    if (!this.isLevelUnlocked(levelNumber)) {
      return;
    }

    const levelId = this.difficulty === 'easy'
      ? levelNumber
      : GameConfig.EASY_LEVEL_COUNT + levelNumber;

    Navigator.pushGame(levelId);
  }
}
