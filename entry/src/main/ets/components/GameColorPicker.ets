/**
 * 颜色选择器组件
 * 显示可用的颜色供玩家选择
 */

import { Color, ALL_COLORS, getColorValue } from '../constants/Colors';
import { ResponsiveUtils, RSP, RS } from '../utils/ResponsiveUtils';

@Component
export struct GameColorPicker {
  @Prop availableColors: Color[] = ALL_COLORS;
  @Prop selectedColor: Color | null = null;
  onColorSelect?: (color: Color) => void;

  build() {
    Row({ space: ResponsiveUtils.rsp(RSP.XS) }) {
      ForEach(this.availableColors, (color: Color) => {
        Column() {
          Circle()
            .fill(getColorValue(color))
            .width(40)  // 减小尺寸以适应小屏幕
            .height(40)
            .border(this.selectedColor === color ? {
              width: 3,
              color: '#212121'
            } : {
              width: 2,
              color: '#757575'
            })
            .onClick(() => {
              console.log(`=== Color selected: ${color} (value: ${getColorValue(color)}) ===`);
              if (this.onColorSelect) {
                this.onColorSelect(color);
              }
            })
        }
        .animation({
          duration: 200,
          curve: Curve.EaseInOut
        })
      })
    }
    .width('100%')
    .padding({ left: ResponsiveUtils.rsp(RSP.S), right: ResponsiveUtils.rsp(RSP.S), top: ResponsiveUtils.rsp(RSP.XXS), bottom: ResponsiveUtils.rsp(RSP.XXS) })
    .justifyContent(FlexAlign.SpaceEvenly)
    .onAppear(() => {
      console.log(`=== GameColorPicker: availableColors=[${this.availableColors.join(', ')}], selectedColor=${this.selectedColor} ===`);
    })
  }
}
