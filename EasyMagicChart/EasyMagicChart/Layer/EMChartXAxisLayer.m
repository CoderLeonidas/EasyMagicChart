//
//  EMChartXAxisLayer.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//
#import <AppKit/AppKit.h>

#import "EMChartXAxisLayer.h"
#import "EMAxisHelper.h"

@implementation EMChartXAxisLayer

- (void)drawInContext:(CGContextRef)ctx {
    //!!!: 不知如何用CG绘制文本，所以此处转为NS的上下文绘制文本
    NSGraphicsContext *oldCtx = [NSGraphicsContext currentContext];
    NSGraphicsContext *newCtx = [NSGraphicsContext graphicsContextWithCGContext:ctx flipped:NO];
    [NSGraphicsContext setCurrentContext:newCtx];
    NSColor *textColor = (_textColor ? : _axisLabels.firstObject.textColor)?:[NSColor darkGrayColor];
    NSDictionary *attriDict = @{NSForegroundColorAttributeName:textColor,
                                NSFontAttributeName:_font ? : [NSFont systemFontOfSize:12.0]};
    EMAxisItem *item = nil;
    for (NSInteger i = 0; i < _axisLabels.count; i++) {
        item = _axisLabels[i];
        if (!item.drawText) {
            continue;
        }
        [item.text drawInRect:item.textRect withAttributes:attriDict];
    }
    
    [NSGraphicsContext setCurrentContext:oldCtx];
}

- (void)clear {
    _axisLabels = @[];
}

@end

