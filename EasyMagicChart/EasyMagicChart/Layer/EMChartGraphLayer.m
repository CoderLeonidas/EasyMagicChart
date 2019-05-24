//
//  EMChartGraphLayer.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "EMChartGraphLayer.h"
#import "EMConverterTool.h"
#import "EMTypicalColor.h"

@interface EMChartGraphLayer () {
    NSMutableArray <EMBaseGraph *> *_graphs;
}

@end

@implementation EMChartGraphLayer

#pragma mark - Draw

- (void)drawInContext:(CGContextRef)ctx {
    // 绘制与数据无关的基础部分
    [self p_drawBasisInContext:ctx];
    // 绘制主图
    [self p_drawMainGraphInContext:ctx];
}


- (void)p_drawBasisInContext:(CGContextRef)ctx{
    // 绘制渲染区域
    [self p_drawRenderingAreaInContext:ctx];
    // 绘制边界线
    [self p_drawBorderInContext:ctx];
    // 绘制网格线
    [self p_drawGridInContext:ctx];
    // 绘制(横)中线
    if (_hasMiddleLine) {
        [self p_drawMidLineInContext:ctx];
    }
}

// 绘制渲染区域
- (void)p_drawRenderingAreaInContext:(CGContextRef)ctx {
    if (CGRectIsEmpty(_renderingAreaRect)) {return;}
    
    CGContextSetFillColorWithColor(ctx, (_renderingAreaColor ? : [[NSColor blueColor]colorWithAlphaComponent:0.5]).CGColor);
    CGContextFillRect(ctx, _renderingAreaRect);
}

