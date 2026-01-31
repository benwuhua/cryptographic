# 计客超级密码机 HarmonyOS APP 架构设计

> 文档版本: 1.0
> 创建日期: 2026-01-27
> 状态: 已确认

---

## 1. 架构概览

### 1.1 架构模式：分层架构

```
┌─────────────────────────────────────────────────────────────┐
│                        展示层 (Presentation)                 │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │ HomePage│ │LevelPage│ │ GamePage│ │Settings │  Pages    │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘           │
│       │           │           │           │                 │
│  ┌────┴───────────┴───────────┴───────────┴────┐           │
│  │  ColorPicker │ GuessRow │ HintDisplay │ ... │ Components│
│  └─────────────────────────────────────────────┘           │
├─────────────────────────────────────────────────────────────┤
│                        业务层 (Business)                     │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐              │
│  │GameService │ │LevelService│ │AudioService│   Services   │
│  │ - 验证猜测  │ │ - 关卡管理  │ │ - 音效播放  │              │
│  │ - 计算星级  │ │ - 进度追踪  │ │ - 静音控制  │              │
│  └────────────┘ └────────────┘ └────────────┘              │
├─────────────────────────────────────────────────────────────┤
│                        数据层 (Data)                         │
│  ┌────────────────┐  ┌────────────────┐                    │
│  │ UserRepository │  │ LevelRepository│   Repositories     │
│  │ - 用户设置      │  │ - 关卡数据      │                    │
│  │ - 游戏进度      │  │ - 预设密码      │                    │
│  └───────┬────────┘  └───────┬────────┘                    │
│          │                   │                              │
│  ┌───────┴───────────────────┴───────┐                     │
│  │          Preferences API          │   Storage           │
│  └───────────────────────────────────┘                     │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 核心设计原则

- **展示层**：只负责 UI 渲染和用户交互
- **业务层**：包含所有游戏逻辑，可独立测试
- **数据层**：封装存储细节，上层不直接操作 Preferences

### 1.3 架构决策总结

| 决策项 | 选择 | 理由 |
|-------|------|-----|
| 整体架构 | 分层架构 | 职责清晰，业务逻辑可独立测试 |
| 状态管理 | AppStorage + LocalStorage | 官方方案，支持持久化，响应式 |
| 目录结构 | 按层级组织 | 简洁直观，适合项目规模 |
| 页面导航 | Router | 支持页面栈，参数传递规范 |
| 数据持久化 | Preferences | 轻量够用，API 简单 |
| 音效管理 | 统一 AudioService | 集中控制，支持全局静音 |

---

## 2. 目录结构

```
entry/src/main/ets/
├── entryability/
│   └── EntryAbility.ets          # 应用入口，初始化全局状态
│
├── pages/                         # 页面层
│   ├── HomePage.ets              # 主页（模式选择）
│   ├── LevelSelectPage.ets       # 关卡选择页
│   ├── GamePage.ets              # 游戏主页面
│   ├── ResultPage.ets            # 结果页（成功/失败）
│   ├── DuelSetupPage.ets         # 双人对战设置页
│   ├── PracticePage.ets          # 自由练习页
│   └── SettingsPage.ets          # 设置页
│
├── components/                    # 可复用组件
│   ├── ColorSlot.ets             # 单个颜色槽位
│   ├── ColorPicker.ets           # 颜色选择器
│   ├── GuessRow.ets              # 猜测行（4槽位+提示）
│   ├── HintIndicator.ets         # 提示指示器（黑/白点）
│   ├── LevelCard.ets             # 关卡卡片
│   ├── StarRating.ets            # 星级显示
│   └── AntennaAnimation.ets      # 天线动画组件
│
├── services/                      # 业务逻辑层
│   ├── GameService.ets           # 游戏核心逻辑
│   ├── LevelService.ets          # 关卡管理
│   ├── AudioService.ets          # 音效服务
│   └── HintService.ets           # 提示系统
│
├── repositories/                  # 数据存取层
│   ├── UserRepository.ets        # 用户数据存取
│   └── LevelRepository.ets       # 关卡数据存取
│
├── models/                        # 数据模型
│   ├── Color.ets                 # 颜色类型定义
│   ├── Level.ets                 # 关卡模型
│   ├── Attempt.ets               # 猜测记录模型
│   ├── GameState.ets             # 游戏状态模型
│   ├── UserProgress.ets          # 用户进度模型
│   ├── AppSettings.ets           # 应用设置模型
│   └── RouteParams.ets           # 路由参数模型
│
├── constants/                     # 常量定义
│   ├── Colors.ets                # 颜色常量
│   ├── Routes.ets                # 路由路径
│   └── StorageKeys.ets           # 存储键名
│
└── utils/                         # 工具函数
    ├── Navigator.ets             # 导航封装
    ├── PasswordValidator.ets     # 密码验证算法
    └── StarCalculator.ets        # 星级计算
