/**
 * 加载指示器组件
 * 显示加载状态
 */

@Component
export struct LoadingIndicator {
  @Prop message: string = '加载中...';

  build() {
    Column() {
      LoadingProgress()
        .width(50)
        .height(50)
        .color('#2196F3')

      Text(this.message)
        .fontSize(14)
        .fontColor('#757575')
        .margin({ top: 16 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
