//
//  EMTrendChartView.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import "EMTrendChartView.h"
#import <Carbon/Carbon.h>
#import "NSView+Geometry.h"
#import "EMCommonlyUsedToolKit.h"
#import "EMChartYAxisLayer.h"
#import "EMChartXAxisLayer.h"
#import "EMChartGraphLayer.h"
#import "EMChartMouseLayer.h"
#import "EMAxisHelper.h"

#import "EMControlTool.h"
#import "EMConverterTool.h"
#import "EMTypicalColor.h"



static const CGFloat LeftMargin = 60.0;
static const CGFloat BottomMargin = 30.0;
static const CGFloat RightMargin = 5.0;

@interface EMTrendChartView () <CALayerDelegate> {
    EMChartYAxisLayer *_yLeftAxisLayer;
    EMChartYAxisLayer *_yRightAxisLayer;
    EMChartXAxisLayer *_xAxisLayer;
    EMChartGraphLayer *_graphLayer;
    EMChartMouseLayer *_mouseLayer;
    
    NSTrackingArea *_trackingArea;
    NSMutableArray <EMChartBaseLayer *> *_subLayers;

    NSMutableArray <EMBaseGraph *> *_internalGraphs;
    EMTypicalColor *_typicalColor;
}

@end

@implementation EMTrendChartView

#pragma mark - Life Loop

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self addTrackingArea];
        [self addNotification];
        [self initDatas];
        [self setColors];
        
        EMChartLayerOption option = EMChartLayerOptionGraph | EMChartLayerOptionMouse | EMChartLayerOptionXAxis | EMChartLayerOptionYAxisLeft;
        [self setupSubLayersWithOption:option];
        
        [self layoutLayers];
        
        [self addGustureRecognizers];
    }
    return self;
}




- (void)addGustureRecognizers {
    NSPressGestureRecognizer *pressGR = [[NSPressGestureRecognizer alloc] initWithTarget:self action:@selector(press)];
    
    NSPanGestureRecognizer *panGR = [[NSPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
    
    NSMagnificationGestureRecognizer *magnificationGR = [[NSMagnificationGestureRecognizer alloc] initWithTarget:self action:@selector(magnification)];
    
    self.gestureRecognizers = @[pressGR, panGR, magnificationGR];
}

- (void)press{
    
}

- (void)pan {
    
}

- (void)magnification {
    
}

- (instancetype)initWithOption:(EMChartLayerOption)option {
    if (self = [super init]) {
        [self addTrackingArea];
        [self addNotification];
        [self initDatas];
        [self setColors];
        
        [self setupSubLayersWithOption:option];
        [self layoutLayers];


    }
    return self;
}

- (void)initDatas {
    _internalGraphs = [NSMutableArray new];
    
    _crossLineLimited = NO;
    
    self.wantsLayer = YES;
}


- (void)setupSubLayersWithOption:(EMChartLayerOption)option {
    if (option & EMChartLayerOptionNone) {
        return;
    }
    _subLayers = [NSMutableArray new];

    if (option & EMChartLayerOptionGraph) {
        _graphLayer = [EMChartGraphLayer new];
        _graphLayer.needsDisplayOnBoundsChange = YES;
        _graphLayer.delegate = self;
        [_subLayers addObject:_graphLayer];
    }
    
    if (option & EMChartLayerOptionMouse) {
        _mouseLayer = [EMChartMouseLayer new];
        _mouseLayer.needsDisplayOnBoundsChange = YES;
        _mouseLayer.delegate = self;
        [_subLayers addObject:_mouseLayer];
    }
    
    if (option & EMChartLayerOptionXAxis) {
        _xAxisLayer = [EMChartXAxisLayer new];
        _xAxisLayer.needsDisplayOnBoundsChange = YES;
        _xAxisLayer.delegate = self;
        [_subLayers addObject:_xAxisLayer];
    }
    
    if (option & EMChartLayerOptionYAxisLeft) {
        _yLeftAxisLayer = [EMChartYAxisLayer yAxisLayerWithType:EMChartYAxisLayerLeft];
        _yLeftAxisLayer.needsDisplayOnBoundsChange = YES;
        _yLeftAxisLayer.delegate = self;
        [_subLayers addObject:_yLeftAxisLayer];
    }
    
    if (option & EMChartLayerOptionYAxisRight) {
        _yRightAxisLayer = [EMChartYAxisLayer yAxisLayerWithType:EMChartYAxisLayerRight];
        _yRightAxisLayer.needsDisplayOnBoundsChange = YES;
        _yRightAxisLayer.delegate = self;
        [_subLayers addObject:_yRightAxisLayer];
    }
    
    [self.layer setSublayers:_subLayers];
}

- (void)dealloc {
    [self removeTrackingArea:_trackingArea];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    for (NSGestureRecognizer *gr in self.gestureRecognizers) {
        
        [self removeGestureRecognizer:gr];
    }
}

- (void)swipeWithEvent:(NSEvent *)event {
    
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

#pragma mark - Notification & Tracking Area

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutLayers) name:NSViewFrameDidChangeNotification object:self];
}

