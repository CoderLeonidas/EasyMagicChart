//
//  EMTrendChartView.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EMBaseGraph;
@class EMAxisItem;
@class EMTrendChartView;
@class EMGraphLayerAccessory;

@protocol EMTrendChartViewDelegate <NSObject>
@optional
/**
 鼠标移动到了数据对应下标的位置，通知代理
 */
- (void)view:(EMTrendChartView *)view mouseMovedToIndex:(NSInteger)index;

/**
 鼠标双击视图时，通知代理
 */
- (void)view:(EMTrendChartView *)view mouseDoubleClicked:(NSEvent *)event;

- (NSInteger)numberOfCurrentDataInView:(EMTrendChartView *)view;

/**
 返回x轴标签对象
 */
- (NSArray <EMAxisItem *>*)xAxisItemsForView:(EMTrendChartView *)view;

/**
 返回y轴标签对象
 */
- (NSArray <EMAxisItem *>*)yAxisItemsForView:(EMTrendChartView *)view isLeft:(BOOL)isLeft;

@end


typedef NS_OPTIONS(NSUInteger, EMChartLayerOption) {
    EMChartLayerOptionNone       = 1 << 0, ///< 无layer
    EMChartLayerOptionGraph      = 1 << 1, ///< 有主图layer
    EMChartLayerOptionMouse      = 1 << 2, ///< 有鼠标操作层layer
    EMChartLayerOptionYAxisLeft  = 1 << 3, ///< 有左侧纵轴layer
    EMChartLayerOptionYAxisRight = 1 << 4, ///< 有右侧纵轴layer
    EMChartLayerOptionXAxis      = 1 << 5, ///< 有横轴layer
};

@interface EMTrendChartView : NSView
@property (nonatomic, weak) id <EMTrendChartViewDelegate> delegate;

@property (nonatomic, assign, readonly) CGFloat xAxisWidth; ///< X轴宽度
@property (nonatomic, assign, readonly) CGFloat yAxisHeight;///< Y轴长度

@property (nonatomic, assign, readonly) NSRect validXAxisFrame;

@property (nonatomic, assign, readonly) BOOL crossLineShow; ///< 当前是否显示了十字线

@property (nonatomic, assign, getter=isCrossLineLimited) BOOL crossLineLimited;///< 十字线是否受限，表示十字线是否需要限制在图形的当前范围，即活动范围为图形x轴上的的起点和末端

@property (nonatomic, assign) BOOL arrowLeftAndRight; ///< 是否支持方向键左右移动改变十字线位置
@property (nonatomic, assign) BOOL scalable; ///< 是否支持缩放

@property (nonatomic, assign) NSUInteger totalDataCount; ///< 刻度总长
@property (nonatomic, copy) NSArray *dataSource; ///< 当前数据


@property (nonatomic, strong) NSFont *axisItemFont;


- (instancetype)initWithOption:(EMChartLayerOption)option;

/**
 设置绘图对象数组，会刷新所有图层
 */
- (void)setGraphs:(NSArray <EMBaseGraph *> *)graphs;

/**
 添加单个绘图对象，会刷新所有图层
 */
- (void)addGraph:(EMBaseGraph *)graph;


- (void)setAccessory:(EMGraphLayerAccessory *)accessory;

/**
 刷新所有图层
 */
- (void)refresh;

/**
 清理所有图层以及缓存的绘图对象数据
 */
- (void)clear;

/**
 换肤
 */
- (void)appSkinStyleHasChanged;

/**
 重新布局各个layer
 */
- (void)layoutLayers;

/**
 更新所有graph的最大最小Y值，会更新Y轴并刷新所有图层
 */
- (void)updateGraphsMaxY:(CGFloat)maxY minY:(CGFloat)minY;

@end