// 绘制边框
- (void)p_drawBorderInContext:(CGContextRef)ctx {
    CGContextSetStrokeColorWithColor(ctx, (_gridColor?:[NSColor grayColor]).CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddRect(ctx, self.bounds);
    CGContextDrawPath(ctx, kCGPathStroke);
}

//在rect区域中间画一条线
- (void)p_drawMidLineInContext:(CGContextRef)ctx  {
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextSetStrokeColorWithColor(ctx, (_gridColor?:[NSColor grayColor]).CGColor);
    CGPoint aPoints[2];//坐标点
    aPoints[0] = CGPointMake(0, (int)(CGRectGetMidY(self.bounds)));
    aPoints[1] = CGPointMake((int)CGRectGetMaxX(self.bounds),  (int)(CGRectGetMidY(self.bounds)));
    CGContextAddLines(ctx, aPoints, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)p_drawParallelLineInContext:(CGContextRef)ctx withGraph:(EMParallelLineGraph *)graph {
    if (nil == graph) {return;}
    
    CGFloat maxY = graph.extremumY.max;
    CGFloat minY = graph.extremumY.min;
    
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextSetStrokeColorWithColor(ctx, (graph.color?:[NSColor grayColor]).CGColor);
    CGPoint aPoints[2];//坐标点
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat  y = [EMConverterTool ptYWithMaxValueY:maxY
                                         minValueY:minY
                                            valueY:graph.value
                                        axisLength:height
                                        topSpacing:_accessory.topSpacing
                                     bottomSpacing:_accessory.bottomSpacing];
    aPoints[0] = CGPointMake(0, (int)y);
    aPoints[1] = CGPointMake((int)CGRectGetMaxX(self.bounds),  (int)y);
    CGContextAddLines(ctx, aPoints, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
}

// 绘制网格
- (void)p_drawGridInContext:(CGContextRef)ctx {
    if (0 == _gridColumn && 0 == _xAxisLabels.count &&
        0 == _gridRow && 0 == _yAxisLabels.count) {
        return;
    }
    
    CGFloat widthView = CGRectGetWidth(self.frame);
    CGFloat heightView = CGRectGetHeight(self.frame) ;
    CGContextSetLineWidth(ctx, 0.5);
    
    CGContextSetStrokeColorWithColor(ctx, (_gridColor?:[EMTypicalColor sharedTypicalColor].gridColor).CGColor);
    CGPoint aPoints[2];//坐标点
    
    // 画竖线
    if (_xAxisLabels.count > 0) {
        EMAxisItem *item = nil;
        for (int i = 0; i < _xAxisLabels.count; i++) {
            item = _xAxisLabels[i];
            if (!item.drawText) {
                continue;
            }
            if (0 == i) continue;
            aPoints[0] = CGPointMake((int)item.position, 0);
            aPoints[1] = CGPointMake((int)item.position, (int)heightView);
            CGContextAddLines(ctx, aPoints, 2);
        }
    } else if (_gridColumn > 0) {
        EMBaseGraph *graph = _graphs.firstObject;
        CGFloat x = 0;
        CGFloat size = (widthView / (_gridColumn * 1.0));
        for (int i = 0; i <= _gridColumn; i++) {
            if (graph) {
                x = [EMConverterTool ptXWithIndexX:i
                                       axisLength:NSWidth(self.frame)
                                       scaleCount:_gridColumn
                                     leftSpacing:_accessory.leftSpacing
                                    rightSpacing:_accessory.rightSpacing];
            } else {
                 x = i * size;
            }
            aPoints[0] = CGPointMake((int)x, 0);
            aPoints[1] = CGPointMake((int)x, (int)heightView);
            CGContextAddLines(ctx, aPoints, 2);
        }
    }
    // 画横线
    if (_yAxisLabels.count > 0) {
        for (NSUInteger i = 0; i < _yAxisLabels.count; i++) {
            aPoints[0] = CGPointMake(0, (int)(_yAxisLabels[i].position));
            aPoints[1] = CGPointMake((int)widthView,  (int)(_yAxisLabels[i].position));
            CGContextAddLines(ctx, aPoints, 2);
        }
    } else if (_gridRow > 0) {
        CGFloat size = (heightView / (_gridRow * 1.0));
        for (NSUInteger i = 0; i < _gridRow; i++) {
            CGFloat y = i * size;
            aPoints[0] = CGPointMake(0, (int)y);
            aPoints[1] = CGPointMake((int)widthView,  (int)y);
            CGContextAddLines(ctx, aPoints, 2);
        }
    }
    CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径

    
    //画竖虚线
    CGFloat dash[4] = {4, 2, 2, 2};
    CGContextSetLineDash(ctx, 0.0, dash, 4);
     EMAxisItem *item = nil;
    for (int i = 0; i < _xAxisLabels.count; i++) {
        item = _xAxisLabels[i];
        if (!item.drawDottedLine) {
            continue;
        }
        if (0 == i) continue;
        aPoints[0] =CGPointMake(item.position, 0);//坐标1
        aPoints[1] =CGPointMake(item.position, CGRectGetHeight(self.frame));//坐标2
        CGContextAddLines(ctx, aPoints, 2);//添加线
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
    }
    // 变成实线
    CGFloat dash2[2] = {1,0};
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
}

// 绘制主图
- (void)p_drawMainGraphInContext:(CGContextRef)ctx {
    // 根据图形类型，绘制不同的图形
    for (EMBaseGraph *graph in _graphs) {
        CGContextSaveGState(ctx);
        switch (graph.graphType) {
            case EMGraphTypeLineChart:
                [self p_drawLineChartInContext:ctx withGraph:(EMLineGraph *)graph];
                break;
            case EMGraphTypeBarChart:
                [self p_drawBarChartInContext:ctx withGraph:(EMBarGraph *)graph];
                break;
            case EMGraphTypeCandlestickChart:
                [self p_drawCandlestickChartInContext:ctx withGraph:(EMCandlestickGraph *)graph];
                break;
            case EMGraphTypeRenderRegionChart:
                [self p_drawColorRenderRegionInContext:ctx withGraph:(EMRenderRegionGraph *)graph];
                break;
            case EMGraphTypeParallelLine:
                [self p_drawParallelLineInContext:ctx withGraph:(EMParallelLineGraph *)graph];
                break;
            case EMGraphTypePieChart:
                [self p_drawParallelLineInContext:ctx withGraph:(EMParallelLineGraph *)graph];
                break;
            default:
                break;
        }
        CGContextRestoreGState(ctx);
    }
}

// TODO
- (void)p_drawPieChartInContext:(CGContextRef)ctx withGraph:(EMPieGraph *)graph {
    
}

// 绘制相似K线中各涨幅线的彩色渲染区域
- (void)p_drawColorRenderRegionInContext:(CGContextRef)ctx withGraph:(EMRenderRegionGraph *)graph {
    if (graph.dataSource.count < 2 || 0 == graph.totalDataCount) {
        return;
    }
    // 获取每天所有相似股票中的最高和最低涨幅(价格)
    NSMutableArray <NSNumber *> *maxIncreasePerDays = [graph.dataSource valueForKey:@"high"];
    NSMutableArray <NSNumber *> *minIncreasePerDays = [graph.dataSource valueForKey:@"low"];
    
    CGFloat lastClosePrice = graph.lastClosePrice;
    NSMutableArray <NSNumber *> *redTop  = [[NSMutableArray alloc] initWithArray:maxIncreasePerDays copyItems:YES];;
    [redTop enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue < lastClosePrice)  {
            redTop[idx] = @(lastClosePrice);
        }
    }];
    NSMutableArray <NSNumber *> *redBottom =  [[NSMutableArray alloc] initWithArray:minIncreasePerDays copyItems:YES];;
    [redBottom enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue < lastClosePrice)  {
            redBottom[idx] = @(lastClosePrice);
        }
    }];
    
    NSMutableArray <NSNumber *> *greenBottom =  [[NSMutableArray alloc] initWithArray:minIncreasePerDays copyItems:YES];;
    [greenBottom enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue > lastClosePrice)  {
            greenBottom[idx]  = @(lastClosePrice);
        }
    }];
    NSMutableArray <NSNumber *> *greenTop  = [[NSMutableArray alloc] initWithArray:maxIncreasePerDays copyItems:YES];;
    [greenTop enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue > lastClosePrice)  {
            greenTop[idx] = @(lastClosePrice);
        }
    }];
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat maxY = graph.extremumY.max;
    CGFloat minY = graph.extremumY.min;
    
    CGFloat topSpacing = _accessory.topSpacing;
    CGFloat bottomSpacing = _accessory.bottomSpacing;
    CGFloat leftSpacing = _accessory.leftSpacing;
    CGFloat rightSpacing = _accessory.rightSpacing;
    NSUInteger totalDataCount = graph.totalDataCount;
    
    CGFloat deltaX = [EMConverterTool deltaWithScaleCount:totalDataCount axisLength:width leftSpacing:_accessory.leftSpacing rightSpacing:_accessory.rightSpacing];

    for (NSInteger i = 0; i < redBottom.count; i++){
        if (i + 1 >=  redBottom.count){
            break;
        }
        CGFloat  yMax = [EMConverterTool ptYWithMaxValueY:maxY
                                                minValueY:minY
                                                   valueY:redTop[i].floatValue
                                               axisLength:height
                                               topSpacing:topSpacing
                                            bottomSpacing:bottomSpacing];
        
        CGFloat  yMin = [EMConverterTool ptYWithMaxValueY:maxY
                                                minValueY:minY
                                                   valueY:redBottom[i].floatValue
                                               axisLength:height
                                               topSpacing:topSpacing
                                            bottomSpacing:bottomSpacing];
        CGFloat x = [EMConverterTool ptXWithIndexX:i
                                        axisLength:width
                                        scaleCount:totalDataCount
                                       leftSpacing:leftSpacing
                                      rightSpacing:rightSpacing];
        
        
        CGFloat  yMaxNext = [EMConverterTool ptYWithMaxValueY:maxY
                                                    minValueY:minY
                                                       valueY:redTop[i+1].floatValue
                                                   axisLength:height
                                                   topSpacing:topSpacing
                                                bottomSpacing:bottomSpacing];
        
        CGFloat  yMinNext = [EMConverterTool ptYWithMaxValueY:maxY
                                                    minValueY:minY
                                                       valueY:redBottom[i+1].floatValue
                                                   axisLength:height
                                                   topSpacing:topSpacing
                                                bottomSpacing:bottomSpacing];
        CGFloat xNext = [EMConverterTool ptXWithIndexX:i+1
                                            axisLength:width
                                            scaleCount:totalDataCount
                                           leftSpacing:leftSpacing
                                          rightSpacing:rightSpacing];
        x += deltaX * 0.5;
        xNext += deltaX * 0.5;
        
        CGPathMoveToPoint(cgPath,NULL, x, yMin);
        CGPathAddLineToPoint(cgPath,NULL, x, yMax);
        CGPathAddLineToPoint(cgPath,NULL, xNext, yMaxNext);
        CGPathAddLineToPoint(cgPath,NULL, xNext, yMinNext);
        CGPathAddLineToPoint(cgPath,NULL, x, yMin);
        
    }
    CGContextAddPath(ctx, cgPath);
    CGPathCloseSubpath(cgPath);
    
    NSColor * buyBkgColor    =  [NSColor redColor];
    NSColor * sellBkgColor   = [NSColor greenColor];
    CGContextSetFillColorWithColor(ctx, buyBkgColor.CGColor);
    CGContextFillPath(ctx);
    CGPathRelease(cgPath);
    
    cgPath = CGPathCreateMutable();
    for (NSInteger i = 0; i < redBottom.count; i++){
        if (i + 1 >=  redBottom.count){
            break;
        }
        CGFloat  yMax = [EMConverterTool ptYWithMaxValueY:maxY
                                                minValueY:minY
                                                   valueY:greenTop[i].floatValue
                                               axisLength:height
                                               topSpacing:topSpacing
                                            bottomSpacing:bottomSpacing];
        
        CGFloat  yMin = [EMConverterTool ptYWithMaxValueY:maxY
                                                minValueY:minY
                                                   valueY:greenBottom[i].floatValue
                                               axisLength:height
                                               topSpacing:topSpacing
                                            bottomSpacing:bottomSpacing];
        CGFloat x = [EMConverterTool ptXWithIndexX:i
                                        axisLength:width
                                        scaleCount:totalDataCount
                                       leftSpacing:leftSpacing
                                      rightSpacing:rightSpacing];
        
        
        CGFloat  yMaxNext = [EMConverterTool ptYWithMaxValueY:maxY
                                                    minValueY:minY
                                                       valueY:greenTop[i+1].floatValue
                                                   axisLength:height
                                                   topSpacing:topSpacing
                                                bottomSpacing:bottomSpacing];
        
        CGFloat  yMinNext = [EMConverterTool ptYWithMaxValueY:maxY
                                                    minValueY:minY
                                                       valueY:greenBottom[i+1].floatValue
                                                   axisLength:height
                                                   topSpacing:topSpacing
                                                bottomSpacing:bottomSpacing];
        CGFloat xNext = [EMConverterTool ptXWithIndexX:i+1
                                            axisLength:width
                                            scaleCount:totalDataCount
                                           leftSpacing:leftSpacing
                                          rightSpacing:rightSpacing];
        
        x += deltaX * 0.5;
        xNext += deltaX * 0.5;

        CGPathMoveToPoint(cgPath,NULL, x, yMin);
        CGPathAddLineToPoint(cgPath,NULL, x, yMax);
        CGPathAddLineToPoint(cgPath,NULL, xNext, yMaxNext);
        CGPathAddLineToPoint(cgPath,NULL, xNext, yMinNext);
        CGPathAddLineToPoint(cgPath,NULL, x, yMin);
        
    }
    CGContextAddPath(ctx, cgPath);
    CGPathCloseSubpath(cgPath);
    
    CGContextSetFillColorWithColor(ctx, sellBkgColor.CGColor);
    CGContextFillPath(ctx);
    CGPathRelease(cgPath);
}


