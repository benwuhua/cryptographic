/**
 * 提示指示器组件
 * 显示绿（位置颜色都正确）、黄（颜色正确位置错误）、灰（未猜中）提示点
 *
 * 支持两种模式:
 * - Mapped模式（初级）: 提示与槽位一一对应，第N个提示点表示第N个槽位的结果
 * - Unmapped模式（高级）: 提示不与槽位对应，只显示数量
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

  // 缓存生成的提示点类型数组
  private hintDots: string[] = [];

  aboutToAppear() {
    this.hintDots = this.generateHintDots();
  }

  /**
   * 创建单个提示条
   */
  @Builder
  HintBar(dotType: string, index: number) {
    if (index < this.maxDots && index < this.hintDots.length) {
      // 使用矩形条代替圆形
      Row()
        .width(20)  // 条形宽度
        .height(6)  // 条形高度（更扁平）
        .backgroundColor(this.getHintColor(dotType))
        .borderRadius(3)  // 圆角让条形更美观
        .border({ width: 0.5, color: '#757575' })
    }
  }

  build() {
    // 使用Row + Column创建2x2网格布局显示条形提示
    Column({ space: 4 }) {
      ForEach([0, 1], (row: number) => {
        Row({ space: 4 }) {
          ForEach([0, 1], (col: number) => {
            // 计算索引 - 直接传参不声明变量
            this.HintBar(this.hintDots[row * 2 + col], row * 2 + col)
          }, (col: number) => `hint_row_${row}_col_${col}`)
        }
        .justifyContent(FlexAlign.Start)
      }, (row: number) => `hint_row_${row}`)
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }

  /**
   * 获取提示点颜色
   * @param dotType 提示点类型
   * @returns 颜色值
   */
  private getHintColor(dotType: string): string {
    console.log(`=== getHintColor: dotType=${dotType}, hit color=${HintColors.hit}, pseudoHit color=${HintColors.pseudoHit}, miss color=${HintColors.miss} ===`);

    if (dotType === 'hit') {
      return '#4CAF50';  // Hardcoded GREEN for hits
    } else if (dotType === 'pseudoHit') {
      return '#FFC107';  // Hardcoded YELLOW for pseudo-hits
    } else {
      return '#E0E0E0';  // Hardcoded GRAY for misses
    }
  }

  /**
   * 生成提示点数组
   * @returns 提示点类型数组
   */
  private generateHintDots(): string[] {
    const dots: string[] = [];

    console.log(`=== HintIndicator.generateHintDots: hits=${this.hits}, pseudoHits=${this.pseudoHits} ===`);
    console.log(`=== positionHints: ${this.positionHints ? `[${this.positionHints.join(', ')}]` : 'undefined'} ===`);

    // 判断是否为mapped模式（有positionHints）
    if (this.positionHints && this.positionHints.length > 0) {
      // Mapped模式：按位置对应生成提示点
      console.log(`=== 使用Mapped模式：提示点与槽位一一对应 ===`);

      for (let i = 0; i < this.positionHints.length; i++) {
        const hint = this.positionHints[i];
        dots.push(hint);

        if (hint === 'hit') {
          console.log(`=== 位置${i + 1}: HIT (绿色) → 第${i + 1}个提示点 = GREEN ===`);
        } else if (hint === 'pseudoHit') {
          console.log(`=== 位置${i + 1}: PSEUDO-HIT (黄色) → 第${i + 1}个提示点 = YELLOW ===`);
        } else {
          console.log(`=== 位置${i + 1}: MISS (灰色) → 第${i + 1}个提示点 = GRAY ===`);
        }
      }
    } else {
      // Unmapped模式：按类型分组生成提示点
      console.log(`=== 使用Unmapped模式：提示点按类型分组 ===`);

      // 添加绿点（位置和颜色都对）
      for (let i = 0; i < this.hits; i++) {
        dots.push('hit');
        console.log(`=== Added hit dot ${i + 1}, color should be GREEN (#4CAF50) ===`);
      }

      // 添加黄点（颜色对位置错）
      for (let i = 0; i < this.pseudoHits; i++) {
        dots.push('pseudoHit');
        console.log(`=== Added pseudoHit dot ${i + 1}, color should be YELLOW (#FFC107) ===`);
      }

      // 添加灰点（未中）填满到4个
      const totalHits = this.hits + this.pseudoHits;
      for (let i = totalHits; i < this.maxDots; i++) {
        dots.push('miss');
        console.log(`=== Added miss dot ${i + 1}, color should be GRAY (#E0E0E0) ===`);
      }
    }

    console.log(`=== HintIndicator: Final dots array=[${dots.join(', ')}] ===`);

    return dots;
  }
}
