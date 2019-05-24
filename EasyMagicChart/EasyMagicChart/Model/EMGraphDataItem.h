//
//  EMGraphDataItem.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMBaseGraphDataItem : NSObject
@end


@interface EMCandlestickGraphDataItem : EMBaseGraphDataItem
@property (nonatomic, assign) CGFloat high;///< 最高价
@property (nonatomic, assign) CGFloat low;///< 最低价
@property (nonatomic, assign) CGFloat open;///< 开盘价
@property (nonatomic, assign) CGFloat close;///< 收盘价
@end


@interface EMLineGraphDataItem : EMBaseGraphDataItem
@property (nonatomic, assign) CGFloat lineValue;///< 代表任意用于绘制普通线条的字段值，可以是最新价、均价等
@end


@interface EMBarGraphDataItem : EMBaseGraphDataItem
@property (nonatomic, assign) CGFloat lineValue;///< 代表任意用于绘制普通线条的字段值，可以是最新价、均价等
@property (nonatomic, assign) CGFloat close;///< 收盘价
@end


@interface EMRenderRegionGraphDataItem : EMBaseGraphDataItem
@property (nonatomic, assign) CGFloat high;///< 最高价
@property (nonatomic, assign) CGFloat low;///< 最低价
@end


@interface EMPieGraphDataItem : EMBaseGraphDataItem
@property (nonatomic, assign) CGFloat value;///< 值
@property (nonatomic, copy) NSString *name;///< 名称

@end


NS_ASSUME_NONNULL_END
