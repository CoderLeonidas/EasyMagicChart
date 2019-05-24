//
//  EMExtremum.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMExtremum : NSObject
@property (nonatomic, assign) CGFloat max;///< 最大值
@property (nonatomic, assign) CGFloat min;///< 最小值

+ (instancetype)extremumWithMax:(CGFloat)max min:(CGFloat)min;
- (void)updateWithMax:(CGFloat)max min:(CGFloat)min;
- (void)reset;
- (BOOL)isInValid;

@end

@interface EMExtremumLong : NSObject
@property (nonatomic, assign) long max;///< 最大值
@property (nonatomic, assign) long min;///< 最小值

+ (instancetype)extremumWithMax:(long)max min:(long)min;
- (void)updateWithMax:(long)max min:(long)min;
- (void)reset;
- (BOOL)isInValid;

@end

NS_ASSUME_NONNULL_END
