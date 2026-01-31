/**
 * 颜色槽位组件
 * 显示单个颜色槽位，可以为空或填充颜色
 */

import { Color, getColorValue } from '../constants/Colors';

@Component
export struct ColorSlot {
  @Prop color: Color | null = null;
  @Prop slotSize: number = 50;
  @Prop isClickable: boolean = true;
  @Prop isSelected: boolean = false;
  onSlotClick?: () => void;

  build() {
    Column() {
      if (this.color) {
        Circle()
          .fill(getColorValue(this.color))
          .width(this.slotSize)
          .height(this.slotSize)
      } else {
        Circle()
          .fill('#E0E0E0')
          .width(this.slotSize)
          .height(this.slotSize)
          .stroke('#BDBDBD')
          .strokeWidth(2)
      }
    }
    .width(this.slotSize + 10)
    .height(this.slotSize + 10)
    .justifyContent(FlexAlign.Center)
    .border(this.isSelected ? {
      width: 3,
      color: '#2196F3',
      radius: this.slotSize / 2 + 5
    } : undefined)
    .onClick(() => {
      if (this.isClickable && this.onSlotClick) {
        this.onSlotClick();
      }
    })
  }
}
