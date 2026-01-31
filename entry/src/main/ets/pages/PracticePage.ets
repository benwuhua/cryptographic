/**
 * 练习模式页面
 * 随机密码练习
 */

import { Navigator } from '../utils/Navigator';
import { ResponsiveUtils, RF, RSP, RS } from '../utils/ResponsiveUtils';

@Entry
@Component
struct PracticePage {
  async aboutToAppear() {
    ResponsiveUtils.init();
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

        Text('练习模式')
          .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(ResponsiveUtils.rs(24))
      }
      .width('100%')
      .padding({ left: ResponsiveUtils.rsp(RSP.M), right: ResponsiveUtils.rsp(RSP.M), top: ResponsiveUtils.rsp(RSP.XS), bottom: ResponsiveUtils.rsp(RSP.XS) })
      .backgroundColor('#FFFFFF')

      // 颜色选择
      Column({ space: ResponsiveUtils.rsp(RSP.L) }) {
        Text('选择难度')
          .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
          .fontWeight(FontWeight.Medium)
          .margin({ top: ResponsiveUtils.rsp(RSP.XXL) })

        this.DifficultyButton('4色模式', '初级难度', '#2196F3', 4)
        this.DifficultyButton('5色模式', '中级难度', '#FF9800', 5)
        this.DifficultyButton('6色模式', '高级难度', '#F44336', 6)
      }
      .width('90%')

      Blank()

      // 说明文字
      Text('练习模式使用随机生成的密码，可以无限次练习')
        .fontSize(ResponsiveUtils.rf(RF.BODY_M))
        .fontColor('#757575')
        .textAlign(TextAlign.Center)
        .width('90%')
        .padding({ bottom: ResponsiveUtils.rsp(RSP.L) })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  DifficultyButton(title: string, description: string, color: string, colorCount: number) {
    Column() {
      Row() {
        Text(title)
          .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
          .fontWeight(FontWeight.Medium)
          .fontColor('#212121')

        Blank()

        Text('开始')
          .fontSize(ResponsiveUtils.rf(RF.BODY_L))
          .fontColor(color)
      }
      .width('100%')
      .padding(ResponsiveUtils.rsp(RSP.M))

      Text(description)
        .fontSize(ResponsiveUtils.rf(RF.BODY_M))
        .fontColor('#757575')
        .width('100%')
        .textAlign(TextAlign.Start)
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
    .onClick(() => {
      // 启动练习模式游戏，使用practiceMode标志和选择的颜色数量
      Navigator.pushGame(0, true, colorCount); // 传递colorCount参数
    })
  }
}
