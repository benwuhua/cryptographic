/**
 * 首页
 * 游戏主菜单，提供三种游戏模式入口
 */

import { Navigator } from '../utils/Navigator';
import { UserRepository, UserStats } from '../repositories/UserRepository';
import { GameConfig } from '../constants/GameConfig';
import { ResponsiveUtils, RF, RSP } from '../utils/ResponsiveUtils';

interface GameModeButtonOptions {
  title: string;
  description: string;
  icon: string;
  color: string;
  isLocked?: boolean;
  onClick: () => void;
}

@Builder
function GameModeButton(options: GameModeButtonOptions) {
  Column() {
    Row() {
      Text(options.icon)
        .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
        .margin({ right: ResponsiveUtils.rsp(RSP.M) })

      Column() {
        Text(options.title)
          .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
          .fontWeight(FontWeight.Medium)
          .fontColor(options.isLocked ? '#9E9E9E' : '#212121')

        Text(options.description)
          .fontSize(ResponsiveUtils.rf(RF.BODY_M))
          .fontColor('#757575')
          .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (options.isLocked) {
        Text('🔒')
          .fontSize(ResponsiveUtils.rf(RF.BODY_L))
      } else {
        Text('>')
          .fontSize(ResponsiveUtils.rf(RF.BODY_L))
          .fontColor('#BDBDBD')
      }
    }
    .width('100%')
    .padding(ResponsiveUtils.rsp(RSP.M))
  }
  .width('100%')
  .backgroundColor('#FFFFFF')
  .borderRadius(12)
  .shadow({
    radius: 4,
    color: '#00000010',
    offsetX: 0,
    offsetY: 2
  })
  .border(options.isLocked ? {
    width: 1,
    color: '#E0E0E0'
  } : undefined)
  .onClick(options.onClick)
}

@Entry
@Component
struct HomePage {
  @State userStats: UserStats = {
    totalGames: 0,
    totalWins: 0,
    winRate: 0,
    bestStreak: 0,
    currentStreak: 0,
    easyUnlocked: 1,
    hardUnlocked: 0,
    totalStars: 0
  };
  @State isLoading: boolean = true;

  async aboutToAppear() {
    // 初始化响应式工具
    ResponsiveUtils.init();
    // 加载用户统计数据
    await this.loadUserStats();
  }

  /**
   * 加载用户统计数据
   */
  async loadUserStats() {
    try {
      this.userStats = await UserRepository.getUserStats();
      this.isLoading = false;
    } catch (error) {
      console.error('Failed to load user stats:', error);
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题
      Text('密码机')
        .fontSize(ResponsiveUtils.rf(RF.TITLE_XL))
        .fontWeight(FontWeight.Bold)
        .fontColor('#212121')
        .margin({ top: ResponsiveUtils.rsp(RSP.XL), bottom: ResponsiveUtils.rsp(RSP.M) })

      Text('破解密码，挑战智慧')
        .fontSize(ResponsiveUtils.rf(RF.BODY_L))
        .fontColor('#757575')
        .margin({ bottom: ResponsiveUtils.rsp(RSP.XL) })

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
        // 用户统计卡片
        Column() {
          Row() {
            Column() {
              Text(this.userStats.totalWins.toString())
                .fontSize(ResponsiveUtils.rf(RF.TITLE_L))
                .fontWeight(FontWeight.Bold)
                .fontColor('#2196F3')
              Text('胜利局数')
                .fontSize(ResponsiveUtils.rf(RF.BODY_S))
                .fontColor('#757575')
                .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
            }
            .layoutWeight(1)

            Column() {
              Text(`${this.userStats.winRate}%`)
                .fontSize(ResponsiveUtils.rf(RF.TITLE_L))
                .fontWeight(FontWeight.Bold)
                .fontColor('#4CAF50')
              Text('胜率')
                .fontSize(ResponsiveUtils.rf(RF.BODY_S))
                .fontColor('#757575')
                .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
            }
            .layoutWeight(1)

            Column() {
              Text(this.userStats.totalStars.toString())
                .fontSize(ResponsiveUtils.rf(RF.TITLE_L))
                .fontWeight(FontWeight.Bold)
                .fontColor('#FFD700')
              Text('总星数')
                .fontSize(ResponsiveUtils.rf(RF.BODY_S))
                .fontColor('#757575')
                .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
            }
            .layoutWeight(1)
          }
          .width('100%')
          .padding(ResponsiveUtils.rsp(RSP.M))
        }
        .width('90%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({
          radius: 8,
          color: '#00000015',
          offsetX: 0,
          offsetY: 2
        })
        .margin({ bottom: ResponsiveUtils.rsp(RSP.L) })

        // 游戏模式按钮
        Column({ space: ResponsiveUtils.rsp(RSP.S) }) {
          // 单人闯关模式
          GameModeButton({
            title: '单人闯关',
            description: `初级: ${this.userStats.easyUnlocked}/${GameConfig.EASY_LEVEL_COUNT}关`,
            icon: '🎯',
            color: '#2196F3',
            onClick: () => {
              Navigator.pushLevelSelect('easy');
            }
          })

          // 高级挑战模式
          GameModeButton({
            title: '高级挑战',
            description: this.userStats.hardUnlocked > 0
              ? `高级: ${this.userStats.hardUnlocked}/${GameConfig.HARD_LEVEL_COUNT}关`
              : '需通关初级模式解锁',
            icon: '🏆',
            color: '#FF9800',
            isLocked: this.userStats.hardUnlocked === 0,
            onClick: () => {
              if (this.userStats.hardUnlocked > 0) {
                Navigator.pushLevelSelect('hard');
              }
            }
          })

          // 练习模式
          GameModeButton({
            title: '练习模式',
            description: '随机密码，无限练习',
            icon: '💪',
            color: '#4CAF50',
            onClick: () => {
              Navigator.pushPractice();
            }
          })

          // 双人对战
          GameModeButton({
            title: '双人对战',
            description: '面对面PK，看谁更聪明',
            icon: '👥',
            color: '#9C27B0',
            onClick: () => {
              Navigator.pushDuelSetup();
            }
          })
        }
        .width('90%')

        Blank()

        // 底部设置按钮
        Row() {
          Text('设置')
            .fontSize(ResponsiveUtils.rf(RF.BODY_M))
            .fontColor('#757575')
            .onClick(() => {
              Navigator.pushSettings();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: ResponsiveUtils.rsp(RSP.XXL) })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }
}
