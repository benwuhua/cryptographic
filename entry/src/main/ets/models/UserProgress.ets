/**
 * 用户进度模型
 */

// 用户游戏进度
export interface UserProgress {
  easyUnlocked: number;      // 初级已解锁关卡数 (1-100)
  hardUnlocked: number;      // 高级已解锁关卡数 (1-500)
  totalGames: number;        // 总游戏局数
  totalWins: number;         // 总胜利局数
  bestStreak: number;        // 最佳连胜记录
  currentStreak: number;     // 当前连胜数
}

// 默认用户进度
export const DEFAULT_USER_PROGRESS: UserProgress = {
  easyUnlocked: 1,
  hardUnlocked: 0,    // 需要通过初级模式解锁
  totalGames: 0,
  totalWins: 0,
  bestStreak: 0,
  currentStreak: 0
};

// 计算胜率
export function getWinRate(progress: UserProgress): number {
  if (progress.totalGames === 0) return 0;
  return Math.round((progress.totalWins / progress.totalGames) * 100);
}

// 更新胜利后的进度
export function updateProgressOnWin(progress: UserProgress): UserProgress {
  const newStreak = progress.currentStreak + 1;
  const newProgress: UserProgress = {
    easyUnlocked: progress.easyUnlocked,
    hardUnlocked: progress.hardUnlocked,
    totalGames: progress.totalGames + 1,
    totalWins: progress.totalWins + 1,
    bestStreak: Math.max(progress.bestStreak, newStreak),
    currentStreak: newStreak
  };
  return newProgress;
}

// 更新失败后的进度
export function updateProgressOnLose(progress: UserProgress): UserProgress {
  const newProgress: UserProgress = {
    easyUnlocked: progress.easyUnlocked,
    hardUnlocked: progress.hardUnlocked,
    totalGames: progress.totalGames + 1,
    totalWins: progress.totalWins,
    bestStreak: progress.bestStreak,
    currentStreak: 0
  };
  return newProgress;
}
