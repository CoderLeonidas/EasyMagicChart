//
//  EMGraphicsAlgorithm.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMGraphicsAlgorithm.h"

@implementation EMGraphicsAlgorithm

+ (instancetype)algorithmWithGraphType:(EMGraphType)type {
    EMGraphicsAlgorithm *algorithm = [EMGraphicsAlgorithm new];
 
    return algorithm;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _algorithmSelecotr = @selector(drawWithGraph:type:);
    }
    return self;
}

- (void)drawWithGraph:(EMBaseGraph *)graph type:(EMGraphType)type {
    
}

@end