// 绘制线型图
- (void)p_drawLineChartInContext:(CGContextRef)ctx withGraph:(EMLineGraph *)graph {
    if (graph.extremumY.max <= 0 || graph.dataSource.count < 2 || 0 == graph.totalDataCount) {
        return;
    }
    CGFloat maxY = graph.extremumY.max;
    CGFloat minY = graph.extremumY.min;

    EMLineGraphDataItem *data = nil;
    EMLineGraphDataItem *nextData = nil;
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, (graph.color?:[NSColor orangeColor]).CGColor);
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGPoint startPoint = CGPointZero, endPoint = CGPointZero;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat deltaX = [EMConverterTool deltaWithScaleCount:graph.totalDataCount
                                               axisLength:width
                                              leftSpacing:_accessory.leftSpacing
                                             rightSpacing:_accessory.rightSpacing];
    deltaX = MAX(1.0, deltaX);
    for (NSInteger i = 0; i < graph.dataSource.count; i++){
        if (i + 1 >=  graph.dataSource.count){
            break;
        }
        data = (EMLineGraphDataItem*)graph.dataSource[i];
        nextData = (EMLineGraphDataItem*)graph.dataSource[i+1];
        NSUInteger totalDataCount = graph.totalDataCount > 0 ? graph.totalDataCount : graph.dataSource.count;
        CGFloat  yFrom = [EMConverterTool ptYWithMaxValueY:maxY
                                                 minValueY:minY
                                                    valueY:data.lineValue
                                                axisLength:height
                                                topSpacing:_accessory.topSpacing
                                             bottomSpacing:_accessory.bottomSpacing];
        
        CGFloat  yTo = [EMConverterTool ptYWithMaxValueY:maxY
                                               minValueY:minY
                                                  valueY:nextData.lineValue
                                              axisLength:height
                                              topSpacing:_accessory.topSpacing
                                           bottomSpacing:_accessory.bottomSpacing];
        CGFloat xFrom = [EMConverterTool ptXWithIndexX:i
                                            axisLength:width
                                            scaleCount:totalDataCount
                                           leftSpacing:_accessory.leftSpacing
                                          rightSpacing:_accessory.rightSpacing];
        CGFloat xTo = [EMConverterTool ptXWithIndexX:i+1
                                          axisLength:width
                                          scaleCount:totalDataCount
                                         leftSpacing:_accessory.leftSpacing
                                        rightSpacing:_accessory.rightSpacing];
        xFrom += deltaX * 0.5;
        xTo += deltaX * 0.5;

        CGPoint ptFrom  = CGPointMake(xFrom, yFrom);
        CGPoint ptTo  = CGPointMake(xTo, yTo);
        
        if (0 == i) {
            startPoint = ptFrom;
            CGPathMoveToPoint(cgPath,NULL, ptFrom.x, ptFrom.y);
        } else {
            CGPathAddLineToPoint(cgPath,NULL, ptFrom.x,ptFrom.y);
        }
        
        if (i == graph.dataSource.count - 2) {
            _latestDataPoint = ptTo;
            endPoint = ptTo;
        }
        CGPathAddLineToPoint(cgPath,NULL, ptTo.x,ptTo.y);
    }
    CGContextAddPath(ctx, cgPath);
    CGContextStrokePath(ctx);
    CGPathCloseSubpath(cgPath);
    
    if (graph.hasGradient && nil != graph.gradientStartColor && nil != graph.gradientStartColor) {
        [self p_drawLinearGradient:ctx path:cgPath startColor:graph.gradientStartColor .CGColor endColor:graph.gradientStartColor.CGColor startPoint:startPoint endPoint:endPoint];
    }
    
    CGPathRelease(cgPath);
}

