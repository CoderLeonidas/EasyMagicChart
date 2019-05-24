//
//  EMChartYAxisLayer.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "EMChartYAxisLayer.h"
#import "EMControlTool.h"
#import "EMAxisHelper.h"

@interface EMChartYAxisLayer () {
    NSMutableDictionary *_mAttributeDict; ///< 公用属性字典，用于绘制文本
    NSMutableParagraphStyle *_paragraphStyle;///< 段落对象，用于设置文本左右对齐
    EMChartYAxisLayerType _type; ///< 类型，作为左纵轴还是右纵轴
}
@end

@implementation EMChartYAxisLayer

+ (instancetype)yAxisLayerWithType:(EMChartYAxisLayerType)type {
    return [[EMChartYAxisLayer alloc] initWithType:type];
}

- (instancetype)initWithType:(EMChartYAxisLayerType)type {
    self = [super init];
    if (self) {
        _type = type;
        _paragraphStyle = [NSMutableParagraphStyle new];
        _mAttributeDict = [NSMutableDictionary new];
        _paragraphStyle.alignment = (_type == EMChartYAxisLayerLeft) ? NSTextAlignmentRight : NSTextAlignmentLeft;
        _mAttributeDict[NSParagraphStyleAttributeName] = _paragraphStyle;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithType:EMChartYAxisLayerLeft];
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    if (0 == _axisLabels.count) {
        return;
    }
    //!!!: 不知如何用CG绘制文本，所以此处转为NS的上下文绘制文本
    NSGraphicsContext *oldCtx = [NSGraphicsContext currentContext];
    NSGraphicsContext *newCtx = [NSGraphicsContext graphicsContextWithCGContext:ctx flipped:NO];
    [NSGraphicsContext setCurrentContext:newCtx];
    BOOL anti = oldCtx.shouldAntialias;
    NSColor *textColor = nil;

    for (NSInteger i = 0; i < _axisLabels.count; i++) {
        EMAxisItem *obj = _axisLabels[i];
        textColor = (obj.textColor ? : _textColor)?:[NSColor darkGrayColor];
        _mAttributeDict[NSForegroundColorAttributeName] = textColor;
        [obj.text drawInRect:obj.textRect withAttributes:_mAttributeDict];
    }
    
    oldCtx.shouldAntialias = anti;
    [NSGraphicsContext setCurrentContext:oldCtx];
}

- (void)setFont:(NSFont *)font {
    _font = font;
    _mAttributeDict[NSFontAttributeName] = _font ? : [NSFont systemFontOfSize:12.0];
}

- (void)setAxisLabels:(NSArray<EMAxisItem *> *)axisLabels {
    _axisLabels = axisLabels;
}

- (void)clear {
    _axisLabels = @[];
}

@end
