//
//  EMGraphLayerAccessory.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMGraphLayerAccessory.h"
#import "EMCommonlyUsedToolKit.h"

@implementation EMGraphLayerAccessory

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end
