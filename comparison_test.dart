// 关键问题对比测试

void main() {
  print('=== 农历转换器关键问题对比 ===\n');
  
  // 问题1：数据格式理解错误
  print('1. 数据格式理解问题：');
  print('原始代码错误：');
  print('  - 注释："第13位表示闰月月份"');
  print('  - 注释："第14位表示闰月大小"');
  print('  - 代码：((info >> 13) & 1) == 1 ? 30 : 29');
  
  print('修正版本：');
  print('  - 正确："第12-15位表示闰月月份"');
  print('  - 正确："第16位表示闰月大小"');
  print('  - 代码：((info >> 16) & 1) == 1 ? 30 : 29');
  print('');
  
  // 问题2：基准日期
  print('2. 基准日期问题：');
  print('原始代码：DateTime(1901, 2, 19) // 可能不准确');
  print('修正版本：DateTime(1900, 1, 31) // 更准确的基准');
  print('');
  
  // 问题3：循环逻辑
  print('3. 月份计算逻辑问题：');
  print('原始代码问题：');
  print('  - while (daysIntoYear >= 0) // 可能无限循环');
  print('  - lunarMonth = -lunarMonth // 用负数表示闰月，混淆');
  
  print('修正版本：');
  print('  - for (lunarMonth = 1; lunarMonth <= 12; lunarMonth++) // 明确的循环边界');
  print('  - bool isLeapMonth = false // 清晰的布尔变量');
  print('');
  
  // 问题4：边界检查
  print('4. 边界检查问题：');
  print('原始代码：直接访问 lunarInfo[year - 1900] // 可能越界');
  print('修正版本：添加 if (year < 1900 || year > 2100) return 0 // 安全检查');
  print('');
  
  // 示例数据分析
  print('5. 数据格式分析示例：');
  int exampleData = 0x04bd8; // 1901年的数据
  print('数据：0x04bd8 (${exampleData.toRadixString(2).padLeft(17, '0')})');
  print('');
  
  print('位解析：');
  for (int i = 0; i < 12; i++) {
    int dayCount = ((exampleData >> i) & 1) == 1 ? 30 : 29;
    print('  第${i+1}月：${dayCount}天 (第${i}位=${(exampleData >> i) & 1})');
  }
  
  int leapMonth = (exampleData >> 12) & 0xf;
  int leapDays = ((exampleData >> 16) & 1) == 1 ? 30 : 29;
  print('  闰月：${leapMonth == 0 ? '无' : '第${leapMonth}月'} (第12-15位=${leapMonth})');
  if (leapMonth > 0) {
    print('  闰月天数：${leapDays}天 (第16位=${(exampleData >> 16) & 1})');
  }
  
  print('\n=== 关键修正总结 ===');
  print('1. 修正了位运算的位置（第16位而不是第13位）');
  print('2. 改进了循环逻辑，避免无限循环');
  print('3. 使用布尔变量代替负数表示闰月');
  print('4. 添加了边界检查和输入验证');
  print('5. 移除了生产环境不需要的调试输出');
}