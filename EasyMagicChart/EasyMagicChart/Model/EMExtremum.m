//
//  EMExtremum.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMExtremum.h"
#import "EMCommonlyUsedToolKit.h"

@implementation EMExtremum
@synthesize max = _max;
@synthesize min = _min;

+ (instancetype)extremumWithMax:(CGFloat)max min:(CGFloat)min {
    EMExtremum *extremum = [EMExtremum new];
    extremum.max = max;
    extremum.min = min;
    return extremum;
}

- (void)updateWithMax:(CGFloat)max min:(CGFloat)min {
    self.max = MAX(max, self.max);
    self.min = MIN(min, self.min);
}

- (void)reset {
    self.max = -MAXFLOAT;
    self.min = MAXFLOAT;
}

- (BOOL)isInValid {
    if (self.max == -MAXFLOAT && self.min == MAXFLOAT) {
        return YES;
    }
    return NO;
}

- (CGFloat)max {
    @synchronized (self) {
        return _max;
    }
}

- (CGFloat)min {
    @synchronized (self) {
        return _min;
    }
}

- (void)setMax:(CGFloat)max {
    @synchronized (self) {
        _max = max;
    }
}

- (void)setMin:(CGFloat)min {
    @synchronized (self) {
        _min = min;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[EMExtremum class]]) {
        return NO;
    }
    EMExtremum *ext = (EMExtremum*)object;
    return (self.max == ext.max && self.min == ext.min);
}

@end


@implementation EMExtremumLong
@synthesize max = _max;
@synthesize min = _min;

+ (instancetype)extremumWithMax:(long)max min:(long)min {
    EMExtremumLong *extremum = [EMExtremumLong new];
    extremum.max = max;
    extremum.min = min;
    return extremum;
}

- (void)updateWithMax:(long)max min:(long)min {
    self.max = MAX(max, self.max);
    self.min = MIN(min, self.min);
}

- (void)reset {
    self.max = -MAXFLOAT;
    self.min = MAXFLOAT;
}

- (BOOL)isInValid {
    if (self.max == -MAXFLOAT && self.min == MAXFLOAT) {
        return YES;
    }
    return NO;
}

- (long)max {
    @synchronized (self) {
        return _max;
    }
}

- (long)min {
    @synchronized (self) {
        return _min;
    }
}

- (void)setMax:(long)max {
    @synchronized (self) {
        _max = max;
    }
}

- (void)setMin:(long)min {
    @synchronized (self) {
        _min = min;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[EMExtremumLong class]]) {
        return NO;
    }
    EMExtremumLong *ext = (EMExtremumLong*)object;
    return (self.max == ext.max && self.min == ext.min);
}

@end