- (void)addTrackingArea {
    NSTrackingAreaOptions options = (NSTrackingMouseMoved| NSTrackingActiveAlways| NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited);
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                 options:options
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)updateTrackingAreas {
    [self removeTrackingArea:_trackingArea];
    [self addTrackingArea];
    [super updateTrackingAreas];
}

#pragma mark - Layout

- (void)layoutLayers {
    CGFloat height = NSHeight(self.frame);
    CGFloat width = NSWidth(self.frame);
    _yLeftAxisLayer.frame = CGRectMake(0, BottomMargin, LeftMargin, height- BottomMargin);
    _xAxisLayer.frame = CGRectMake(0, 0, width, BottomMargin);
    _graphLayer.frame = CGRectMake(LeftMargin, BottomMargin, width - LeftMargin- RightMargin, height - BottomMargin);
    _mouseLayer.frame = _graphLayer.frame;
    _mouseLayer.graphFrame = _mouseLayer.bounds;

    [self setAxisParams];
    [self refresh];
}

#pragma mark - Mouse Events

- (void)mouseMoved:(NSEvent *)event {
    if (!_mouseLayer.crossLineShow) {
        return;
    }
    
    CGPoint point = [self convertPoint:event.locationInWindow
                              fromView:nil];
     point = [self.layer convertPoint:point toLayer:_mouseLayer];

    [self crossLineMoveToPoint:point];
    
    [super mouseMoved:event];
}

- (void)mouseExited:(NSEvent *)event {
    if (_mouseLayer.crossLineShow) {
        _mouseLayer.mousePoint = NSZeroPoint;
    }
    [super mouseExited:event];
}

- (void)mouseDown:(NSEvent *)event {
    if (event.clickCount == 1) {return;}
    
    if ([self.delegate respondsToSelector:@selector(view:mouseDoubleClicked:)]) {
        [self.delegate view:self mouseDoubleClicked:event];
    }
    
    _mouseLayer.crossLineShow = !_mouseLayer.crossLineShow;
    NSInteger idx = 0;
    if (!_mouseLayer.crossLineShow) {
        idx = (NSInteger)_dataSource.count - 1;
        
        if ([self.delegate respondsToSelector:@selector(numberOfCurrentDataInView:)]) {
            NSUInteger numberOfCurrentData = [self.delegate numberOfCurrentDataInView:self];
            idx = (NSInteger)numberOfCurrentData - 1;

        }
  
    } else {
        CGPoint point = [_mouseLayer convertPoint:event.locationInWindow fromLayer:nil];
        _mouseLayer.mousePoint = point;
        idx = [EMConverterTool indexXFromPointX:point.x
                                      axisLength:CGRectGetWidth(_graphLayer.bounds)
                                      scaleCount:_totalDataCount];
    }
    if ([self.delegate respondsToSelector:@selector(view:mouseMovedToIndex:)]) {
        [self.delegate view:self mouseMovedToIndex:idx];
    }
    [super mouseDown: event];
}

