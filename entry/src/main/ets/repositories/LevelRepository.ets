/**
 * 关卡数据仓库
 * 负责存储和提供关卡密码数据
 */

import { Level, createLevel } from '../models/Level';
import { LevelService } from '../services/LevelService';
import { GameService } from '../services/GameService';
import { GameConfig } from '../constants/GameConfig';

export class LevelRepository {
  // 缓存已加载的关卡
  private static levelCache = new Map<number, Level>();

  /**
   * 获取关卡配置
   * @param levelId 关卡ID
   * @returns 关卡配置
   */
  static getLevel(levelId: number): Level {
    // 检查缓存
    if (LevelRepository.levelCache.has(levelId)) {
      return LevelRepository.levelCache.get(levelId)!;
    }

    const difficulty = LevelService.getDifficultyByLevelId(levelId);
    const colorCount = LevelService.getColorCount(levelId, difficulty);
    const password = LevelRepository.getPassword(levelId);

    const level = createLevel(levelId, difficulty, password, colorCount);
    LevelRepository.levelCache.set(levelId, level);

    return level;
  }

  /**
   * 获取关卡密码
   * @param levelId 关卡ID
   * @returns 密码数组
   */
  private static getPassword(levelId: number): import('../constants/Colors').Color[] {
    // 初级关卡 (1-50) - 预设密码，保证可解性和合理难度
    const easyPasswords: Record<number, string> = {
      1: 'RRRR',
      2: 'YYYY',
      3: 'GGGG',
      4: 'BBBB',
      5: 'RYGB',
      6: 'YGBR',
      7: 'GBRY',
      8: 'BRYG',
      9: 'RRYY',
      10: 'YYGG',
      11: 'GGBB',
      12: 'BBRR',
      13: 'RGRG',
      14: 'YBYB',
      15: 'GBGB',
      16: 'BRBR',
      17: 'RRGY',
      18: 'YYGB',
      19: 'GGBR',
      20: 'BBRG',
      21: 'RGBY',
      22: 'YRGB',
      23: 'GBYR',
      24: 'BRYG',
      25: 'RYGY',
      26: 'YGBG',
      27: 'GBRB',
      28: 'BRGR',
      29: 'RRGG',
      30: 'YYBB',
      31: 'GGRR',
      32: 'BBYY',
      33: 'RGYB',
      34: 'YRBG',
      35: 'GBRY',
      36: 'BYRG',
      37: 'RYBR',
      38: 'YGBR',
      39: 'GBRG',
      40: 'BRGY',
      41: 'RGBR',
      42: 'YGBY',
      43: 'GBGB',
      44: 'BRYR',
      45: 'RRGY',
      46: 'YYBR',
      47: 'GGRY',
      48: 'BBGY',
      49: 'RGBY',
      50: 'YGBR'
    };

    // 高级关卡 (101-150) - 5色难度
    const hardPasswords5Colors: Record<number, string> = {
      101: 'RYGBP',
      102: 'YGBPR',
      103: 'GBPRY',
      104: 'BPRYG',
      105: 'PRYGB',
      106: 'RRYBP',
      107: 'YYGBP',
      108: 'GGBPR',
      109: 'BBPRY',
      110: 'PPRYG',
      111: 'RYGPP',
      112: 'YGBRR',
      113: 'GBPRY',
      114: 'BPRYG',
      115: 'PRYGB',
      116: 'RGBPY',
      117: 'YBRPG',
      118: 'GBPRY',
      119: 'BPRGY',
      120: 'PRGYB',
      121: 'RPYBG',
      122: 'PYBGR',
      123: 'YBGRP',
      124: 'BGRPY',
      125: 'GRPYB',
      126: 'RYGBP',
      127: 'YGBPR',
      128: 'GBPRY',
      129: 'BPRYG',
      130: 'PRYGB',
      131: 'RRGYP',
      132: 'YYGBP',
      133: 'GGBPR',
      134: 'BBPRY',
      135: 'PPRYG',
      136: 'RGBPY',
      137: 'YBRPG',
      138: 'GBPRY',
      139: 'BPRGY',
      140: 'PRGYB',
      141: 'RPYBG',
      142: 'PYBGR',
      143: 'YBGRP',
      144: 'BGRPY',
      145: 'GRPYB',
      146: 'RYGBP',
      147: 'YGBPR',
      148: 'GBPRY',
      149: 'BPRYG',
      150: 'PRYGB'
    };

    // 高级关卡 (301-350) - 6色难度
    const hardPasswords6Colors: Record<number, string> = {
      301: 'RYGBPO',
      302: 'YGBPOR',
      303: 'GBPORY',
      304: 'BPORYG',
      305: 'PORYGB',
      306: 'ORYGBP',
      307: 'RRGBPO',
      308: 'YYGBPO',
      309: 'GGBPOR',
      310: 'BBPORY',
      311: 'PPORYG',
      312: 'OORYGB',
      313: 'RGBPOY',
      314: 'YGBPOR',
      315: 'GBPORY',
      316: 'BPORYG',
      317: 'PORYGB',
      318: 'ORYGBP',
      319: 'RGBYPO',
      320: 'YBPGOR',
      321: 'GBORYP',
      322: 'BORYPG',
      323: 'ORYPGB',
      324: 'RYPGBO',
      325: 'YPGBOR',
      326: 'PGBORY',
      327: 'GBORYP',
      328: 'BORYPG',
      329: 'ORYPGB',
      330: 'RYPGBO',
      331: 'RRGYBO',
      332: 'YYGBPO',
      333: 'GGBP OR',
      334: 'BBPORY',
      335: 'PPORYG',
      336: 'OORYGB',
      337: 'RGBPOY',
      338: 'YGBP OR',
      339: 'GBPORY',
      340: 'BPORYG',
      341: 'PORYGB',
      342: 'ORYGBP',
      343: 'RGBYPO',
      344: 'YBPGOR',
      345: 'GBORYP',
      346: 'BORYPG',
      347: 'ORYPGB',
      348: 'RYPGBO',
      349: 'YPGBOR',
      350: 'PGBORY'
    };

    let passwordString: string;

    // 根据关卡ID选择密码
    if (levelId <= 50) {
      passwordString = easyPasswords[levelId] || 'RRRR';
    } else if (levelId <= 100) {
      // 初级关卡 51-100 - 动态生成
      return LevelRepository.generateEasyPassword(levelId);
    } else if (levelId <= 150) {
      passwordString = hardPasswords5Colors[levelId] || 'RYGBP';
    } else if (levelId <= 300) {
      // 高级关卡 151-300 - 动态生成5色密码
      return LevelRepository.generateHardPassword(levelId, 5);
    } else if (levelId <= 350) {
      passwordString = hardPasswords6Colors[levelId] || 'RYGBPO';
    } else if (levelId <= 600) {
      // 高级关卡 351-600 - 动态生成6色密码
      return LevelRepository.generateHardPassword(levelId, 6);
    } else {
      throw new Error(`Invalid level ID: ${levelId}`);
    }

    // 将字符串转换为颜色数组
    return LevelRepository.parsePasswordString(passwordString);
  }

