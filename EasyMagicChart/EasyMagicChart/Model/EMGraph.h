//
//  EMGraph.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/302.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMGraphDataItem.h"
#import "EMExtremum.h"

#import "EMTypicalColor.h"


// 图形类型
typedef NS_ENUM(NSUInteger, EMGraphType) {
    EMGraphTypeCustomChart, // 自定义图形
    EMGraphTypeLineChart, // 普通线形图，Y轴最大最小值确定Y轴范围，原点为最小值位置
    EMGraphTypeCandlestickChart, // 蜡烛图
    EMGraphTypeBarChart, // 直方图
    EMGraphTypeRenderRegionChart, // 渲染区域图
    EMGraphTypeParallelLine, // 平行线
    EMGraphTypePieChart, // 扇形图
    EMGraphTypeText, // 文本
    EMGraphTypeImage, // 图片
};

@interface EMBaseGraph : NSObject
@property (nonatomic, assign) EMGraphType graphType;///< 图形类型
@property (nonatomic, strong) EMExtremum *extremumY; ///< y轴极值
@property (nonatomic, copy) NSString *identifier; ///< 标识，可以用此为graph对象取名
@property (nonatomic, copy) NSString *uuid; ///< 通用唯一识别码，用作key以区分不同的graph对象

@end


@interface EMLineGraph : EMBaseGraph
@property (nonatomic, assign) CGFloat lastClosePrice;///< 昨收价
@property (nonatomic, strong) NSColor *color; ///< 线条颜色
@property (nonatomic, assign) BOOL hasGradient;///< 是否有渐变区域
@property (nonatomic, strong) NSColor *gradientStartColor;
@property (nonatomic, strong) NSColor *gradientEndColor;
@property (nonatomic, copy) NSArray <EMBaseGraphDataItem*> *dataSource;///< 数据源(其数据长度不一定等于totalDataCount， totalDataCount是固定的，而数据源长度是[0,totalDataCount]区间)
@property (nonatomic, assign) NSUInteger totalDataCount;///< 总数据长度

@end

@interface EMParallelLineGraph : EMBaseGraph
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) NSColor *color;

@end


@interface EMCandlestickGraph : EMBaseGraph
@property (nonatomic, assign) CGFloat lastClosePrice;///< 昨收价
@property (nonatomic, strong) EMGLNColor *glnColor; ///< 涨跌停颜色
@property (nonatomic, copy) NSArray <EMBaseGraphDataItem*> *dataSource;///< 数据源(其数据长度不一定等于totalDataCount， totalDataCount是固定的，而数据源长度是[0,totalDataCount]区间)
@property (nonatomic, assign) NSUInteger totalDataCount;///< 总数据长度

@end

@interface EMBarGraph : EMBaseGraph
@property (nonatomic, assign) CGFloat lastClosePrice;///< 昨收价
@property (nonatomic, strong) EMGLNColor *glnColor; ///< 涨跌停颜色
@property (nonatomic, copy) NSArray <EMBaseGraphDataItem*> *dataSource;///< 数据源(其数据长度不一定等于totalDataCount， totalDataCount是固定的，而数据源长度是[0,totalDataCount]区间)
@property (nonatomic, assign) NSUInteger totalDataCount;///< 总数据长度

@end

@interface EMRenderRegionGraph : EMBaseGraph
@property (nonatomic, assign) CGFloat lastClosePrice;///< 昨收价
@property (nonatomic, strong) EMGLNColor *glnColor; ///< 涨跌停颜色
@property (nonatomic, copy) NSArray <EMBaseGraphDataItem*> *dataSource;///< 数据源(其数据长度不一定等于totalDataCount， totalDataCount是固定的，而数据源长度是[0,totalDataCount]区间)
@property (nonatomic, assign) NSUInteger totalDataCount;///< 总数据长度

@end


@interface EMPieGraph : EMBaseGraph
@property (nonatomic, strong) NSColor *color;

@property (nonatomic, copy) NSArray <EMPieGraphDataItem*> *dataSource;

@end







