//
//  EMConverterTool.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/2/25.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMConverterTool.h"


@implementation EMConverterTool
/**
 根据给定的y数值(如价格，百分比等)计算该数值对应的Y坐标并返回
 
 @param maxValueY Y轴最大数值
 @param minValueY Y轴最小数值
 @param valueY     变量Y值
 @param axisLength Y轴高度
 @param topSpacing Y轴顶部预留高度
 @param bottomSpacing Y轴底部预留高度
 @return Y坐标
 */
+ (CGFloat)ptYWithMaxValueY:(CGFloat)maxValueY
                  minValueY:(CGFloat)minValueY
                     valueY:(CGFloat)valueY
                 axisLength:(CGFloat)axisLength
                 topSpacing:(CGFloat)topSpacing
              bottomSpacing:(CGFloat)bottomSpacing {
    CGFloat deltaValueY = maxValueY - minValueY;
    if (deltaValueY <= DBL_EPSILON) {
        return -MAXFLOAT;
    }
    CGFloat validHeight = (axisLength - topSpacing - bottomSpacing);
    CGFloat ptY = ((valueY - minValueY) / deltaValueY)  * validHeight + bottomSpacing;
    return ptY;
    
}

+ (CGFloat)ptYWithIndex:(NSUInteger)index
             scaleCount:(CGFloat)scaleCount
             axisLength:(CGFloat)axisLength
             topSpacing:(CGFloat)topSpacing
          bottomSpacing:(CGFloat)bottomSpacing {
    if (scaleCount <= 0) {
        return -MAXFLOAT;
    }
    CGFloat validHeight = (axisLength - topSpacing - bottomSpacing);
    CGFloat ptY = (validHeight / scaleCount)  * index + bottomSpacing;
    return ptY;
    
}

/**
 获取Y轴上pointY所代表的值
 
 @param maxValueY Y轴最大值
 @param minValueY Y轴最小值
 @param axisLength Y轴高度
 @param pointY Y点
 @return Y点代表的值
 */
+ (CGFloat)valueYWithMaxValueY:(CGFloat)maxValueY
                     minValueY:(CGFloat)minValueY
                    axisLength:(CGFloat)axisLength
                        pointY:(CGFloat)pointY {
    return  ((maxValueY - minValueY) / axisLength) * pointY + minValueY;
} 

/**
 根据x下标获取数据在x轴上的坐标点x值
 
 @param indexX X轴数据下标
 @param axisLength 坐标轴宽度(x轴长度)
 @param scaleCount 刻度数
 @return X坐标
 */
+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount {
    return [self ptXWithIndexX:indexX axisLength:axisLength scaleCount:scaleCount leftSpacing:0 rightSpacing:0];
}

/**
 
 根据x下标获取数据在x轴上的坐标点x值
 
 @param indexX X轴数据下标
 @param axisLength 坐标轴宽度(x轴长度)
 @param scaleCount 刻度数
 @param leftSpacing 左侧边距
 @param rightSpacing 右侧边距
 @return X坐标
 */
+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
             leftSpacing:(CGFloat)leftSpacing
            rightSpacing:(CGFloat)rightSpacing {
    if (0 == scaleCount){
        return -MAXFLOAT;
    }
    return leftSpacing + indexX * ((axisLength - leftSpacing - rightSpacing) / scaleCount * 1.0);
}

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
             leftSpacing:(CGFloat)leftSpacing
            rightSpacing:(CGFloat)rightSpacing
                 flipped:(BOOL)flipped {
    if (0 == scaleCount){
        return -MAXFLOAT;
    }
    CGFloat realLength = (axisLength - leftSpacing - rightSpacing);
    CGFloat delta = (realLength / scaleCount * 1.0);
    CGFloat spaccing = flipped ? rightSpacing : leftSpacing;
    if (flipped) {
        return axisLength - (spaccing + indexX * delta);
    } else {
        return spaccing + indexX * delta;
    }
}

+ (CGFloat)ptXWithIndexX:(NSInteger)indexX
              axisLength:(CGFloat)axisLength
              scaleCount:(NSUInteger)scaleCount
                 flipped:(BOOL)flipped {
    CGFloat ptx =  [self ptXWithIndexX:indexX axisLength:axisLength scaleCount:scaleCount];
    return flipped ? (axisLength - ptx) : ptx;
}

/**
 根据鼠标点x获取到数据的索引值
 
 @param pointX 鼠标点x
 @param axisLength 坐标轴宽度(x轴长度)
 @param scaleCount 数据源长度
 @return pointX所对应的数据下标
 */
+ (NSInteger)indexXFromPointX:(CGFloat)pointX
                   axisLength:(CGFloat)axisLength
                    scaleCount:(NSUInteger)scaleCount {
    
    return [self indexXFromPointX:pointX axisLength:axisLength scaleCount:scaleCount leftSpacing:0 rightSpacing:0];
}

/**
 根据鼠标点x获取到数据的索引值
 
 @param pointX 鼠标点x
 @param axisLength 坐标轴宽度(x轴长度)
 @param scaleCount 数据源长度
 @param leftSpacing 左侧边距
 @param rightSpacing 右侧边距
 
 @return pointX所对应的数据下标
 */
+ (NSInteger)indexXFromPointX:(CGFloat)pointX
                   axisLength:(CGFloat)axisLength
                    scaleCount:(NSUInteger)scaleCount
                  leftSpacing:(CGFloat)leftSpacing
                 rightSpacing:(CGFloat)rightSpacing {
    if (0 == scaleCount || 0 == axisLength){
        return NSNotFound;
    }
    if (pointX < 0) {
        pointX = 0;
    }
    return ((pointX - leftSpacing) / (axisLength - leftSpacing - rightSpacing) * scaleCount);
}

/**
 获取x轴每个数据代表的步长
 
 @param scaleCount 数据总量
 @param axisLength x轴宽度
 @return 步长
 */

+ (CGFloat)deltaWithScaleCount:(NSUInteger)scaleCount axisLength:(CGFloat)axisLength {
    return [self deltaWithScaleCount:scaleCount axisLength:axisLength leftSpacing:0 rightSpacing:0];
}

+ (CGFloat)deltaWithScaleCount:(NSUInteger)scaleCount
                    axisLength:(CGFloat)axisLength
                   leftSpacing:(CGFloat)leftSpacing
                  rightSpacing:(CGFloat)rightSpacing {
    if (0 == scaleCount) {
        return -MAXFLOAT;
    }
    return (axisLength - leftSpacing - rightSpacing) / (scaleCount * 1.0);
}


@end
