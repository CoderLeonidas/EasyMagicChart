//
//  EMCommonlyUsedToolKit.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/28.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  通用工具集

#import <Foundation/Foundation.h>
@class NSColor;
@interface EMCommonlyUsedToolKit : NSObject

#pragma mark - Date Related

/**
 根据日期数据，获取年月日，若不需要可传入空，以传出参数带出
 */
+ (void)getYear:(int*)year Month:(int*)month Day:(int*)day WithDate:(int)date;

/**
 将time根据是否存在秒数拆分为时分秒，通过参数带出结果

 @param hour 时，出参
 @param minute 分，出参
 @param second 秒，出参
 @param time 时间整数
 @param hasSecond 时间整数中是否含有秒，含有秒则为"hhMMss"形式，不含秒则为"hhMM"形式
 */
+ (void)getHour:(int*)hour minute:(int*)minute second:(int*)second withTime:(int)time hasSecond:(BOOL)hasSecond;


/**
 判断是否为闰年
 */
+ (BOOL)isLeapYear:(NSUInteger)year;


#pragma mark - NSString Related


+ (NSAttributedString *)colorStringWithString:(NSString *)string color:(NSColor *)color;


/**
 根据给定的精度和价格值返回格式化字符串

 @param decimal 精度
 @param price 价格值
 @return 格式化价格字符串
 */
+ (NSString*)formattedPriceStringWithDecimal:(int)decimal price:(double)price;

#pragma mark - Data Set Related
/**
 根据传入的任意类型参数，生成字典并返回
 */
+ (NSDictionary*)dictionaryWithParam:(id)param;

/**
 根据aPropertyKV中属性的对应关系，将数据源转化为成员为目标数据类型className类型的数据源

 @param dataSource 原始数据源
 @param aPropertyKV 原始数据源数据类型和className类型中的属性映射关系，如@{@"propertyA": @"propertyB"}，其中propertyA 为EMBaseGraphDataItem中的某属性名，propertyB为外部数据结构中与propertyA对应的属性名
 @param className 目标数据类型
 @return 成员为className类型的数组
 */
+ (NSArray *)convertDataSource:(NSArray *)dataSource
                withPropertyKV:(NSDictionary *)aPropertyKV
                 destClassName:(NSString *)className;


/**
 获取数组中给定属性的最大最小值
 
 @param maxValue 最大值的指针，作为传入传出参数
 @param minValue 最小值的指针，作为传入传出参数
 @param datas 数据源数组
 @param objClassName 项目类名
 @param propertyName 属性名称
 */
+ (void)getMaxValue:(CGFloat *)maxValue
           minValue:(CGFloat *)minValue
            inDates:(NSArray *)datas
       withObjClass:(NSString *)objClassName
       propertyName:(NSString *)propertyName;

/**
 获取数组中给定所有属性中的最大最小值
 
 @param maxValue 最大值的指针，作为传入传出参数
 @param minValue 最小值的指针，作为传入传出参数
 @param datas 数据源数组
 @param objClassName 项目类名
 @param propertyNames 属性名称数组，意为比较多个属性
 @param ignoreZero 是否忽略0值(比如价格不会为0)
 */
+ (void)getMaxValue:(CGFloat *)maxValue
           minValue:(CGFloat *)minValue
            inDates:(NSArray *)datas
       withObjClass:(NSString *)objClassName
      propertyNames:(NSArray <NSString *>*)propertyNames
         ignoreZero:(BOOL)ignoreZero;

///< 字典按key排序后获取顺序value数组
+ (NSArray *)orderValueArrayWithDict:(NSDictionary *)dict;

//测试函数运行耗时
#define TIME_START NSDate *startTime = [NSDate date];
#define TIME_END NSLog((@"------Time: %f\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d]\n-----"), [startTime timeIntervalSinceNow], __FILE__, __FUNCTION__, __LINE__);

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf) __strong __typeof(&*self)strongSelf = weakSelf;

#define IS_DOUBLE_ZERO(doubleValue)  (doubleValue >= -DBL_EPSILON && doubleValue <= DBL_EPSILON)

#define DIC_HAS_NO_VALUE_BY_KEY(dic, key) ([NSNull null] == (NSNull *)dic[key] || nil  == dic[key])



/**
 用于简单的性能测试

 @param target target
 @param action 测试的方法，包装成Selector
 @param callingCount 调用次数
 */
+ (void)performanceTestingWithTarget:(id)target
                              action:(SEL)action
                        callingCount:(NSUInteger)callingCount;

/**
 根据数字返回合适的单位(如万、千万、亿等)
 */
+ (NSString *)unitWithNumber:(CGFloat)number;
+ (NSUInteger)divisorWithNumber:(CGFloat)number;


/**
 根据起点日期orignDate，长度length，和前后方向forward，从数据源datas中截取一段数据，其中datas中item的日期属性名为dateKey
 */
+ (NSArray *)trimDatasWithOrignDate:(NSInteger)orignDate dateKey:(NSString*)dateKey length:(NSUInteger)length forward:(BOOL)forward inDatas:(NSArray *)datas;

@end

