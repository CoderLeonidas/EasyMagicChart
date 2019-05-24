//
//  EMChartBaseLayer.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import "EMChartBaseLayer.h"
#import <AppKit/NSScreen.h>

@implementation EMChartBaseLayer

- (instancetype)init {
    if (self = [super init]) {
        self.contentsScale = [NSScreen mainScreen].backingScaleFactor;
    }
    return self;
}

- (void)clear {}

- (void)refresh {
    [self setNeedsDisplay];
}

@end
