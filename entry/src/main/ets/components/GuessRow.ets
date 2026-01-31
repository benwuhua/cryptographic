/**
 * 猜测行组件
 * 显示一行的猜测结果和提示反馈
 */

import { Color } from '../constants/Colors';
import { Attempt } from '../models/Attempt';
import { ColorSlot } from './ColorSlot';
import { HintIndicator } from './HintIndicator';
import { PositionHint } from '../services/GameService';
import { ResponsiveUtils, RSP } from '../utils/ResponsiveUtils';

@Component
export struct GuessRow {
  @Prop guess: Color[];
  @Prop hits: number = 0;
  @Prop pseudoHits: number = 0;
  @Prop positionHints?: PositionHint[];  // 位置级别的提示
  @Prop slotSize: number = 45;
  @Prop isActive: boolean = false;
  @Prop showHints: boolean = true;

  build() {
    Row({ space: ResponsiveUtils.rsp(RSP.S) }) {
      // 左侧：4个颜色槽位
      Row({ space: ResponsiveUtils.rsp(RSP.XS) }) {
        ForEach([0, 1, 2, 3], (index: number) => {
          ColorSlot({
            color: this.guess[index] || null,
            slotSize: this.slotSize,
            isClickable: false,
            isSelected: false
          })
        })
      }
      .layoutWeight(1)

      // 右侧：提示指示器
      if (this.showHints) {
        HintIndicator({
          hits: this.hits,
          pseudoHits: this.pseudoHits,
          positionHints: this.positionHints,
          dotSize: 12
        })
      }
    }
    .width('100%')
    .padding({ left: ResponsiveUtils.rsp(RSP.S), right: ResponsiveUtils.rsp(RSP.S), top: ResponsiveUtils.rsp(RSP.XXS), bottom: ResponsiveUtils.rsp(RSP.XXS) })
    .backgroundColor(this.isActive ? '#F5F5F5' : '#FFFFFF')
    .borderRadius(8)
    .margin({ top: 2, bottom: 2 })
  }
}
