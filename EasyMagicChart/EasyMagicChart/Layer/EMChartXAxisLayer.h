//
//  EMChartXAxisLayer.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  绘制X轴刻度内容

#import <QuartzCore/QuartzCore.h>
#import "EMChartBaseLayer.h"


@class EMAxisItem;
@class NSColor;

@interface EMChartXAxisLayer : EMChartBaseLayer
@property (nonatomic,strong) NSColor* textColor;
@property (nonatomic,strong) NSFont *font;
@property (nonatomic,copy) NSArray <EMAxisItem *> *axisLabels;

@end