- (void)keyDown:(NSEvent *)event {
    if (nil == event) {
        return;
    }
    switch (event.keyCode) {
            //左右移动光标
        case kVK_ANSI_Keypad4:
        case kVK_ANSI_Keypad6:
        case kVK_LeftArrow:
        case kVK_RightArrow: {
            
            if (!self.crossLineShow || !self.arrowLeftAndRight) {
                return;
            }
            
            NSPoint mousePoint = _mouseLayer.mousePoint;
            CGFloat mousePtX = _mouseLayer.mousePoint.x;
            CGFloat deltaX = [EMConverterTool deltaWithScaleCount:_totalDataCount
                                                       axisLength:NSWidth(_xAxisLayer.frame)];
            if (kVK_ANSI_Keypad4 == event.keyCode ||
                kVK_LeftArrow == event.keyCode) {
                mousePtX -= deltaX;
                mousePtX = MAX(NSMinX(_xAxisLayer.frame), mousePtX);
            } else if (kVK_ANSI_Keypad6 == event.keyCode ||
                       kVK_RightArrow == event.keyCode) {
                mousePtX += deltaX;
                mousePtX = MIN(NSMaxX(_xAxisLayer.frame), mousePtX);
            }
            mousePoint.x = mousePtX;
            
            [self crossLineMoveToPoint:mousePoint];
        }
            
        case kVK_ANSI_Keypad8:
        case kVK_ANSI_Keypad2:
        case kVK_DownArrow:
        case kVK_UpArrow:{
            
        }
            
        default:
            return;
    }
}

- (void)crossLineMoveToPoint:(NSPoint)point {
    if (!NSPointInRect(point, _mouseLayer.bounds)){
        _mouseLayer.mousePoint = CGPointZero;
        return;
    }
    NSUInteger limitRangeIndex = 0;
    
    if (_crossLineLimited) {
        if ([self.delegate respondsToSelector:@selector(numberOfCurrentDataInView:)]) {
            NSUInteger numberOfCurrentData = [self.delegate numberOfCurrentDataInView:self];
            
            limitRangeIndex = MAX(limitRangeIndex, numberOfCurrentData);
        }
    } else {
        limitRangeIndex = _totalDataCount; ///< 视图中数据的总长度(个数)
    }
    limitRangeIndex--;
    NSInteger idx = [EMConverterTool indexXFromPointX:point.x
                                            axisLength:CGRectGetWidth(_graphLayer.bounds)
                                            scaleCount:_totalDataCount];
    if (idx < 0) {
        return;
    } else if (idx > limitRangeIndex) {
        idx = limitRangeIndex;
        point.x = [EMConverterTool ptXWithIndexX:limitRangeIndex axisLength:CGRectGetWidth(_graphLayer.bounds) scaleCount:_totalDataCount];
    }
    
    _mouseLayer.mousePoint = point;
    
    if ([self.delegate respondsToSelector:@selector(view:mouseMovedToIndex:)]) {
        [self.delegate view:self mouseMovedToIndex:idx];
    }
}

#pragma mark - appSkinStyleHasChanged

- (void)appSkinStyleHasChanged {
    [self setColors];
    [self refresh];
}

- (void)setColors {
    _typicalColor = [EMTypicalColor sharedTypicalColor];
    [EMControlTool setBGColor:_typicalColor.backgroundColor toView:self];
    
    _graphLayer.backgroundColor = \
    _xAxisLayer.backgroundColor = \
    _yLeftAxisLayer.backgroundColor = _typicalColor.backgroundColor.CGColor;

    _graphLayer.gridColor = _typicalColor.gridColor;
    _xAxisLayer.textColor =\
    _yLeftAxisLayer.textColor = _typicalColor.textColor;
    _mouseLayer.crossLineColor = _typicalColor.crossLineColor;
}

#pragma mark - Getter

- (CGFloat)xAxisWidth {
    return CGRectGetWidth(_xAxisLayer.frame);
}

- (CGFloat)yAxisHeight {
    return CGRectGetHeight(_yLeftAxisLayer.frame);
}

- (BOOL)crossLineShow {
    return _mouseLayer.crossLineShow;
}

