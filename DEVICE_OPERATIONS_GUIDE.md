# 📱 真机操作指南

## 安装应用

### 方法1：使用一键安装脚本（推荐）

```bash
./install_to_device.sh
```

### 方法2：手动安装

```bash
# 1. 检查设备连接
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc list targets

# 2. 安装应用
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc install \
  entry/build/default/outputs/default/entry-default-signed.hap
```

### 方法3：使用 DevEco Studio

1. 确保设备已通过 USB 连接
2. 在 DevEco Studio 中点击运行按钮 ▶️
3. 选择目标设备
4. 应用会自动构建并安装

---

## 应用管理

### 启动应用

```bash
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa start \
  -a EntryAbility -b com.ryan.mi
```

### 停止应用

```bash
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa force-stop \
  com.ryan.mi
```

### 卸载应用

```bash
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc uninstall com.ryan.mi
```

### 查看已安装应用

```bash
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell bm list -b com.ryan.mi
```

---

## 调试和日志

### 查看实时日志

```bash
# 查看所有日志
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog

# 只查看应用日志
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep 'com.ryan.mi'

# 查看算法评估日志
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep '评估猜测'
```

### 清除日志

```bash
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog -r
```

### 在 DevEco Studio 中查看日志

1. 打开 DevEco Studio
2. 底部工具栏点击 **Hilog**
3. 选择您的设备
4. 在搜索框输入 `com.ryan.mi` 过滤应用日志
5. 输入 `评估猜测` 查看算法日志

---

## 快速操作脚本

### 重新安装应用

```bash
# 卸载旧版本并安装新版本
./install_to_device.sh
```

### 查看算法日志

```bash
# 启动日志监控
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep '评估猜测'

# 然后在设备上玩游戏，提交猜测后，终端会显示详细的算法过程
```

### 重启应用

```bash
# 停止应用
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa force-stop com.ryan.mi

# 启动应用
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa start -a EntryAbility -b com.ryan.mi
```

---

## Bug 验证步骤

### 验证算法是否正确

1. **启动应用并在真机上测试**
   ```bash
   # 启动应用
   ./install_to_device.sh
   ```

2. **开始监控日志**
   ```bash
   # 在另一个终端窗口运行
   /Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep '评估猜测'
   ```

3. **在设备上玩游戏**
   - 进入练习模式
   - 提交一个猜测（例如：红、黄、绿、蓝）
   - 观察提示圆点

4. **查看日志输出**
   ```
   === 评估猜测 ===
   密码: red, yellow, green, blue
   猜测: red, blue, yellow, green
   命中: 1
   剩余猜测: blue, yellow, green
   剩余密码: yellow, green, blue
     匹配颜色 blue 在位置 2, 伪命中累计: 1
     匹配颜色 yellow 在位置 0, 伪命中累计: 2
     匹配颜色 green 在位置 1, 伪命中累计: 3
   伪命中: 3
   ================
   ```

5. **对比结果**
   - 日志显示: 1 hit, 3 pseudoHits
   - 屏幕显示: 1个绿色圆点，3个黄色圆点
   - ✅ 如果一致，说明算法正确！

---

## 常见问题

### Q: 应用安装失败

**A:** 检查以下几点：
1. 设备是否开启 USB 调试
2. 设备是否已授权 USB 调试
3. 设备存储空间是否充足
4. USB 连接是否稳定

### Q: 找不到应用图标

**A:**
1. 检查应用是否已安装：`hdc shell bm list -b com.ryan.mi`
2. 尝试通过命令启动：`./install_to_device.sh` 中显示的启动命令
3. 查看日志确认应用是否正常运行

### Q: 日志没有输出

**A:**
1. 清除日志缓存：`hdc shell hilog -r`
2. 确保在应用启动后才开始查看日志
3. 使用 DevEco Studio 的 Hilog 窗口查看更方便

### Q: 如何确认算法是否正确

**A:**
1. 查看 Hilog 日志中的算法输出
2. 对比日志中的 hits/pseudoHits 与屏幕上的提示圆点
3. 如果一致，说明算法正确
4. 如果不一致，提供日志和截图供分析

---

## 性能测试

### 测试启动速度

```bash
# 记录开始时间
time /Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa start \
  -a EntryAbility -b com.ryan.mi
```

### 监控应用性能

```bash
# 查看应用进程
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell ps -ef | grep 'com.ryan.mi'

# 查看内存使用
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell shell dump -a com.ryan.mi
```

---

## 总结

### 最常用的操作

```bash
# 1. 安装/更新应用
./install_to_device.sh

# 2. 查看算法日志
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep '评估猜测'

# 3. 重启应用
/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa force-stop com.ryan.mi && \
  /Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa start -a EntryAbility -b com.ryan.mi
```

### 快捷别名（可选）

在 `~/.bashrc` 或 `~/.zshrc` 中添加：

```bash
alias hdc-install='./install_to_device.sh'
alias hdc-logs='/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell hilog | grep "com.ryan.mi"'
alias hdc-restart='/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa force-stop com.ryan.mi && /Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc shell aa start -a EntryAbility -b com.ryan.mi'
```

然后可以使用：
```bash
hdc-install    # 安装应用
hdc-logs       # 查看日志
hdc-restart    # 重启应用
```
