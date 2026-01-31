/**
 * 星级显示组件
 * 显示1-3星评分
 */

import { ResponsiveUtils, RSP } from '../utils/ResponsiveUtils';

@Component
export struct StarRating {
  @Prop stars: number = 0;       // 0-3星
  @Prop starSize: number = 20;   // 星星大小
  @Prop filledColor: string = '#FFD700';  // 金色
  @Prop emptyColor: string = '#E0E0E0';  // 灰色

  build() {
    Row({ space: ResponsiveUtils.rsp(RSP.XXS) }) {
      ForEach([1, 2, 3], (starNum: number) => {
        Text(this.getStarIcon(starNum))
          .fontSize(this.starSize)
      })
    }
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 获取星星图标
   * @param starNum 星星位置 (1-3)
   * @returns 星星图标
   */
  private getStarIcon(starNum: number): string {
    if (starNum <= this.stars) {
      return '⭐'; // 实心星星
    } else {
      return '☆'; // 空心星星
    }
  }
}