- (void)p_drawLinearGradient:(CGContextRef)context
                        path:(CGMutablePathRef)path
                  startColor:(CGColorRef)startColor
                    endColor:(CGColorRef)endColor
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat *startColorComponents = (CGFloat *)CGColorGetComponents(startColor);
    CGFloat *endColorComponents = (CGFloat *)CGColorGetComponents(endColor);
    //颜色组件的数组
    CGFloat colorComponents[8] = {
        startColorComponents[0],
        startColorComponents[1],
        startColorComponents[2],
        startColorComponents[3],
        endColorComponents[0],
        endColorComponents[1],
        endColorComponents[2],
        endColorComponents[3],
    };
    //颜色数组中的颜色位置
    CGFloat colorIndices[2] = {
        0.0,
        1.0
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, colorIndices, 2);
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, 0);
    CGPathAddLineToPoint(path, NULL, startPoint.x, 0);
    CGPathAddLineToPoint(path, NULL, startPoint.x, startPoint.y);

    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextRotateCTM(context, M_PI_2);

    CGContextDrawLinearGradient(context, gradient, NSMakePoint(startPoint.x, 0), NSMakePoint(CGRectGetMaxX(self.frame), 0), kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

// 绘制柱形图
- (void)p_drawBarChartInContext:(CGContextRef)ctx withGraph:(EMBarGraph *)graph {
    if (graph.dataSource.count < 1 || 0 == graph.totalDataCount) {
        return;
    }
    CGContextSetLineWidth(ctx, 1.0);
    EMBarGraphDataItem *data = nil;
    CGFloat lastLineValue = graph.lastClosePrice; // 决定第一根线的颜色
    NSColor *lineColor;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat maxY = graph.extremumY.max;
    CGFloat minY = graph.extremumY.min;

    for (NSInteger i = 0; i < graph.dataSource.count; i++){
        data = (EMBarGraphDataItem*)graph.dataSource[i];
        CGFloat  yFrom = [EMConverterTool ptYWithMaxValueY:maxY
                                                 minValueY:minY
                                                    valueY:0
                                                axisLength:height
                                                topSpacing:_accessory.topSpacing
                                             bottomSpacing:_accessory.bottomSpacing];
        
        CGFloat  yTo = [EMConverterTool ptYWithMaxValueY:maxY
                                               minValueY:minY
                                                  valueY:data.lineValue
                                              axisLength:height
                                              topSpacing:_accessory.topSpacing
                                           bottomSpacing:_accessory.bottomSpacing];
        CGFloat x = [EMConverterTool ptXWithIndexX:i
                                        axisLength:width
                                        scaleCount:graph.totalDataCount
                                       leftSpacing:_accessory.topSpacing
                                      rightSpacing:_accessory.bottomSpacing];
        
        
        CGPoint ptFrom  = CGPointMake(x, yFrom);
        CGPoint ptTo  = CGPointMake(x, yTo);
        if (i == graph.dataSource.count - 1) {
            _latestDataPoint = ptTo;
        }
        CGPoint aPoints[2];//坐标点
        aPoints[0] = ptFrom;
        aPoints[1] = ptTo;
        
        lineColor = [EMTypicalColor colorWithValue:(data.close - lastLineValue) glnColor:graph.glnColor];
        CGContextSetStrokeColorWithColor(ctx, (lineColor ?: [NSColor grayColor]).CGColor);
        
        CGContextAddLines(ctx, aPoints, 2);
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
        lastLineValue = data.close;
    }
}

#define KLINE_SPACING 2

// 绘制蜡烛图
- (void)p_drawCandlestickChartInContext:(CGContextRef)ctx withGraph:(EMCandlestickGraph *)graph {
    if (0 == graph.dataSource.count || 0 == graph.totalDataCount) {return;}
    
    CGContextSetLineWidth(ctx, 1.0);
    EMCandlestickGraphDataItem *data = nil;
    
    CGFloat deltaX = [EMConverterTool deltaWithScaleCount:graph.totalDataCount
                                               axisLength:CGRectGetWidth(self.frame)
                                              leftSpacing:_accessory.leftSpacing
                                             rightSpacing:_accessory.rightSpacing];
    CGFloat klineWidth = MAX(1.0, deltaX - KLINE_SPACING);
    CGFloat rectHeight = CGRectGetHeight(self.frame);
    CGFloat rectWidth = CGRectGetWidth(self.frame);

    CGFloat maxY = graph.extremumY.max;
    CGFloat minY = graph.extremumY.min;
    CGFloat topSpacing = _accessory.topSpacing;
    CGFloat bottomSpacing = _accessory.bottomSpacing;
    NSArray *dataSource = graph.dataSource;
    BOOL isFilpped = _alignment == EMChartAlignmentRight;
    CGFloat lastLineValue = 0;
    if (isFilpped) {
        //右对齐时，K线需要逆向遍历绘制
        dataSource  = [[graph.dataSource reverseObjectEnumerator] allObjects];
    }
    
    for (NSInteger i = 0; i < dataSource.count; i++){
        data = (EMCandlestickGraphDataItem*)dataSource[i];
  
        CGFloat  yH = [EMConverterTool ptYWithMaxValueY:maxY
                                              minValueY:minY
                                                 valueY:data.high
                                             axisLength:rectHeight
                                             topSpacing:topSpacing
                                          bottomSpacing:bottomSpacing];
        CGFloat  yO = [EMConverterTool ptYWithMaxValueY:maxY
                                              minValueY:minY
                                                 valueY:data.open
                                             axisLength:rectHeight
                                             topSpacing:topSpacing
                                          bottomSpacing:bottomSpacing];
        
        CGFloat  yL = [EMConverterTool ptYWithMaxValueY:maxY
                                              minValueY:minY
                                                 valueY:data.low
                                             axisLength:rectHeight
                                             topSpacing:topSpacing
                                          bottomSpacing:bottomSpacing];
        
        CGFloat  yC = [EMConverterTool ptYWithMaxValueY:maxY
                                              minValueY:minY
                                                 valueY:data.close
                                             axisLength:rectHeight
                                             topSpacing:topSpacing
                                          bottomSpacing:bottomSpacing];
        
        // K线可以选择画图方向是从左到右还是从右到左
        CGFloat x = [EMConverterTool ptXWithIndexX:i
                                        axisLength:rectWidth
                                        scaleCount:graph.totalDataCount
                                       leftSpacing:_accessory.leftSpacing
                                      rightSpacing:_accessory.rightSpacing
                                           flipped:isFilpped];
        
        x = isFilpped ? (x - klineWidth * 0.5) : (x + klineWidth * 0.5);

        double gain = data.close - data.open;
        
        if (gain == 0) {
            // 记录昨收
            if (isFilpped) {
                if (i >= dataSource.count - 1) {
                    lastLineValue = graph.lastClosePrice;
                } else {
                    lastLineValue = ((EMCandlestickGraphDataItem*)dataSource[i + 1]).close;
                }
            } else {
                if (i == 0) {
                    lastLineValue = graph.lastClosePrice;
                } else {
                    lastLineValue = ((EMCandlestickGraphDataItem*)dataSource[i - 1]).close;
                }
            }
             gain = data.close - lastLineValue;
        }

        // 设置颜色
        NSColor *lineColor = [EMTypicalColor colorWithValue:gain glnColor:graph.glnColor];
        
        CGContextSetStrokeColorWithColor(ctx, (lineColor ?: [NSColor grayColor]).CGColor);
        CGContextSetFillColorWithColor(ctx, (lineColor ? : [NSColor grayColor]).CGColor);

        CGPoint aPoints[2];
        CGPoint ptFrom = CGPointZero, ptTo = CGPointZero;
        
        // 设置空心实心
        if (gain > DBL_EPSILON){
            // 上涨 (空心，无需填充矩形区域背景色)
            CGRect candlestickRect = CGRectMake(x - klineWidth * 0.5, yO, klineWidth, yC - yO);
            CGContextStrokeRect(ctx, candlestickRect);
        } else {
            // 下跌 (实心，需填充矩形区域背景色)
            CGRect candlestickRect = CGRectMake(x - klineWidth * 0.5, yC, klineWidth, yO - yC);
            CGContextFillRect(ctx, candlestickRect);
            CGContextStrokeRect(ctx, candlestickRect);
        }
        
        if (yO > yC) {
            ptFrom  = CGPointMake(x, yH);
            ptTo  = CGPointMake(x, yO);
            aPoints[0] = ptFrom;
            aPoints[1] = ptTo;
            CGContextAddLines(ctx, aPoints, 2);
            
            ptFrom  = CGPointMake(x, yL);
            ptTo  = CGPointMake(x, yC);
            aPoints[0] = ptFrom;
            aPoints[1] = ptTo;
            CGContextAddLines(ctx, aPoints, 2);
        } else {
            ptFrom  = CGPointMake(x, yH);
            ptTo  = CGPointMake(x, yC);
            aPoints[0] = ptFrom;
            aPoints[1] = ptTo;
            CGContextAddLines(ctx, aPoints, 2);
            
            ptFrom  = CGPointMake(x, yL);
            ptTo  = CGPointMake(x, yO);
            aPoints[0] = ptFrom;
            aPoints[1] = ptTo;
            CGContextAddLines(ctx, aPoints, 2);
        }
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
    }
}

#pragma mark - Graph

- (void)addGraph:(EMBaseGraph *)graph {
    if (nil == graph) {return;}
    if (nil == _graphs) {
        _graphs = [NSMutableArray new];
    }
    
    if (![[_graphs valueForKey:@"uuid"] containsObject:graph.uuid]) {
        [_graphs addObject:graph];
    }
    [self refresh];
}

- (void)removeGraph:(EMBaseGraph *)graph {
    if (nil == graph) {return;}
    if (nil == _graphs) {
        return;
    }
    if ([[_graphs valueForKey:@"uuid"] containsObject:graph.uuid]) {
        [_graphs removeObject:graph];
        [self refresh];
    }
}

- (void)removeAllGraphs {
    if (0 == _graphs.count) {
        return;
    }
    [_graphs removeAllObjects];
    [self refresh];
}

- (void)setGraphs:(NSArray <EMBaseGraph *> *)graphs {
    _graphs = [graphs mutableCopy];
    [self refresh];
}

- (void)setAccessory:(EMGraphLayerAccessory *)accessory {
    _accessory = accessory;
    [self refresh];
}

#pragma mark - Tools

- (void)clear {
    _yAxisLabels = nil;
    _xAxisLabels = nil;
    _latestDataPoint = NSZeroPoint;
    _renderingAreaRect = NSZeroRect;
    [self removeAllGraphs];
}

- (void)setYAxisLabels:(NSArray<EMAxisItem *> *)yAxisLabels {
    _yAxisLabels = yAxisLabels;
}

- (void)setRenderingAreaColor:(NSColor *)renderingAreaColor {
    _renderingAreaColor = renderingAreaColor;
}

-(void)setAlignment:(EMChartAlignment)alignment {
    _alignment = alignment;
}

- (void)setGridColor:(NSColor *)gridColor {
    _gridColor = gridColor;
}

@end
