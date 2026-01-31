/**
 * 提示指示器组件
 * 显示绿（位置颜色都正确）、黄（颜色正确位置错误）、灰（未猜中）提示点
 *
 * 支持两种提示位置：
 * - bottom: 提示在密码下方（简单模式，对应每个位置，2x2网格）
 * - right: 提示在右侧（困难模式，只显示数量，1x4或2x2网格）
 *
 * 提示含义：
 * - 🟢 绿色：颜色和位置都对
 * - 🟡 黄色：颜色对但位置错
 * - ⚪ 灰色：颜色不在密码中
 */

import { HintColors } from '../constants/Colors';
import { PositionHint } from '../services/GameService';

@Component
export struct HintIndicator {
  @Prop hits: number = 0;          // 命中数（位置颜色都对）
  @Prop pseudoHits: number = 0;    // 伪命中数（颜色对位置错）
  @Prop positionHints?: PositionHint[];  // 位置级别的提示（mapped模式）
  @Prop dotSize: number = 12;      // 提示点大小
  @Prop maxDots: number = 4;       // 最大显示点数
  @Prop hintPosition: 'bottom' | 'right' = 'right';  // 提示位置

  build() {
    if (this.hintPosition === 'bottom') {
      // 简单模式：提示在下方，2x2网格，对应每个位置
      Column({ space: 3 }) {
        Row({ space: 3 }) {
          ForEach([0, 1], (index: number) => {
            this.HintDot(this.getDotColorByIndex(index), index)
          })
        }
        Row({ space: 3 }) {
          ForEach([2, 3], (index: number) => {
            this.HintDot(this.getDotColorByIndex(index), index)
          })
        }
      }
      .justifyContent(FlexAlign.Center)
    } else {
      // 困难模式：提示在右侧，2x2网格，只显示数量
      // 不按位置显示，只显示总数
      Column({ space: 3 }) {
        Row({ space: 3 }) {
          this.HintDot(this.getTotalHitColor(), 0)
          this.HintDot(this.getTotalHitColor(), 1)
        }
        Row({ space: 3 }) {
          this.HintDot(this.getTotalHitColor(), 2)
          this.HintDot(this.getTotalHitColor(), 3)
        }
      }
      .justifyContent(FlexAlign.Center)
    }
  }

  /**
   * 单个提示点
   */
  @Builder
  HintDot(color: string, index: number) {
    Row()
      .width(this.dotSize)
      .height(this.dotSize)
      .backgroundColor(color)
      .borderRadius(this.dotSize / 2)
      .border({ width: 1, color: '#CCCCCC' })
  }

  /**
   * 获取简单模式的提示颜色（按位置）
   */
  private getDotColorByIndex(index: number): string {
    if (this.positionHints && this.positionHints[index]) {
      const hint = this.positionHints[index];
      if (hint === 'hit') {
        return '#4CAF50';  // 绿色
      } else if (hint === 'pseudoHit') {
        return '#FFC107';  // 黄色
      }
    }
    return '#E0E0E0';  // 灰色/透明
  }

  /**
   * 获取困难模式的提示颜色（只显示数量，不区分位置）
   */
  private getTotalHitColor(): string {
    // 困难模式：只按数量显示，不指明具体位置
    // 显示顺序：绿色先，然后黄色，最后灰色
    const total = this.hits + this.pseudoHits;
    const greenDots = this.hits;
    const yellowDots = this.pseudoHits;

    // 计算当前索引对应的颜色
    if (this.hits > 0) {
      // 还有绿色点
      return '#4CAF50';
    } else if (this.pseudoHits > 0) {
      // 还有黄色点
      return '#FFC107';
    } else {
      // 灰色
      return '#E0E0E0';
    }
  }
}