```

**命名约定：**
- 页面：`XxxPage.ets`
- 组件：`PascalCase.ets`
- 服务：`XxxService.ets`
- 仓库：`XxxRepository.ets`

---

## 3. 状态管理设计

### 3.1 状态分层

```
┌─────────────────────────────────────────────────────────────┐
│                    AppStorage (应用级全局状态)                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PersistentStorage 自动持久化                        │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • userProgress: UserProgress   // 用户进度         │   │
│  │  • settings: AppSettings        // 应用设置         │   │
│  │  • easyLevelStars: number[]     // 初级关卡星级     │   │
│  │  • hardLevelStars: number[]     // 高级关卡星级     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│               LocalStorage (页面级游戏状态)                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  GamePage 及其子组件共享                              │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  • currentLevel: Level          // 当前关卡         │   │
│  │  • secretPassword: Color[]      // 密码(隐藏)       │   │
│  │  • attempts: Attempt[]          // 猜测历史         │   │
│  │  • currentGuess: Color[]        // 当前输入         │   │
│  │  • gameStatus: 'playing'|'won'|'lost'              │   │
│  │  • hintsUsed: number            // 已用提示数       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 使用方式

```typescript
// EntryAbility.ets - 初始化持久化
PersistentStorage.persistProp('userProgress', defaultUserProgress);
PersistentStorage.persistProp('settings', defaultSettings);

// SettingsPage.ets - 读写全局设置
@StorageLink('settings') settings: AppSettings = defaultSettings;

// GamePage.ets - 创建游戏局部状态
@Entry
@Component
struct GamePage {
  private gameStorage: LocalStorage = new LocalStorage();

  aboutToAppear() {
    this.gameStorage.setOrCreate('attempts', []);
    this.gameStorage.setOrCreate('gameStatus', 'playing');
  }
}

// GuessRow.ets - 子组件访问局部状态
@Component
struct GuessRow {
  @LocalStorageProp('currentGuess') currentGuess: Color[] = [];
}
```

### 3.3 状态流转

1. 应用启动 → 从 Preferences 恢复到 AppStorage
2. 进入游戏 → 创建 LocalStorage 管理游戏状态
3. 游戏结束 → 结果写入 AppStorage → 自动持久化

---

## 4. 核心服务设计

### 4.1 GameService - 游戏核心逻辑

```typescript
// services/GameService.ets
export class GameService {
  private static instance: GameService;

  static getInstance(): GameService {
    if (!GameService.instance) {
      GameService.instance = new GameService();
    }
    return GameService.instance;
  }

  // 验证猜测，返回命中结果
  evaluateGuess(password: Color[], guess: Color[]): EvaluationResult {
    // 返回 { hits: number, pseudoHits: number }
  }

  // 检查游戏是否结束
  checkGameEnd(hits: number, attemptCount: number, maxAttempts: number): GameStatus {
    // 返回 'playing' | 'won' | 'lost'
  }

  // 计算星级评定
  calculateStars(attemptCount: number, maxAttempts: number, hintsUsed: number): number {
    // 返回 1 | 2 | 3
  }

  // 生成随机密码（自由模式/双人模式）
  generatePassword(colorCount: number): Color[] {
    // 返回随机4位颜色数组
  }
}
```

### 4.2 LevelService - 关卡管理

```typescript
// services/LevelService.ets
export class LevelService {
  private levelRepo: LevelRepository;
  private userRepo: UserRepository;

  // 获取关卡配置
  getLevel(difficulty: Difficulty, levelId: number): Level { }

  // 解锁下一关
  unlockNextLevel(difficulty: Difficulty, currentLevel: number): void { }

  // 更新关卡星级（取最高）
  updateLevelStars(difficulty: Difficulty, levelId: number, stars: number): void { }

  // 获取已解锁的最高关卡
  getUnlockedLevel(difficulty: Difficulty): number { }

  // 获取某难度总星数
  getTotalStars(difficulty: Difficulty): number { }
}
```

### 4.3 AudioService - 音效管理

