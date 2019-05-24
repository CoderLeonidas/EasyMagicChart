//
//  EMControlTool.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/27.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  常用的控件视图相关工具方法

#import <Foundation/Foundation.h>

@class NSView;
@class NSColor;
@class NSTextField;
@class NSButton;
@interface EMControlTool : NSObject

/**
 从xib中加载视图并返回

 @param className xib所属视图类名
 @return 加载所得的视图(需要进行类型转换避免编译警告)
 */
+ (NSView *)getViewFromXibWithClassName:(NSString *)className;

+ (NSView *)getViewFromXibWithViewClass:(Class)viewClass;


+ (id)getControlFromXibWithClassName:(NSString *)className;
/**
 为给定视图设置给定的背景色

 @param aColor 背景色
 @param aView 视图
 */
+ (void)setBGColor:(NSColor *)aColor toView:(NSView*)aView;


/**
 为给定的视图设置给定的背景色(含背景色透明度为alpha)

 @param aColor 背景色
 @param alpha 透明度
 @param aView 视图
 */
+ (void)setBGColor:(NSColor *)aColor alpha:(CGFloat)alpha toView:(NSView*)aView;


/**
 为给定的一组视图设置给定的背景色
 
 @param aColor 背景色
 @param views 视图数组
 */
+ (void)setBGColor:(NSColor *)aColor toViews:(NSArray <NSView*>*)views;

/**
 将某个view下的所有的控件按照给定的属性条件过滤后，用给定的属性键值对设置属性
 
 @param aPropertyKV 属性键值对
 @param aView 视图容器
 @param aControlClass 需要设置的控件类
 @param needRecursion 是否需要递归子视图
 @param aPropertyConditionKV 控件的属性条件
 @param needDisplay 是否需要重绘
 @warning: 1、为了及时暴露问题，内部未做异常处理，需要外部保证传入的keyPath正确，特别注意别有拼写错误和不可见字符
           2、属性条件为identifier的，则判断identifier是否包含某前缀，原则上identifier不能重复
 */
+ (void)setPropertyKV:(NSDictionary *)aPropertyKV
               inView:(NSView*)aView
      forControlClass:(Class)aControlClass
        needRecursion:(BOOL)needRecursion
withPropertyConditionKV:(NSDictionary *)aPropertyConditionKV
          needDisplay:(BOOL)needDisplay;

/**
 获取一个mac的label并返回

 @return mac的label
 */
+ (NSTextField *)macLabel;

/**
 设置按钮的属性标题(颜色，字体)

 */
+ (void)setButton:(NSButton *)button
   withTitleColor:(NSColor *)titleColor
             font:(NSFont *)font;

/**
 获取给定yyyy-MM 格式日期月份的最后一天的日期

 @param dateStr yyyy-MM 格式日期，如"2019-02"
 @return 如"29"
 */
+ (NSString *)monthEndDateWithDateStr:(NSString *)dateStr;

/**
 获取今年的年份

 */
+ (NSString *)thisYearDateStringWithFormat:(NSString *)format;
/**
 返回今年1月1日的NSDate对象

 */
+ (NSDate*)thisYearOrignDate;

/**
 返回距离日期thisDate，偏离dayCount天的日期

 @param thisDate 起点日期
 @param dayCount 偏离天数
 @param forceLeapYear 是否强制转换成闰年日期
 @return yyyy-MM-dd日期字符串
 */
+ (NSString *)dateStringSinceThisDate:(NSDate*)thisDate withOffsetDayCount:(NSInteger)dayCount forceLeapYear:(BOOL)forceLeapYear;

/**
 返回距离时间thisTime，偏离minutsCount分钟的时间


 @param thisTime 起点时间
 @param minutsCount  偏离分钟数
 @return hh:mm时间字符串
 */
+ (NSString *)timeStringSinceThisTime:(NSInteger)thisTime withOffsetMinutsCount:(NSInteger)minutsCount;

/**
 获取最合适的刻度标签数量

 @param font 标签字体
 @param height 所在坐标轴的高度(宽度)
 @return 最合适的数量
 */
+ (NSInteger)mostAppropriateScaleCountWithFont:(NSFont*)font height:(CGFloat)height;


+ (void)showAlert:(NSString *)text;

///< 获取随机色
+ (NSColor *)randomColor;

///< 获取随机正负符号(-1\+1)
+(int)randomSigns;


/**
 对象深拷贝

 @param obj 需要拷贝的对象
 @return 拷贝后的新对象
 @warning 当前仅支持简单的单层对象拷贝和item已经支持NSCopying协议的容器的拷贝，对于容器对象且item不支持NSCopying协议的，需要后期支持
 */
+ (id)copyObjWithObj:(id)obj;

///< 获取一个uuid
+ (NSString *)uuid;

///< 获取一个超链接的属性字符串
+ (NSAttributedString *)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL totalString:(NSString*)totalString;


+ (NSAttributedString *)hyperlinkFromString:(NSString*)inString withURLString:(NSString*)aURLString totalString:(NSString*)totalString;

@end
