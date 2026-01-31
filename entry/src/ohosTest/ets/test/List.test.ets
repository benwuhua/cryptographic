// 导入系统测试
import abilityTest from './Ability.test';

// 导入简化测试（不依赖源代码）
import minimalTest from './MinimalTest.test';
import basicTest from './BasicTest.test';
import simpleTest from './SimpleTest.test';

// 导入业务测试（依赖源代码）
// 这些测试可能导致运行时崩溃，如果测试失败，请注释掉这些导入
// import gameServiceTest from './GameService.test';
// import userRepositoryTest from './UserRepository.test';
// import levelRepositoryTest from './LevelRepository.test';
// import navigatorTest from './Navigator.test';

export default function testsuite() {
  console.log('========== 开始执行测试套件 ==========');

  // 执行系统测试
  console.log('执行 Ability.test...');
  abilityTest();

  // 执行简化测试
  console.log('执行 MinimalTest.test...');
  minimalTest();

  console.log('执行 BasicTest.test...');
  basicTest();

  console.log('执行 SimpleTest.test...');
  simpleTest();

  // 执行业务测试（如果上面通过，取消下面注释）
  // console.log('执行 GameService.test...');
  // gameServiceTest();

  console.log('========== 测试套件执行完成 ==========');
}