```typescript
// services/AudioService.ets
export class AudioService {
  private static instance: AudioService;
  private players: Map<SoundType, media.AVPlayer> = new Map();
  private isMuted: boolean = false;

  // 预加载所有音效
  async preloadAll(): Promise<void> { }

  // 播放指定音效
  play(sound: SoundType): void {
    if (this.isMuted) return;
    // 播放对应音效
  }

  // 静音切换
  setMuted(muted: boolean): void { }
}

// 音效类型
type SoundType = 'click' | 'submit' | 'hit' | 'win' | 'lose' | 'hint' | 'morse';
```

### 4.4 HintService - 提示系统

```typescript
// services/HintService.ets
export class HintService {
  // 具象提示：直接揭示某位置状态
  getConcreteHint(password: Color[], attempts: Attempt[]): ConcreteHint {
    // 返回 { position: number, status: 'correct' | 'wrong_position' | 'wrong' }
  }

  // 抽象提示：逻辑推理引导
  getAbstractHint(password: Color[], attempts: Attempt[]): string {
    // 返回如 "第1位和第3位的颜色需要交换"
  }
}
```

---

## 5. 数据模型

### 5.1 核心模型定义

```typescript
// models/Color.ets
export type Color = 'red' | 'yellow' | 'green' | 'blue' | 'purple' | 'orange';

export const ColorValues: Record<Color, string> = {
  red: '#E53935',
  yellow: '#FDD835',
  green: '#43A047',
  blue: '#1E88E5',
  purple: '#8E24AA',
  orange: '#FB8C00'
};

// models/Level.ets
export interface Level {
  id: number;
  difficulty: 'easy' | 'hard';
  password: Color[];
  colorCount: number;           // 4-6
  hintMode: 'mapped' | 'unmapped';
  maxAttempts: number;          // 默认7
}

// models/Attempt.ets
export interface Attempt {
  guess: Color[];
  hits: number;
  pseudoHits: number;
  timestamp: number;
}

// models/GameState.ets
export interface GameState {
  level: Level;
  attempts: Attempt[];
  currentGuess: (Color | null)[];  // 当前输入，null表示空槽
  status: 'playing' | 'won' | 'lost';
  hintsUsed: number;
  startTime: number;
}

// models/UserProgress.ets
export interface UserProgress {
  easyUnlocked: number;         // 初级已解锁关卡 (1-100)
  hardUnlocked: number;         // 高级已解锁关卡 (1-500)
  totalGames: number;
  totalWins: number;
  bestStreak: number;
  currentStreak: number;
}

// models/AppSettings.ets
export interface AppSettings {
  soundEnabled: boolean;
  vibrationEnabled: boolean;
  theme: 'light' | 'dark' | 'system';
  colorBlindMode: boolean;
}
```

### 5.2 路由参数模型

```typescript
// models/RouteParams.ets

// 进入游戏页参数
export interface GamePageParams {
  mode: 'solo' | 'duel' | 'practice';
  difficulty?: 'easy' | 'hard';      // solo模式必填
  levelId?: number;                   // solo模式必填
  password?: Color[];                 // duel模式：对手设置的密码
  timeLimit?: number;                 // duel模式：时间限制(秒)
  colorCount?: number;                // practice模式：颜色数量
}

// 进入结果页参数
export interface ResultPageParams {
  mode: 'solo' | 'duel' | 'practice';
  result: 'won' | 'lost';
  attempts: number;
  maxAttempts: number;
  timeSpent: number;
  stars?: number;                     // solo模式
  levelId?: number;                   // solo模式
  difficulty?: 'easy' | 'hard';       // solo模式
}
```

---

## 6. 数据存储层

### 6.1 UserRepository

```typescript
// repositories/UserRepository.ets
import preferences from '@ohos.data.preferences';

export class UserRepository {
  private static STORE_NAME = 'UserStore';
  private prefs: preferences.Preferences | null = null;

  async init(context: Context): Promise<void> {
    this.prefs = await preferences.getPreferences(context, UserRepository.STORE_NAME);
  }

  // 用户进度
  async getProgress(): Promise<UserProgress> {
    const json = await this.prefs?.get('progress', '{}');
    return JSON.parse(json as string) || defaultProgress;
  }

  async saveProgress(progress: UserProgress): Promise<void> {
    await this.prefs?.put('progress', JSON.stringify(progress));
    await this.prefs?.flush();
  }

  // 关卡星级 (数组存储，索引=关卡ID-1)
  async getLevelStars(difficulty: 'easy' | 'hard'): Promise<number[]> {
    const key = `${difficulty}Stars`;
    const json = await this.prefs?.get(key, '[]');
    return JSON.parse(json as string);
  }

  async saveLevelStars(difficulty: 'easy' | 'hard', stars: number[]): Promise<void> {
    const key = `${difficulty}Stars`;
    await this.prefs?.put(key, JSON.stringify(stars));
    await this.prefs?.flush();
  }

  // 应用设置
  async getSettings(): Promise<AppSettings> { }
  async saveSettings(settings: AppSettings): Promise<void> { }
}
```

