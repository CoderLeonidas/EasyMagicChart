//
//  EMGraph.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/302.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import "EMGraph.h"
#import "EMCommonlyUsedToolKit.h"

@implementation EMBaseGraph
- (instancetype)init {
    self = [super init];
    if (self) {
        _extremumY = [EMExtremum extremumWithMax:-MAXFLOAT min:MAXFLOAT];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@implementation EMParallelLineGraph
@end

@implementation EMLineGraph
@end

@implementation EMCandlestickGraph
@end

@implementation EMBarGraph
@end

@implementation EMRenderRegionGraph
@end

@implementation EMPieGraph
@end

