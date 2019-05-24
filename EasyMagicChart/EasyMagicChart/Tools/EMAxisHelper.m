
//
//  EMAxisHelper.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//
#import <AppKit/AppKit.h>
#import "EMAxisHelper.h"
#import "EMControlTool.h"
#import "EMConverterTool.h"

#import "EMCommonlyUsedToolKit.h"

#define MONTHS_ONE_YEAR    12    //12个月

@implementation EMLyAxisParamX
- (instancetype)initWithXAxisItemCount:(NSInteger)xAxisItemCount
                            xAxisWidth:(CGFloat)xAxisWidth
                             xMinValue:(CGFloat)xMinValue
                             xMaxValue:(CGFloat)xMaxValue
                          leftSpaceing:(CGFloat)leftSpaceing
                         rightSpaceing:(CGFloat)rightSpaceing
                                  font:(NSFont*)font {
    self = [super init];
    if (self ) {
        _xAxisItemCount = xAxisItemCount;
        _xAxisWidth = xAxisWidth;
        _xMinValue = xMinValue;
        _xMaxValue = xMaxValue;
        _leftSpaceing = leftSpaceing;
        _rightSpaceing = rightSpaceing;
        _font = font;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@implementation EMLyAxisParamY
- (instancetype)initWithYAxisItemCount:(NSInteger)yAxisItemCount
                           yAxisHeight:(CGFloat)yAxisHeight
                             yMinValue:(CGFloat)yMinValue
                             yMaxValue:(CGFloat)yMaxValue
                           topSpaceing:(CGFloat)topSpaceing
                        bottomSpaceing:(CGFloat)bottomSpaceing
                                  font:(NSFont*)font {
    self = [super init];
    if (self) {
        _yAxisItemCount = yAxisItemCount;
        _yAxisHeight = yAxisHeight;
        _yMinValue = yMinValue;
        _yMaxValue = yMaxValue;
        _topSpaceing = topSpaceing;
        _bottomSpaceing = bottomSpaceing;
        _font = font;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@implementation EMAxisItem
- (id)copyWithZone:(NSZone *)zone {
    EMAxisItem * item = [[[self class] allocWithZone:zone] init];
    item.position       = _position;
    item.textRect       = _textRect;
    item.text           = [_text copy];
    item.textColor      = _textColor;
    item.drawText       = _drawText;
    item.drawDottedLine = _drawDottedLine;
    return item;
}
- (instancetype)initWithPoint:(CGFloat)point labelString:(NSString *)labelText {
    self = [[EMAxisItem alloc] initWithPoint:point labelString:labelText color:nil];
    return self;
}

- (instancetype)initWithPoint:(CGFloat)point labelString:(NSString*)labelText color:(NSColor *)color {
    self = [super init];
    _position = point;
    _text = labelText;
    _textColor = color;
    _textRect  = CGRectZero;
    _drawText = YES;
    _drawDottedLine = NO;
    return self;
}

+ (instancetype)itemWithPoint:(CGFloat)point labelString:(NSString*)labelText color:(NSColor *)color {
    return [[EMAxisItem new] initWithPoint:point labelString:labelText color:color];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@implementation EMAxisHelper

- (NSArray <EMAxisItem *>*)yAxisItemsWithParam:(EMLyAxisParamY *)paramY {
    if (nil == paramY){
        return nil;
    }
    NSMutableArray *marr = [NSMutableArray new];
    NSInteger mostAppropriateScaleCount = 0;
    if (0 == paramY.yAxisItemCount) {
        mostAppropriateScaleCount = [EMControlTool mostAppropriateScaleCountWithFont:paramY.font height:paramY.yAxisHeight];
    } else {
        mostAppropriateScaleCount = paramY.yAxisItemCount;
    }
    
    if (0 == mostAppropriateScaleCount) {
        return nil;
    }
    
    CGFloat _deltaY = ((paramY.yMaxValue - paramY.yMinValue) / mostAppropriateScaleCount);
    NSFont * font = paramY.font ? : [NSFont systemFontOfSize:12.0];
    NSDictionary *attriDict = @{NSFontAttributeName: font};
    CGFloat valueY = 0;
    CGFloat ptY = 0.0;
    
    for (NSInteger i = 0; i <= mostAppropriateScaleCount; i++) {
        if (!IS_DOUBLE_ZERO(_deltaY)) {
            valueY = _deltaY *  i + paramY.yMinValue;
        }
        ptY = [EMConverterTool ptYWithIndex:i
                                 scaleCount:mostAppropriateScaleCount
                                 axisLength:paramY.yAxisHeight
                                 topSpacing:paramY.topSpaceing
                              bottomSpacing:paramY.bottomSpaceing];
        
        NSString *str = paramY.formattedStringBlock(valueY);
        NSSize size = [str sizeWithAttributes:attriDict];
        
        CGFloat rectY = 0;
        if (0 == i) {
            rectY = 0;
            ptY = 0;
        } else if (mostAppropriateScaleCount == i) {
            rectY = ptY - size.height;
        } else {
            rectY = ptY - 0.5 * size.height;
        }
        
        EMAxisItem *item = [[EMAxisItem alloc] initWithPoint:ptY labelString:str];
        NSRect rect = NSZeroRect;
        rect.size = size;
        CGFloat rectX = 0;
        if (paramY.isLeft) {
            rectX = paramY.yAxisWidth - size.width;
        }
        rect.origin = NSMakePoint(rectX, rectY);
        item.textRect = rect;
        
        if (paramY.colorBlock) {
            item.textColor = paramY.colorBlock(valueY);
        }
        [marr addObject:item];
    }
    return [marr copy];
}


- (NSArray <EMAxisItem *>*)xAxisItemsWithParam:(EMLyAxisParamX *)paramX {
    if (nil == paramX){
        return nil;
    }
    NSMutableArray  <EMAxisItem *>* mArr = [NSMutableArray new];
    NSDictionary *attriDict = @{NSFontAttributeName:paramX.font ? : [NSFont systemFontOfSize:12.0]};
    CGFloat ptX = 0.0;
    NSString *date = @"";
    NSSize size = NSZeroSize;
    NSRect rect = NSZeroRect;
    rect.origin.y = 0;
    CGFloat delta = (paramX.xAxisWidth - paramX.leftSpaceing - paramX.rightSpaceing) / paramX.xAxisItemCount;
    NSArray <NSString *>* labels = [self p_oneYearPerMonthEndDateLabels];
    
    for (NSInteger i = 0; i < labels.count; i++) {
        date = labels[i];
        size = [date sizeWithAttributes:attriDict];
        ptX = [self p_pointXWithIndex:i leftSpaceing:paramX.leftSpaceing delta:delta];
        
        if (0 == i) { // 第一年必须画，且日期为1月1日
            rect.origin.x = paramX.leftSpaceing;
        } else if (i == labels.count - 1) { // 最后一个右对齐
            rect.origin.x =  paramX.xAxisWidth - paramX.rightSpaceing - size.width;
        } else {
            rect.origin.x = ptX - 0.5 * size.width;
        }
        
        EMAxisItem *item = [[EMAxisItem alloc] initWithPoint:ptX labelString:date];
        
        if (0 != i % 2){
            item.drawText = NO;
            item.drawDottedLine = YES;
        }
        
        rect.size = size;
        item.textRect = rect;
        
        [mArr addObject: item];
    }
    return [mArr copy];
}

- (CGFloat)p_pointXWithIndex:(NSUInteger)index leftSpaceing:(CGFloat)leftSpaceing delta:(CGFloat)delta {
    if (0 == index) { // 第一年必须画，且日期为1月1日
        return leftSpaceing;
    } else {
        return (index ) * delta + leftSpaceing;
    }
}

// 返回每个月月末的日期(或者说当月天数)
- (NSInteger)p_monthEndDateWithMonth:(NSInteger)month {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 2:
            return 29; // 2月不论是否为闰年都返回29天，是考虑到现金套利可用额度走势中，今年数据和366个3、5年数据的对齐
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
    }
    return 31;
}

- (NSString* )p_formatedStringWithValue1:(NSInteger)v1
                                  value2:(NSInteger)v2
                            formatString:(NSString *)formatString {
    if (0 == formatString.length) {
        return nil;
    }
    return [NSString stringWithFormat:formatString, v1, v2];
}

/**
返回一年中作为刻度的日期标签，1月份为1月1日，其他为月末，算入闰年，2月为2月29日
 */
- (NSArray <NSString*> *)p_oneYearPerMonthEndDateLabels {
    NSString *formatString = @"%ld月%ld日";
    NSString *date = @"";
    NSString *endDate = @"";
    NSMutableArray  <NSString *>* mArr = [NSMutableArray new];

    for (NSInteger i = 1; i <= MONTHS_ONE_YEAR; i++) {
        if (1 == i) { // 第一个月必须画，且日期为1月1日
            date = [self p_formatedStringWithValue1:i value2:1 formatString:formatString];
            [mArr addObject: date];
        }
        endDate = [NSString stringWithFormat:@"%ld", [self p_monthEndDateWithMonth:i]];
        date = [self p_formatedStringWithValue1:i value2:endDate.integerValue formatString:formatString];
        
        [mArr addObject: date];
    }
    return [mArr copy];
}


@end