### 6.2 LevelRepository

```typescript
// repositories/LevelRepository.ets
export class LevelRepository {
  // 预设关卡密码（硬编码或从资源文件加载）
  private easyLevels: Color[][] = [...];   // 100个预设密码
  private hardLevels: Color[][] = [...];   // 500个预设密码

  getPassword(difficulty: 'easy' | 'hard', levelId: number): Color[] {
    const levels = difficulty === 'easy' ? this.easyLevels : this.hardLevels;
    return levels[levelId - 1];
  }

  getLevelConfig(difficulty: 'easy' | 'hard', levelId: number): Level {
    return {
      id: levelId,
      difficulty,
      password: this.getPassword(difficulty, levelId),
      colorCount: difficulty === 'easy' ? 4 : this.getHardColorCount(levelId),
      hintMode: difficulty === 'easy' ? 'mapped' : 'unmapped',
      maxAttempts: 7
    };
  }

  // 高级模式：关卡越高颜色越多
  private getHardColorCount(levelId: number): number {
    if (levelId <= 100) return 4;
    if (levelId <= 300) return 5;
    return 6;
  }
}
```

### 6.3 存储键常量

```typescript
// constants/StorageKeys.ets
export const StorageKeys = {
  USER_PROGRESS: 'userProgress',
  SETTINGS: 'settings',
  EASY_STARS: 'easyStars',
  HARD_STARS: 'hardStars'
} as const;
```

---

## 7. 页面路由设计

### 7.1 路由结构

```
┌─────────────────────────────────────────────────────────┐
│                      路由层级图                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│    ┌──────────┐                                        │
│    │ HomePage │  主入口                                 │
│    └────┬─────┘                                        │
│         │                                              │
│    ┌────┴────┬──────────┬──────────┐                  │
│    ▼         ▼          ▼          ▼                  │
│ ┌──────┐ ┌───────┐ ┌────────┐ ┌────────┐             │
│ │Level │ │ Duel  │ │Practice│ │Settings│             │
│ │Select│ │ Setup │ │  Page  │ │  Page  │             │
│ └──┬───┘ └───┬───┘ └───┬────┘ └────────┘             │
│    │         │         │                              │
│    ▼         ▼         ▼                              │
│ ┌──────────────────────────┐                          │
│ │        GamePage          │  游戏核心页面             │
│ └────────────┬─────────────┘                          │
│              │                                         │
│              ▼                                         │
│ ┌──────────────────────────┐                          │
│ │       ResultPage         │  结果展示                 │
│ └──────────────────────────┘                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 7.2 路由常量

```typescript
// constants/Routes.ets
export const Routes = {
  HOME: 'pages/HomePage',
  LEVEL_SELECT: 'pages/LevelSelectPage',
  GAME: 'pages/GamePage',
  RESULT: 'pages/ResultPage',
  DUEL_SETUP: 'pages/DuelSetupPage',
  PRACTICE: 'pages/PracticePage',
  SETTINGS: 'pages/SettingsPage'
} as const;
```

### 7.3 导航封装

```typescript
// utils/Navigator.ets
import router from '@ohos.router';
import { Routes } from '../constants/Routes';

export class Navigator {

  static toHome() {
    router.replaceUrl({ url: Routes.HOME });
  }

  static toLevelSelect(difficulty: 'easy' | 'hard') {
    router.pushUrl({
      url: Routes.LEVEL_SELECT,
      params: { difficulty }
    });
  }

  static toGame(params: GamePageParams) {
    router.pushUrl({
      url: Routes.GAME,
      params
    });
  }

  static toResult(params: ResultPageParams) {
    router.replaceUrl({  // replace: 不能返回游戏页
      url: Routes.RESULT,
      params
    });
  }

  static back() {
    router.back();
  }

