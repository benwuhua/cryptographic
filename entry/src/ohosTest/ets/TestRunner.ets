/**
 * 测试套件主入口文件
 * 导入并执行所有测试模块
 */

import GameServiceTest from './GameService.test';
import UserRepositoryTest from './UserRepository.test';
import LevelRepositoryTest from './LevelRepository.test';
import NavigatorTest from './Navigator.test';

export default function TestSuite() {
  // 执行所有测试套件
  GameServiceTest();
  UserRepositoryTest();
  LevelRepositoryTest();
  NavigatorTest();
}
