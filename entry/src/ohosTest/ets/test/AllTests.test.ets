/**
 * 测试套件入口文件
 * 组织和管理所有测试用例
 */

import { describe } from '@ohos/hypium';

// 导入简化测试（不依赖源代码）
import minimalTest from './MinimalTest.test';
import basicTest from './BasicTest.test';
import simpleTest from './SimpleTest.test';

// 导入业务测试（依赖源代码，需要时取消注释）
// import GameServiceTest from './GameService.test';
// import UserRepositoryTest from './UserRepository.test';
// import LevelRepositoryTest from './LevelRepository.test';
// import NavigatorTest from './Navigator.test';

export default function allTests() {
  console.log('========== 开始执行密码机游戏测试套件 ==========');

  // 执行简化测试
  console.log('\n📝 执行 MinimalTest...');
  minimalTest();

  console.log('\n📝 执行 BasicTest...');
  basicTest();

  console.log('\n📝 执行 SimpleTest...');
  simpleTest();

  // 执行业务测试（如果简单测试通过，取消下面注释）
  // console.log('\n📊 执行 GameService 核心算法测试...');
  // GameServiceTest();

  // console.log('\n💾 执行 UserRepository 数据持久化测试...');
  // UserRepositoryTest();

  // console.log('\n🎮 执行 LevelRepository 关卡数据测试...');
  // LevelRepositoryTest();

  // console.log('\n🧭 执行 Navigator 导航测试...');
  // NavigatorTest();

  console.log('\n========== 测试套件执行完成 ==========');
}
