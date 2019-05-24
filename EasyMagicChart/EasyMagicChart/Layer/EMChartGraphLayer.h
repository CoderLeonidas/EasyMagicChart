//
//  EMChartGraphLayer.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  绘制主图

#import <QuartzCore/QuartzCore.h>
#import "EMAxisHelper.h"
#import "EMGraph.h"
#import "EMChartBaseLayer.h"
#import "EMGraphLayerAccessory.h"

@class NSColor;

///< 图表对齐方式
typedef enum : NSUInteger {
    EMChartAlignmentLeft,  ///< 左对齐，最左侧数据的图形贴近左边
    EMChartAlignmentRight, ///< 右对齐，最右侧数据的图形贴近右边
} EMChartAlignment;

@interface EMChartGraphLayer : EMChartBaseLayer

@property (nonatomic, strong) NSColor *gridColor;///< 网格线颜色
@property (nonatomic, copy) NSArray <EMAxisItem *> *yAxisLabels;
@property (nonatomic, copy) NSArray <EMAxisItem *> *xAxisLabels;
@property (nonatomic, assign) NSUInteger gridColumn;///< 网格列数

@property (nonatomic, assign) NSUInteger gridRow;///< 网格行数
@property (nonatomic, assign, readonly) NSPoint latestDataPoint;
@property (nonatomic, assign) BOOL hasMiddleLine;///< 是否有中线
//@property (nonatomic, strong) NSColor *startColor;///< 渐变起始颜色
//@property (nonatomic, strong) NSColor *endColor;///< 渐变终点颜色
@property (nonatomic, assign) CGRect renderingAreaRect;///< 需要渲染的区域
@property (nonatomic, strong) NSColor *renderingAreaColor;///< 渲染区域颜色
@property (nonatomic, assign) EMChartAlignment alignment; ///< 图形对齐方式
@property (nonatomic, strong) EMGraphLayerAccessory *accessory; ///< 图层附件属性


///< warning: 所有graph添加时要注意添加顺序，因为graph之间会相互覆盖，比如：如果先画线型graph，再画区域型graoh，则区域渲染后会覆盖线型graph，导致看不清线型
/**
 添加一个图形
 */
- (void)addGraph:(EMBaseGraph *)graph;

/**
 设置一组图形
 */
- (void)setGraphs:(NSArray <EMBaseGraph *> *)graphs;

@end
