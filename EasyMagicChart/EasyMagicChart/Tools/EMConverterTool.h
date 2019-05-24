//
//  EMConverterTool.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/2/25.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//  存放一下转换相关的工具方法，如时间转下标、位置转下标等，在分时和指标中公用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMConverterTool : NSObject

#pragma mark - valueY -> pointY

+ (CGFloat)ptYWithMaxValueY:(CGFloat)maxValueY
                  minValueY:(CGFloat)minValueY
                     valueY:(CGFloat)valueY
                 axisLength:(CGFloat)axisLength
                 topSpacing:(CGFloat)topSpacing
              bottomSpacing:(CGFloat)bottomSpacing;

#pragma mark - indexY -> pointY

+ (CGFloat)ptYWithIndex:(NSUInteger)index
             scaleCount:(CGFloat)scaleCount
             axisLength:(CGFloat)axisLength
             topSpacing:(CGFloat)topSpacing
          bottomSpacing:(CGFloat)bottomSpacing;

#pragma mark - pointY -> valueY

+ (CGFloat)valueYWithMaxValueY:(CGFloat)maxValueY
                     minValueY:(CGFloat)minValueY
                    axisLength:(CGFloat)axisLength
                        pointY:(CGFloat)pointY;

#pragma mark - indexX -> pointX

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount;

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
             leftSpacing:(CGFloat)leftSpacing
            rightSpacing:(CGFloat)rightSpacing;

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
             leftSpacing:(CGFloat)leftSpacing
            rightSpacing:(CGFloat)rightSpacing
                 flipped:(BOOL)flipped;

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
                 flipped:(BOOL)flipped;

#pragma mark - pointX -> indexX

+ (NSInteger)indexXFromPointX:(CGFloat)pointX
                   axisLength:(CGFloat)axisLength
                    scaleCount:(NSUInteger)scaleCount;

+ (NSInteger)indexXFromPointX:(CGFloat)pointX
                   axisLength:(CGFloat)axisLength
                    scaleCount:(NSUInteger)scaleCount
                  leftSpacing:(CGFloat)leftSpacing
                 rightSpacing:(CGFloat)rightSpacing;

#pragma mark - delta

+ (CGFloat)deltaWithScaleCount:(NSUInteger)scaleCount axisLength:(CGFloat)axisLength;
+ (CGFloat)deltaWithScaleCount:(NSUInteger)scaleCount
                    axisLength:(CGFloat)axisLength
                   leftSpacing:(CGFloat)leftSpacing
                  rightSpacing:(CGFloat)rightSpacing;

@end

NS_ASSUME_NONNULL_END
