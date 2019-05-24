//
//  EMChartMouseLayer.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  绘制鼠标十字线相关内容

#import <QuartzCore/QuartzCore.h>
#import "EMChartBaseLayer.h"

@class NSColor;
@class EMChartMouseLayerDot;
@class EMBaseGraph;

/// 游标文字
@interface EMChartMouseLayerTagText :NSObject
@property (nonatomic, copy) NSString *leftTagText;///< 左侧游标文本
@property (nonatomic, copy) NSString *rightTagText;///< 右侧游标文本
@property (nonatomic, copy) NSString *topTagText;///< 顶部游标文本
@property (nonatomic, copy) NSString *bottomTagText;///< 底部游标文本

@end

/// 圆点
@interface EMChartMouseLayerDot :NSObject
@property (nonatomic, assign) CGRect frame;///< 圆点所在矩形rect
@property (nonatomic, strong) NSColor *color;///< 圆点颜色
@property (nonatomic, assign, getter = isSolid) BOOL solid; ///< 是否实心
@property (nonatomic, strong) EMBaseGraph *graph;///<关键绘图信息

@end

@interface EMChartMouseLayer : EMChartBaseLayer
@property (nonatomic, assign) CGPoint mousePoint;///< 当前鼠标点
@property (nonatomic, strong) NSColor *crossLineColor;///< 十字线颜色
@property (nonatomic, assign) BOOL crossLineShow; ///< 十字线是否显示
@property (nonatomic, assign) CGRect graphFrame;///< 主图的frame

@property (nonatomic, strong) NSFont *tagFont;///< 文本字体
@property (nonatomic, strong) NSColor *tagTextColor;///< 游标文本色
@property (nonatomic, strong) NSColor *tagBGColor;///< 游标背景色
@property (nonatomic, strong) NSColor *tagBorderColor;///< 游标边框色

@property (nonatomic, strong) EMChartMouseLayerTagText *tagText;///< 游标需要显示的文字

@property (nonatomic, assign) CGRect renderingAreaRect;///< 需要渲染的区域
@property (nonatomic, strong) NSColor *renderingAreaColor;///< 渲染区域颜色

@property (nonatomic, copy) NSArray <EMChartMouseLayerDot*> *dots;///< 圆点

@end

