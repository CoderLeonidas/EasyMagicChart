//
//  EMGraphDataItem.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMGraphDataItem.h"
#import "EMCommonlyUsedToolKit.h"

@implementation EMBaseGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end


@implementation EMCandlestickGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end


@implementation EMLineGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end


@implementation EMBarGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end


@implementation EMRenderRegionGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}
@end

@implementation EMPieGraphDataItem
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end