- (NSRect)validXAxisFrame {
    NSRect rect = _xAxisLayer.frame;
    rect.origin.x = NSMaxX(_yLeftAxisLayer.frame);
    if (nil != _yLeftAxisLayer) {
        rect.size.width -= (NSMaxX(_yLeftAxisLayer.frame) - NSMinX(_xAxisLayer.frame));
    }
    if (nil != _yRightAxisLayer) {
        rect.size.width -= (NSMaxX(_yRightAxisLayer.frame) - NSMaxX(_xAxisLayer.frame));
    }
    return rect;
}

#pragma mark - Setter

- (void)setAxisParams {
    [self setYAxisParams];
    [self setXAxisParams];
 }

- (void)setYAxisParams {
    if ([self.delegate respondsToSelector:@selector(yAxisItemsForView:isLeft:)]) {
        _graphLayer.yAxisLabels = \
        _yLeftAxisLayer.axisLabels = [self.delegate yAxisItemsForView:self isLeft:YES];
    }
}

- (void)setXAxisParams {
    if ([self.delegate respondsToSelector:@selector(xAxisItemsForView:)]) {
        NSArray <EMAxisItem *>*xAxisLabels =  [self.delegate xAxisItemsForView:self];
        _xAxisLayer.axisLabels = [[NSArray alloc] initWithArray:xAxisLabels copyItems:YES];

        CGFloat delta = NSMinX(_xAxisLayer.frame) - NSMinX(_graphLayer.frame);
        if (delta <= DBL_EPSILON) {
            for (NSInteger i = 0; i < xAxisLabels.count; i++) {
                xAxisLabels[i].position += delta;
            }
        }
        _graphLayer.xAxisLabels = [[NSArray alloc] initWithArray:xAxisLabels copyItems:YES];
    }
}

- (void)setGraphs:(NSMutableArray <EMBaseGraph*> *)graphs {
    [_internalGraphs removeAllObjects];
    _internalGraphs = [graphs mutableCopy];
    [_graphLayer setGraphs:_internalGraphs];

    [self setAxisParams];
    [self refresh];
}

- (void)setAccessory:(EMGraphLayerAccessory *)accessory {
    _graphLayer.accessory = accessory;
    [_graphLayer refresh];
}

- (void)setAxisItemFont:(NSFont *)axisItemFont {
    _yLeftAxisLayer.font = axisItemFont;
    _yRightAxisLayer.font = axisItemFont;
    _xAxisLayer.font = axisItemFont;
}

- (void)addGraph:(EMBaseGraph *)graph {
    if (nil == graph) {return;};
    if (![[_internalGraphs valueForKey:@"uuid"] containsObject:graph.uuid]) {
        [_internalGraphs addObject:graph];
    }
    [_graphLayer addGraph:graph];
    [self setAxisParams];
    [self refresh];
}

- (void)refresh {
    for (EMChartBaseLayer *layer in _subLayers) {
        [layer refresh];
    }
}

- (void)clear {
    for (EMChartBaseLayer *layer in _subLayers) {
        [layer clear];
    }
    [_internalGraphs removeAllObjects];
}

- (void)updateGraphsMaxY:(CGFloat)maxY minY:(CGFloat)minY {
    if (0 == _internalGraphs.count ) {return;}
    // 更新所有相似线涨幅曲线graph的Y轴最值(即最大最小涨幅)，便于在统一Y轴体系下绘图
    if ([[_internalGraphs[0] valueForKeyPath:@"extremumY.max"] floatValue] != maxY ||
        [[_internalGraphs[0] valueForKeyPath:@"extremumY.min"] floatValue] != minY) {
        [_internalGraphs setValue:@(maxY) forKeyPath:@"extremumY.max"];
        [_internalGraphs setValue:@(minY) forKeyPath:@"extremumY.min"];

        [_graphLayer setGraphs:_internalGraphs];
        [self setYAxisParams];
        [self refresh];
    }
}

- (void)setTotalDataCount:(NSUInteger)totalDataCount {
    if (_totalDataCount == totalDataCount) {
        return;
    }
    _totalDataCount = totalDataCount;
    [self setXAxisParams];
    [self refresh];
}

@end
