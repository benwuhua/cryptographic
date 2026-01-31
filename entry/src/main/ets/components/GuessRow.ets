/**
 * 猜测行组件
 * 显示一行的猜测结果和提示反馈
 *
 * 支持两种提示位置：
 * - bottom: 提示在密码下方（简单模式，对应每个位置）
 * - right: 提示在右侧（困难模式，只显示数量）
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
  @Prop slotSize: number = 40;
  @Prop isActive: boolean = false;
  @Prop showHints: boolean = true;
  @Prop hintPosition: 'bottom' | 'right' = 'right';  // 提示位置

  build() {
    if (this.hintPosition === 'bottom') {
      // 简单模式：提示在密码下方
      Column({ space: ResponsiveUtils.rsp(RSP.XXS) }) {
        // 颜色槽位
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

        // 下方提示（2x2网格，对应每个位置）
        if (this.showHints) {
          HintIndicator({
            hits: this.hits,
            pseudoHits: this.pseudoHits,
            positionHints: this.positionHints,
            dotSize: 10,
            hintPosition: 'bottom'
          })
        }
      }
      .width('100%')
      .padding({ left: ResponsiveUtils.rsp(RSP.S), right: ResponsiveUtils.rsp(RSP.S), top: ResponsiveUtils.rsp(RSP.XXS), bottom: ResponsiveUtils.rsp(RSP.XXS) })
      .backgroundColor(this.isActive ? '#F0F7FF' : '#FFFFFF')
      .borderRadius(8)
      .margin({ top: 2, bottom: 2 })
    } else {
      // 困难模式：提示在右侧
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

        // 右侧：提示（只显示数量，不对应位置）
        if (this.showHints) {
          HintIndicator({
            hits: this.hits,
            pseudoHits: this.pseudoHits,
            positionHints: undefined,  // 困难模式不使用位置提示
            dotSize: 14,
            hintPosition: 'right'
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
}
