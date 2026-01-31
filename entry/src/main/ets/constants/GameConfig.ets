/**
 * 游戏配置常量
 */

export interface GameConfigType {
  PASSWORD_LENGTH: number;
  DEFAULT_MAX_ATTEMPTS: number;
  EASY_LEVEL_COUNT: number;
  HARD_LEVEL_COUNT: number;
  EASY_COLOR_COUNT: number;
  HARD_COLOR_COUNT_MIN: number;
  HARD_COLOR_COUNT_MAX: number;
  HARD_COLOR_5_THRESHOLD: number;
  HARD_COLOR_6_THRESHOLD: number;
  STAR_3_THRESHOLD: number;
  STAR_2_THRESHOLD: number;
}

export const GameConfig: GameConfigType = {
  // 密码长度
  PASSWORD_LENGTH: 4,

  // 默认最大尝试次数
  DEFAULT_MAX_ATTEMPTS: 7,

  // 初级模式关卡数
  EASY_LEVEL_COUNT: 100,

  // 高级模式关卡数
  HARD_LEVEL_COUNT: 500,

  // 初级模式颜色数量
  EASY_COLOR_COUNT: 4,

  // 高级模式颜色数量范围
  HARD_COLOR_COUNT_MIN: 4,
  HARD_COLOR_COUNT_MAX: 6,

  // 高级模式颜色递增阈值
  HARD_COLOR_5_THRESHOLD: 101,  // 101-300关使用5色
  HARD_COLOR_6_THRESHOLD: 301,  // 301-500关使用6色

  // 星级评定阈值
  STAR_3_THRESHOLD: 0.5,   // 使用不超过50%次数得3星
  STAR_2_THRESHOLD: 0.75   // 使用不超过75%次数得2星
};
