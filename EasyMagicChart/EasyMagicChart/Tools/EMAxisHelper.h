//
//  EMAxisHelper.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  处理坐标轴相关数据

#import <Foundation/Foundation.h>

@class NSColor;

typedef NSString *(^FormattedStringBlock)(CGFloat);
typedef NSColor *(^ColorBlock)(CGFloat);

// Y坐标轴参数
@interface EMLyAxisParamY: NSObject
@property (nonatomic, assign) NSInteger yAxisItemCount;
@property (nonatomic, assign) CGFloat yAxisHeight;
@property (nonatomic, assign) CGFloat yAxisWidth;
@property (nonatomic, assign) CGFloat yMinValue;
@property (nonatomic, assign) CGFloat yMaxValue;
@property (nonatomic, assign) CGFloat topSpaceing;
@property (nonatomic, assign) CGFloat bottomSpaceing;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, strong) NSFont *font;
@property (nonatomic, copy)  FormattedStringBlock formattedStringBlock; ///< 数值字符串格式化的回调处理，参数为数值，供外部根据数值来处理格式化字符串，如美股价格等
@property (nonatomic, copy)  ColorBlock colorBlock; ///< 数值字符串颜色的回调处理，参数为数值，供外部根据数值来确定其显示的颜色，如涨跌幅等


- (instancetype)initWithYAxisItemCount:(NSInteger)yAxisItemCount
                           yAxisHeight:(CGFloat)yAxisHeight
                             yMinValue:(CGFloat)yMinValue
                             yMaxValue:(CGFloat)yMaxValue
                           topSpaceing:(CGFloat)topSpaceing
                        bottomSpaceing:(CGFloat)bottomSpaceing
                                  font:(NSFont*)font;
@end

// X坐标轴参数
@interface EMLyAxisParamX: NSObject
@property (nonatomic, assign) NSInteger xAxisItemCount;
@property (nonatomic, assign) CGFloat xAxisWidth;
@property (nonatomic, assign) CGFloat xMinValue;
@property (nonatomic, assign) CGFloat xMaxValue;

@property (nonatomic, assign) CGFloat leftSpaceing;
@property (nonatomic, assign) CGFloat rightSpaceing;
@property (nonatomic, strong) NSFont *font;

- (instancetype)initWithXAxisItemCount:(NSInteger)xAxisItemCount
                            xAxisWidth:(CGFloat)xAxisWidth
                             xMinValue:(CGFloat)xMinValue
                             xMaxValue:(CGFloat)xMaxValue
                          leftSpaceing:(CGFloat)leftSpaceing
                         rightSpaceing:(CGFloat)rightSpaceing
                                  font:(NSFont*)font;
@end

// 坐标点元素
@interface EMAxisItem: NSObject <NSCopying>
@property (nonatomic, assign) CGFloat position;     ///< 坐标点位置，用于绘制实线
@property (nonatomic, assign) CGRect textRect; ///< 坐标点文本绘制的位置
@property (nonatomic, copy) NSString *text; ///< 坐标点文本内容
@property (nonatomic, strong) NSColor *textColor;///< 坐标点文本颜色
@property (nonatomic, assign) BOOL drawText;///< 是否需要绘制文本， 默认为YES
@property (nonatomic, assign) BOOL drawDottedLine;///< 是否需要绘制虚线， 默认为NO

+ (instancetype)itemWithPoint:(CGFloat)point labelString:(NSString*)labelText color:(NSColor *)color;
- (instancetype)initWithPoint:(CGFloat)point labelString:(NSString*)labelText;
- (instancetype)initWithPoint:(CGFloat)point labelString:(NSString*)labelText color:(NSColor *)color;

@end

@class EMColumnInfoUseInRtline;
@class EMMinMaxValue;

/**
 坐标轴刻度生成器
 */
@interface EMAxisHelper : NSObject

/**
 根据Y轴参数生成并返回Y轴刻度数组

 @param paramY Y轴参数
 @return  Y轴刻度数组
 */
- (NSArray <EMAxisItem *>*)yAxisItemsWithParam:(EMLyAxisParamY *)paramY;

/**
根据轴参数生成并返回X轴刻度数组

 @param paramX X轴参数
 @return X轴刻度数组
 */
- (NSArray <EMAxisItem *>*)xAxisItemsWithParam:(EMLyAxisParamX *)paramX;


@end
