/**
 * 设置页面
 */

import { Navigator } from '../utils/Navigator';
import { UserRepository } from '../repositories/UserRepository';
import { ResponsiveUtils, RF, RSP, RS } from '../utils/ResponsiveUtils';

interface SettingItem {
  title: string;
  value: string;
  hasSwitch?: boolean;
  hasArrow?: boolean;
}

@Entry
@Component
struct SettingsPage {
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

        Text('设置')
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

      Scroll() {
        Column({ space: 0 }) {
          // 设置项
          this.SettingSection('游戏设置', [
            { title: '音效', value: '开启', hasSwitch: true },
            { title: '震动', value: '开启', hasSwitch: true },
            { title: '提示模式', value: '仅初级' }
          ])

          this.SettingSection('显示设置', [
            { title: '色盲模式', value: '关闭', hasSwitch: true },
            { title: '动画效果', value: '开启', hasSwitch: true }
          ])

          this.SettingSection('关于', [
            { title: '版本', value: '1.0.0' },
            { title: '游戏规则', value: '', hasArrow: true }
          ])

          // 重置数据按钮
          Button('重置所有数据')
            .type(ButtonType.Normal)
            .backgroundColor('#F44336')
            .fontColor('#FFFFFF')
            .borderRadius(8)
            .width('90%')
            .height(RS.BUTTON_HEIGHT)
            .margin({ top: ResponsiveUtils.rsp(RSP.L) })
            .onClick(() => {
              this.showResetDialog();
            })
        }
        .width('100%')
        .margin({ top: ResponsiveUtils.rsp(RSP.L) })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FAFAFA')
  }

  @Builder
  SettingSection(title: string, items: SettingItem[]) {
    Column() {
      Text(title)
        .fontSize(ResponsiveUtils.rf(RF.BODY_M))
        .fontColor('#757575')
        .width('90%')
        .margin({ top: ResponsiveUtils.rsp(RSP.L), bottom: ResponsiveUtils.rsp(RS.DOT_SIZE) })

      Column() {
        ForEach(items, (item: SettingItem, index: number) => {
          Column() {
            Row() {
              Text(item.title)
                .fontSize(ResponsiveUtils.rf(RF.BODY_L))
                .fontColor('#212121')
                .layoutWeight(1)

              if (item.hasSwitch) {
                // Toggle开关
                Toggle({ type: ToggleType.Switch, isOn: item.value === '开启' })
                  .selectedColor('#2196F3')
              } else if (item.hasArrow) {
                Text('>')
                  .fontSize(ResponsiveUtils.rf(RF.TITLE_M))
                  .fontColor('#BDBDBD')
              } else {
                Text(item.value)
                  .fontSize(ResponsiveUtils.rf(RF.BODY_M))
                  .fontColor('#757575')
              }
            }
            .width('100%')
            .padding(ResponsiveUtils.rsp(RSP.M))

            if (index < items.length - 1) {
              Divider()
                .color('#E0E0E0')
                .strokeWidth(1)
                .margin({ left: ResponsiveUtils.rsp(RSP.M), right: ResponsiveUtils.rsp(RSP.M) })
            }
          }
          .width('100%')
        })
      }
      .width('90%')
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .shadow({
        radius: 4,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  /**
   * 显示重置确认对话框
   */
  private showResetDialog(): void {
    // TODO: 实现对话框
    console.log('Show reset dialog');

    // 重置数据
    UserRepository.clearAllData();
  }
}