  /**
   * 解析密码字符串
   * @param str 密码字符串 (如 "RYGB")
   * @returns 颜色数组
   */
  private static parsePasswordString(str: string): import('../constants/Colors').Color[] {
    const colorMap: Record<string, import('../constants/Colors').Color> = {
      'R': 'red',
      'Y': 'yellow',
      'G': 'green',
      'B': 'blue',
      'P': 'purple',
      'O': 'orange'
    };

    return str.split('').map(char => {
      const color = colorMap[char];
      if (!color) {
        throw new Error(`Invalid password character: ${char}`);
      }
      return color;
    });
  }

  /**
   * 生成初级关卡密码 (4色)
   * @param levelId 关卡ID
   * @returns 随机密码
   */
  private static generateEasyPassword(levelId: number): import('../constants/Colors').Color[] {
    // 使用关卡ID作为种子生成可复现的随机密码
    const seed = levelId * 65539; // 质数乘数
    const password = LevelRepository.seededRandom(seed, 4);
    return password;
  }

  /**
   * 生成高级关卡密码 (5或6色)
   * @param levelId 关卡ID
   * @param colorCount 颜色数量
   * @returns 随机密码
   */
  private static generateHardPassword(
    levelId: number,
    colorCount: number
  ): import('../constants/Colors').Color[] {
    const seed = levelId * 65539;
    return LevelRepository.seededRandom(seed, colorCount);
  }

  /**
   * 使用种子生成随机密码
   * @param seed 随机种子
   * @param colorCount 颜色数量
   * @returns 密码数组
   */
  private static seededRandom(seed: number, colorCount: number): import('../constants/Colors').Color[] {
    const allColors: import('../constants/Colors').Color[] = [
      'red' as import('../constants/Colors').Color,
      'yellow' as import('../constants/Colors').Color,
      'green' as import('../constants/Colors').Color,
      'blue' as import('../constants/Colors').Color,
      'purple' as import('../constants/Colors').Color,
      'orange' as import('../constants/Colors').Color
    ];
    const colors = allColors.slice(0, colorCount);

    const password: import('../constants/Colors').Color[] = [];
    let currentSeed = seed;

    for (let i = 0; i < GameConfig.PASSWORD_LENGTH; i++) {
      currentSeed = (currentSeed * 1103515245 + 12345) & 0x7fffffff;
      const index = currentSeed % colors.length;
      password.push(colors[index]);
    }

    return password;
  }

  /**
   * 批量获取关卡
   * @param startLevelId 起始关卡ID
   * @param count 数量
   * @returns 关卡数组
   */
  static getLevels(startLevelId: number, count: number): Level[] {
    const levels: Level[] = [];
    for (let i = 0; i < count; i++) {
      levels.push(LevelRepository.getLevel(startLevelId + i));
    }
    return levels;
  }

  /**
   * 清除缓存
   */
  static clearCache(): void {
    LevelRepository.levelCache.clear();
  }
}
