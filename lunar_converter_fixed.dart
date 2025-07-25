import 'dart:math';

class LunarConverter {
  // 农历数据表，支持1901-2100年
  // 数据格式：每年用16位表示
  // 第0-11位：表示12个月的大小月(1为大月30天，0为小月29天)
  // 第12-15位：表示闰月月份(0-12，0表示无闰月)
  // 第16位：表示闰月大小(1为大月30天，0为小月29天)
  static final List<int> lunarInfo = [
    0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
    0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
    0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
    0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
    0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
    0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
    0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
    0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
    0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
    0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
    0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
    0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
    0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
    0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
    0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,
    0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0,
    0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,
    0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,
    0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,
    0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252,
    0x0d520
  ];

  // 农历月份名称
  static final List<String> lunarMonths = [
    '', '正月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '冬月', '腊月'
  ];

  // 农历日期名称
  static final List<String> lunarDays = [
    '', '初一', '初二', '初三', '初四', '初五', '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五', '廿六', '廿七', '廿八', '廿九', '三十'
  ];

  // 天干
  static final List<String> heavenlyStems = [
    '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'
  ];

  // 地支
  static final List<String> earthlyBranches = [
    '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'
  ];

  // 生肖
  static final List<String> zodiacAnimals = [
    '鼠', '牛', '虎', '兔', '龙', '蛇', '马', '羊', '猴', '鸡', '狗', '猪'
  ];

  // 计算农历日期（修正版本）
  static Map<String, dynamic> solarToLunar(int year, int month, int day) {
    if (year < 1901 || year > 2100) {
      throw Exception('年份超出支持范围(1901-2100)');
    }
  
    // 基准日期：1900年1月31日为农历1900年正月初一
    // 但数据从1901年开始，所以使用1901年1月1日作为基准
    DateTime baseDate = DateTime(1900, 1, 31);
    DateTime targetDate = DateTime(year, month, day);
    
    // 计算相差天数
    int offset = targetDate.difference(baseDate).inDays;
    
    int temp = 0;
    int i;
    
    // 从1900年开始计算到目标年份
    for (i = 1900; i < 2101 && temp <= offset; i++) {
      temp += getDaysInYear(i);
    }
    
    // 找到农历年份
    int lunarYear = i - 1;
    offset -= (temp - getDaysInYear(lunarYear));
    
    // 计算农历月份和日期
    int lunarMonth = 1;
    int lunarDay;
    bool isLeapMonth = false;
    
    int leapMonth = getLeapMonth(lunarYear);
    
    // 遍历月份
    for (lunarMonth = 1; lunarMonth <= 12; lunarMonth++) {
      int daysInMonth = getDaysInMonth(lunarYear, lunarMonth, false);
      
      if (offset < daysInMonth) {
        break;
      }
      offset -= daysInMonth;
      
      // 如果有闰月且当前月份是闰月
      if (leapMonth > 0 && lunarMonth == leapMonth) {
        int daysInLeapMonth = getDaysInMonth(lunarYear, lunarMonth, true);
        if (offset < daysInLeapMonth) {
          isLeapMonth = true;
          break;
        }
        offset -= daysInLeapMonth;
      }
    }
    
    lunarDay = offset + 1;
    
    // 计算天干地支年份
    int stemIndex = (lunarYear - 4) % 10;
    if (stemIndex < 0) stemIndex += 10;
    
    int branchIndex = (lunarYear - 4) % 12;
    if (branchIndex < 0) branchIndex += 12;
    
    String ganZhiYear = '${heavenlyStems[stemIndex]}${earthlyBranches[branchIndex]}';
    String zodiac = zodiacAnimals[branchIndex];
    
    return {
      'lunarYear': lunarYear,
      'lunarMonth': lunarMonth,
      'lunarDay': lunarDay,
      'isLeapMonth': isLeapMonth,
      'ganZhiYear': ganZhiYear,
      'zodiac': zodiac,
      'monthName': isLeapMonth ? '闰${lunarMonths[lunarMonth]}' : lunarMonths[lunarMonth],
      'dayName': lunarDays[lunarDay]
    };
  }

  // 获取农历年份的天数
  static int getDaysInYear(int year) {
    if (year < 1900 || year > 2100) return 0;
    
    int sum = 348; // 12个月，每月29天的基础
    int info = lunarInfo[year - 1900];
    
    // 加上大月的额外一天
    for (int i = 0; i < 12; i++) {
      sum += (info >> i) & 1;
    }
    
    // 如果有闰月，加上闰月天数
    int leap = getLeapMonth(year);
    if (leap > 0) {
      sum += getDaysInMonth(year, leap, true);
    }
    
    return sum;
  }

  // 获取农历月份的天数
  static int getDaysInMonth(int year, int month, bool isLeap) {
    if (year < 1900 || year > 2100) return 0;
    
    int info = lunarInfo[year - 1900];
    
    if (isLeap) {
      // 闰月天数：检查第16位
      return ((info >> 16) & 1) == 1 ? 30 : 29;
    } else {
      // 普通月份天数：检查对应位
      return ((info >> (month - 1)) & 1) == 1 ? 30 : 29;
    }
  }

  // 获取农历年份的闰月月份
  static int getLeapMonth(int year) {
    if (year < 1900 || year > 2100) return 0;
    return (lunarInfo[year - 1900] >> 12) & 0xf;
  }
  
  // 添加验证方法
  static bool isValidDate(int year, int month, int day) {
    if (year < 1901 || year > 2100) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    
    // 检查具体月份的天数
    List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    // 检查闰年
    if (month == 2 && isLeapYear(year)) {
      return day <= 29;
    }
    
    return day <= daysInMonth[month - 1];
  }
  
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

// 测试和验证代码
void main() {
  print('=== 农历转换器测试 ===\n');
  
  // 测试一些已知的日期
  List<Map<String, int>> testDates = [
    {'year': 1901, 'month': 2, 'day': 19}, // 应该是农历1901年正月初一
    {'year': 2024, 'month': 2, 'day': 10}, // 2024年春节
    {'year': 2024, 'month': 1, 'day': 1},  // 2024年1月1日
    {'year': 2000, 'month': 1, 'day': 1},  // 千禧年
  ];
  
  for (var testDate in testDates) {
    try {
      var result = LunarConverter.solarToLunar(
        testDate['year']!,
        testDate['month']!,
        testDate['day']!
      );
      
      print('公历：${testDate['year']}年${testDate['month']}月${testDate['day']}日');
      print('农历：${result['lunarYear']}年${result['monthName']}${result['dayName']}');
      print('干支：${result['ganZhiYear']}年 生肖：${result['zodiac']}');
      print('是否闰月：${result['isLeapMonth']}');
      print('---');
    } catch (e) {
      print('转换${testDate['year']}年${testDate['month']}月${testDate['day']}日时出错：$e');
      print('---');
    }
  }
  
  // 测试数据验证
  print('\n=== 数据验证测试 ===');
  for (int year = 1901; year <= 1910; year++) {
    int leapMonth = LunarConverter.getLeapMonth(year);
    int daysInYear = LunarConverter.getDaysInYear(year);
    print('$year年：闰月=$leapMonth, 总天数=$daysInYear');
  }
}