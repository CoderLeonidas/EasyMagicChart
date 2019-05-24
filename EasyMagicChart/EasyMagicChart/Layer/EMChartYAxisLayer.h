//
//  EMChartYAxisLayer.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  绘制Y轴刻度内容

#import <QuartzCore/QuartzCore.h>
#import "EMChartBaseLayer.h"

@class NSColor;
@class EMAxisItem;
typedef enum : NSUInteger {
    EMChartYAxisLayerLeft,
    EMChartYAxisLayerRight
} EMChartYAxisLayerType;

@interface EMChartYAxisLayer : EMChartBaseLayer
@property (nonatomic, strong) NSColor *textColor; ///< 坐标轴默认的文本颜色
@property (nonatomic, strong) NSFont *font; ///< 坐标点文本字体
@property (nonatomic, copy) NSArray <EMAxisItem *> *axisLabels;  ///< 坐标点文本及其位置XO

+ (instancetype)yAxisLayerWithType:(EMChartYAxisLayerType)type;

- (instancetype)initWithType:(EMChartYAxisLayerType)type;

@end
