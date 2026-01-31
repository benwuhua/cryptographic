/**
 * 关卡卡片组件
 * 在关卡选择页面显示单个关卡
 */

import { StarRating } from './StarRating';
import { ResponsiveUtils, RF, RSP, RS } from '../utils/ResponsiveUtils';

@Component
export struct LevelCard {
  @Prop levelNumber: number = 1;
  @Prop stars: number = 0;           // 0-3星
  @Prop isUnlocked: boolean = false;
  @Prop isCurrent: boolean = false;
  onLevelClick?: () => void;

  build() {
    Column() {
      // 关卡数字
      Text(this.levelNumber.toString())
        .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isUnlocked ? '#212121' : '#9E9E9E')
        .margin({ top: ResponsiveUtils.rsp(RSP.S) })

      // 星级评分
      if (this.isUnlocked) {
        StarRating({
          stars: this.stars,
          starSize: 12
        })
          .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
      } else {
        // 锁定图标
        Text('🔒')
          .fontSize(12)
          .margin({ top: ResponsiveUtils.rsp(RSP.XXS) })
      }

      Blank()

      // 当前关卡指示器
      if (this.isCurrent) {
        Row() {
          Text('当前')
            .fontSize(ResponsiveUtils.rf(RF.BODY_S))
            .fontColor('#FFFFFF')
            .padding({
              left: ResponsiveUtils.rsp(RSP.XS),
              right: ResponsiveUtils.rsp(RSP.XS),
              top: ResponsiveUtils.rsp(RSP.XXS),
              bottom: ResponsiveUtils.rsp(RSP.XXS)
            })
            .backgroundColor('#2196F3')
            .borderRadius(ResponsiveUtils.rsp(RSP.XS))
        }
        .margin({ bottom: ResponsiveUtils.rsp(RSP.S) })
      }
    }
    .width('100%')
    .aspectRatio(1)
    .padding(ResponsiveUtils.rsp(RSP.XS))
    .backgroundColor(this.isUnlocked ? '#FFFFFF' : '#F5F5F5')
    .borderRadius(ResponsiveUtils.rsp(RSP.S))
    .shadow(this.isCurrent ? {
      radius: 8,
      color: '#4FC3F7',
      offsetX: 0,
      offsetY: 2
    } : {
      radius: 4,
      color: '#00000020',
      offsetX: 0,
      offsetY: 2
    })
    .border(this.isCurrent ? {
      width: 2,
      color: '#2196F3',
      radius: ResponsiveUtils.rsp(RSP.S)
    } : undefined)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (this.isUnlocked && this.onLevelClick) {
        this.onLevelClick();
      }
    })
    .animation({
      duration: 200,
      curve: Curve.EaseInOut
    })
  }
}
