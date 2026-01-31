/**
 * 存储键名常量
 */

export interface StorageKeysType {
  USER_PROGRESS: string;
  SETTINGS: string;
  EASY_STARS: string;
  HARD_STARS: string;
  CURRENT_LEVEL: string;
  SECRET_PASSWORD: string;
  ATTEMPTS: string;
  CURRENT_GUESS: string;
  GAME_STATUS: string;
  HINTS_USED: string;
  START_TIME: string;
}

export const StorageKeys: StorageKeysType = {
  // 用户数据
  USER_PROGRESS: 'userProgress',
  SETTINGS: 'settings',

  // 关卡星级
  EASY_STARS: 'easyStars',
  HARD_STARS: 'hardStars',

  // 游戏状态 (LocalStorage)
  CURRENT_LEVEL: 'currentLevel',
  SECRET_PASSWORD: 'secretPassword',
  ATTEMPTS: 'attempts',
  CURRENT_GUESS: 'currentGuess',
  GAME_STATUS: 'gameStatus',
  HINTS_USED: 'hintsUsed',
  START_TIME: 'startTime'
};