  static backToHome() {
    router.clear();      // 清空路由栈
    router.replaceUrl({ url: Routes.HOME });
  }
}
```

### 7.4 main_pages.json 配置

```json
{
  "src": [
    "pages/HomePage",
    "pages/LevelSelectPage",
    "pages/GamePage",
    "pages/ResultPage",
    "pages/DuelSetupPage",
    "pages/PracticePage",
    "pages/SettingsPage"
  ]
}
```

---

## 8. 核心组件设计

### 8.1 组件层级关系

```
GamePage
├── Header (关卡信息、剩余次数)
├── SecretDisplay (密码展示区，隐藏/揭示)
├── AttemptList (猜测历史列表)
│   └── GuessRow × N
│       ├── ColorSlot × 4 (颜色槽)
│       └── HintIndicator (提示点)
├── CurrentGuessRow (当前输入行)
│   └── ColorSlot × 4
├── ColorPicker (颜色选择器)
│   └── ColorButton × 4~6
└── ActionBar (操作按钮)
    ├── HintButton
    ├── SubmitButton
    └── ResetButton
```

### 8.2 组件接口

```typescript
// components/ColorSlot.ets
@Component
export struct ColorSlot {
  @Prop color: Color | null;      // 当前颜色，null为空
  @Prop index: number;            // 槽位索引
  @Prop isSelected: boolean;      // 是否选中状态
  @Prop disabled: boolean;        // 是否禁用（历史记录）
  onSelect?: (index: number) => void;
}

// components/ColorPicker.ets
@Component
export struct ColorPicker {
  @Prop availableColors: Color[];  // 可用颜色列表
  @Prop disabled: boolean;
  onColorSelect?: (color: Color) => void;
}

// components/GuessRow.ets
@Component
export struct GuessRow {
  @Prop attempt: Attempt;
  @Prop rowIndex: number;
  @Prop hintMode: 'mapped' | 'unmapped';
}

// components/HintIndicator.ets
@Component
export struct HintIndicator {
  @Prop hits: number;           // 猜中数（黑点）
  @Prop pseudoHits: number;     // 伪猜中数（白点）
  @Prop mode: 'mapped' | 'unmapped';
}

// components/StarRating.ets
@Component
export struct StarRating {
  @Prop stars: number;          // 0-3
  @Prop maxStars: number = 3;
  @Prop size: number = 24;
}

// components/LevelCard.ets
@Component
export struct LevelCard {
  @Prop levelId: number;
  @Prop stars: number;          // 已获得星数，0=未通关
  @Prop isLocked: boolean;
  @Prop isCurrentLevel: boolean;
  onTap?: () => void;
}
```

### 8.3 组件通信模式

```
┌─────────────────────────────────────────────────┐
│                   GamePage                       │
│  ┌─────────────────────────────────────────┐   │
│  │           LocalStorage                   │   │
│  │  currentGuess | attempts | gameStatus    │   │
│  └──────────────────┬──────────────────────┘   │
│          ▲          │          ▲                │
│          │ @Local   │ @Local   │ @Local        │
│          │ Storage  │ Storage  │ Storage       │
│          │ Link     │ Prop     │ Link          │
│  ┌───────┴───┐ ┌────┴────┐ ┌───┴─────┐        │
│  │CurrentRow │ │AttemptList│ │ColorPicker│       │
│  │(可编辑)   │ │(只读)    │ │(触发更新) │        │
│  └───────────┘ └─────────┘ └──────────┘        │
└─────────────────────────────────────────────────┘
```

---

## 9. 应用初始化与生命周期

### 9.1 启动流程

```
┌─────────────────────────────────────────────────────────────┐
│                     应用启动流程                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐                                           │
│  │ App Launch  │                                           │
│  └──────┬──────┘                                           │
│         ▼                                                   │
│  ┌─────────────────────────────────────┐                   │
│  │ EntryAbility.onCreate()             │                   │
│  │  1. 初始化 Repository               │                   │
│  │  2. 初始化 PersistentStorage        │                   │
│  │  3. 预加载音效资源                   │                   │
│  └──────┬──────────────────────────────┘                   │
│         ▼                                                   │
│  ┌─────────────────────────────────────┐                   │
│  │ onWindowStageCreate()               │                   │
│  │  1. 加载 HomePage                   │                   │
│  │  2. 播放开机音效(摩斯电码)           │                   │
│  └──────┬──────────────────────────────┘                   │
│         ▼                                                   │
│  ┌─────────────────────────────────────┐                   │
│  │ HomePage.aboutToAppear()            │                   │
│  │  1. 读取用户进度                     │                   │
│  │  2. 启动天线动画                     │                   │
│  └─────────────────────────────────────┘                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 9.2 EntryAbility 实现

