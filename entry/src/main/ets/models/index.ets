/**
 * 模型统一导出
 */

export { Color, ALL_COLORS, ColorValues, ColorNames, HintColors } from '../constants/Colors';

export { Level, Difficulty, HintMode, createLevel } from './Level';

export { Attempt, EvaluationResult, createAttempt } from './Attempt';

export {
  GameState,
  GameStatus,
  GameMode,
  createInitialGameState,
  isGuessComplete,
  getRemainingAttempts
} from './GameState';

export {
  UserProgress,
  DEFAULT_USER_PROGRESS,
  getWinRate,
  updateProgressOnWin,
  updateProgressOnLose
} from './UserProgress';

export {
  AppSettings,
  ThemeMode,
  DEFAULT_SETTINGS
} from './AppSettings';

export {
  LevelSelectParams,
  GamePageParams,
  ResultPageParams,
  createSoloGameParams,
  createDuelGameParams,
  createPracticeGameParams
} from './RouteParams';
