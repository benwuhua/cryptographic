/**
 * 路由路径常量
 */

export interface RoutesType {
  HOME: string;
  LEVEL_SELECT: string;
  GAME: string;
  RESULT: string;
  DUEL_SETUP: string;
  PRACTICE: string;
  SETTINGS: string;
}

export const Routes: RoutesType = {
  HOME: 'pages/HomePage',
  LEVEL_SELECT: 'pages/LevelSelectPage',
  GAME: 'pages/GamePage',
  RESULT: 'pages/ResultPage',
  DUEL_SETUP: 'pages/DuelSetupPage',
  PRACTICE: 'pages/PracticePage',
  SETTINGS: 'pages/SettingsPage'
};

export type RoutePath =
  | 'pages/HomePage'
  | 'pages/LevelSelectPage'
  | 'pages/GamePage'
  | 'pages/ResultPage'
  | 'pages/DuelSetupPage'
  | 'pages/PracticePage'
  | 'pages/SettingsPage';