```typescript
// entryability/EntryAbility.ets
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { UserRepository } from '../repositories/UserRepository';
import { AudioService } from '../services/AudioService';
import { StorageKeys } from '../constants/StorageKeys';

export default class EntryAbility extends UIAbility {
  private userRepo: UserRepository = new UserRepository();
  private audioService: AudioService = AudioService.getInstance();

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 1. 初始化数据仓库
    await this.userRepo.init(this.context);

    // 2. 初始化持久化存储，绑定到 AppStorage
    const progress = await this.userRepo.getProgress();
    const settings = await this.userRepo.getSettings();
    const easyStars = await this.userRepo.getLevelStars('easy');
    const hardStars = await this.userRepo.getLevelStars('hard');

    PersistentStorage.persistProp(StorageKeys.USER_PROGRESS, progress);
    PersistentStorage.persistProp(StorageKeys.SETTINGS, settings);
    PersistentStorage.persistProp(StorageKeys.EASY_STARS, easyStars);
    PersistentStorage.persistProp(StorageKeys.HARD_STARS, hardStars);

    // 3. 预加载音效
    await this.audioService.preloadAll(this.context);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/HomePage', (err) => {
      if (!err) {
        this.audioService.play('morse');
      }
    });
  }

  onForeground() {
    // 从后台恢复
  }

  onBackground() {
    // 进入后台，确保数据已保存
  }
}
```

### 9.3 数据保存时机

| 触发点 | 操作 |
|-------|------|
| 每次猜测提交后 | 无需保存（内存状态） |
| 通关成功 | 保存星级、解锁下一关、更新统计 |
| 通关失败 | 更新统计 |
| 设置变更 | 即时保存（PersistentStorage 自动同步） |
| 应用退出 | onBackground → flush 确保写入 |

---

## 10. 技术栈

```
┌─────────────────────────────────────────────────────────┐
│                      技术栈总览                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  开发语言    ArkTS (TypeScript 扩展)                    │
│  UI 框架     ArkUI 声明式开发                            │
│  目标平台    HarmonyOS 3.0+ (API 9+)                    │
│  SDK 版本    6.0.2                                      │
│                                                         │
│  ─────────────────────────────────────────────────────  │
│                                                         │
│  状态管理    AppStorage / LocalStorage / @State         │
│  持久化      @ohos.data.preferences                     │
│  路由导航    @ohos.router                               │
│  音频播放    @ohos.multimedia.media (AVPlayer)          │
│  测试框架    @ohos/hypium                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 11. MVP 范围

### 11.1 核心文件清单

```
★ = MVP 必需

entry/src/main/ets/
├── entryability/
│   └── EntryAbility.ets        ★
├── pages/
│   ├── HomePage.ets            ★
│   ├── LevelSelectPage.ets     ★
│   ├── GamePage.ets            ★
│   ├── ResultPage.ets          ★
│   ├── DuelSetupPage.ets
│   ├── PracticePage.ets
│   └── SettingsPage.ets
├── components/
│   ├── ColorSlot.ets           ★
│   ├── ColorPicker.ets         ★
│   ├── GuessRow.ets            ★
│   ├── HintIndicator.ets       ★
│   ├── LevelCard.ets           ★
│   ├── StarRating.ets          ★
│   └── AntennaAnimation.ets
├── services/
│   ├── GameService.ets         ★
│   ├── LevelService.ets        ★
│   ├── AudioService.ets
│   └── HintService.ets
├── repositories/
│   ├── UserRepository.ets      ★
│   └── LevelRepository.ets     ★
├── models/
│   └── *.ets                   ★
├── constants/
│   └── *.ets                   ★
└── utils/
    ├── Navigator.ets           ★
    ├── PasswordValidator.ets   ★
    └── StarCalculator.ets      ★
```

### 11.2 MVP 功能范围

| 功能 | MVP | V1.0 | V1.5 |
|-----|-----|------|------|
| 初级单人模式 (50关) | ✅ | | |
| 初级单人模式 (100关) | | ✅ | |
| 高级单人模式 (500关) | | ✅ | |
| 双人本地对战 | | ✅ | |
| 自由练习模式 | | ✅ | |
| 基础音效 | | ✅ | |
| 设置页面 | | ✅ | |
| 成就系统 | | | ✅ |
| 数据统计 | | | ✅ |

---

## 12. 相关文档

- [需求分析文档](../requirements-analysis.md)
- CLAUDE.md - 项目开发指南

---

*文档完成*
