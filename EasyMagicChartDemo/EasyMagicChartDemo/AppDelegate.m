//
//  AppDelegate.m
//  EasyMagicChartDemo
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 Leonidas. All rights reserved.
//

#import "AppDelegate.h"
#import <EasyMagicChart/EasyMagicChart.h>

@interface AppDelegate () <NSTableViewDelegate, NSTableViewDataSource, EMTrendChartViewDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tv;

@property (weak) IBOutlet NSView *containerViewR;

@property (nonatomic, strong) EMTrendChartView *tcv;

@end

@implementation AppDelegate {
    NSArray <NSNumber *>*_ltvDataSource;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupTrendChartView];
    _ltvDataSource = @[@(EMGraphTypeCustomChart),
                       @(EMGraphTypeLineChart),
                       @(EMGraphTypeCandlestickChart),
                       @(EMGraphTypeBarChart),
                       @(EMGraphTypeRenderRegionChart),
                       @(EMGraphTypeParallelLine),
                       @(EMGraphTypePieChart),
                       @(EMGraphTypeText),
                       @(EMGraphTypeImage)];
    [_tv reloadData];
}

- (void)setupTrendChartView {
    EMChartLayerOption option = (EMChartLayerOptionGraph | EMChartLayerOptionMouse | EMChartLayerOptionXAxis | EMChartLayerOptionYAxisLeft | EMChartLayerOptionYAxisRight);
    _tcv = [[EMTrendChartView alloc] initWithOption:option];
    _tcv.delegate = self;
    _tcv.crossLineLimited = YES;
    _tcv.arrowLeftAndRight = YES;
    _tcv.scalable = YES;
    _tcv.totalDataCount = 100;
    EMGraphLayerAccessory *accessory = [EMGraphLayerAccessory new];
    accessory.topSpacing = \
    accessory.bottomSpacing = \
    accessory.leftSpacing = \
    accessory.rightSpacing = 10;
    [_tcv setAccessory:accessory];
    _tcv.frame = self.containerViewR.bounds;
    _tcv.autoresizingMask = 1|2|4|8|16|32;
    [self.containerViewR addSubview:_tcv];
    
}

#pragma mark -NSTableViewDataSource

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 25;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextField *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (nil == view) {
        view = [NSTextField new];
        view.identifier = tableColumn.identifier;
        view.editable = NO;
        view.autoresizingMask = 1|2|4|8|16|32;
    }
    view.stringValue = [self stringWithType:_ltvDataSource[row].integerValue];
    return view;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _ltvDataSource.count;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tv = (NSTableView *)notification.object;
    NSInteger selectedRow = tv.selectedRow;
    if (selectedRow < 0) {
        return;
    }
    EMGraphType graphType = _ltvDataSource[selectedRow].integerValue;
    EMBaseGraph *graph = [self graphWithType:graphType];
    if (graph){
        [_tcv setGraphs:@[graph]];
    }
}


#pragma mark -EMTrendChartViewDelegate

- (void)view:(EMTrendChartView *)view mouseMovedToIndex:(NSInteger)index {
    
}

- (void)view:(EMTrendChartView *)view mouseDoubleClicked:(NSEvent *)event {
    
}
- (NSArray <EMAxisItem *>*)xAxisItemsForView:(EMTrendChartView *)view {
    EMLyAxisParamX *paramX = [[EMLyAxisParamX alloc] initWithXAxisItemCount:12
                                                                 xAxisWidth:_tcv.xAxisWidth
                                                                  xMinValue:0
                                                                  xMaxValue:0
                                                               leftSpaceing:0
                                                              rightSpaceing:0
                                                                       font:[NSFont systemFontOfSize:0]];
    return [[EMAxisHelper new] xAxisItemsWithParam:paramX];
}

- (NSArray <EMAxisItem *>*)yAxisItemsForView:(EMTrendChartView *)view isLeft:(BOOL)isLeft {
    EMLyAxisParamY *paramY = [[EMLyAxisParamY alloc] initWithYAxisItemCount:12
                                                                yAxisHeight:_tcv.yAxisHeight
                                                                  yMinValue:-200
                                                                  yMaxValue:200
                                                                topSpaceing:0
                                                             bottomSpaceing:0
                                                                       font:[NSFont systemFontOfSize:0]];
    paramY.isLeft = isLeft;
    paramY.yAxisWidth = NSMinX(_tcv.validXAxisFrame);
    paramY.formattedStringBlock = ^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%.2f%%", value];
    };
    NSArray <EMAxisItem *>*axixItems = [[EMAxisHelper new] yAxisItemsWithParam:paramY];
    
    return axixItems;
}

#pragma mark -Tool

- (NSArray <EMBaseGraph *>*)graphsWithName:(NSString *)graphName {
    NSArray *graphs = [NSArray new];
    
    return graphs;
}

- (NSString*)stringWithType:(EMGraphType)type {
    switch (type) {
        case EMGraphTypeCustomChart:
            return @"EMGraphTypeCustomChart";
        case EMGraphTypeLineChart:
            return @"EMGraphTypeLineChart";
        case EMGraphTypeCandlestickChart:
            return @"EMGraphTypeCandlestickChart";
        case EMGraphTypeBarChart:
            return @"EMGraphTypeBarChart";
        case EMGraphTypeRenderRegionChart:
            return @"EMGraphTypeRenderRegionChart";
        case EMGraphTypeParallelLine:
            return @"EMGraphTypeParallelLine";
        case EMGraphTypePieChart:
            return @"EMGraphTypePieChart";
        case EMGraphTypeText:
            return @"EMGraphTypeText";
        case EMGraphTypeImage:
            return @"EMGraphTypeImage";
        default:
            return nil;
    }
}

#pragma mark -Graphs

- (EMBaseGraph *)graphWithType:(EMGraphType)type {
    EMBaseGraph *graph = nil;
    switch (type) {
        case EMGraphTypeCandlestickChart:
            graph = [self CandlestickChart];
            break;
            
        default:
            break;
    }
    return graph;
}

- (EMBaseGraph *)CandlestickChart {
    EMCandlestickGraph *graph = [EMCandlestickGraph new];
    graph.graphType = EMGraphTypeCandlestickChart;
    graph.extremumY = [EMExtremum extremumWithMax:200 min:-200];
    graph.uuid = [EMControlTool uuid];
    graph.identifier = @"EMCandlestickGraph";
    graph.lastClosePrice = 20;
    graph.glnColor = [EMTypicalColor sharedTypicalColor].glnColor;
    graph.totalDataCount = _tcv.totalDataCount;
    NSMutableArray <EMBaseGraphDataItem*> *dataSource = [NSMutableArray new];
    CGFloat lastClosePrice = graph.lastClosePrice;
    int sign ;
    for (NSInteger i = 0; i < graph.totalDataCount; i++){
        EMCandlestickGraphDataItem * item= [EMCandlestickGraphDataItem new];
        sign = [EMControlTool randomSigns];
        item.high = lastClosePrice * (arc4random() % 10) * sign / 100 + lastClosePrice;
        item.low = lastClosePrice * (arc4random() % 10) * sign / 100 + lastClosePrice;
        item.open = lastClosePrice * (arc4random() % 10) * sign / 100 + lastClosePrice;
        item.close = lastClosePrice * (arc4random() % 10) * sign / 100 + lastClosePrice;
        
        [dataSource addObject:item];
        lastClosePrice = item.close;
    }
    graph.dataSource = dataSource;
    
    return graph;
}



@end
