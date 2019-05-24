//
//  NSView+Geometry.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//  NSView坐标计算相关的简便方法，同时支持isFlipped为YES的情况

#import <Cocoa/Cocoa.h>

@interface NSView (Geometry)

- (CGFloat)frameX;

- (CGFloat)frameY;

- (CGFloat)boundsX;

- (CGFloat)boundsY;

- (CGFloat)width;

- (CGFloat)height;

- (NSPoint)centerPoint;

- (CGFloat)centerX;

- (CGFloat)centerY;

- (CGFloat)minX;

- (CGFloat)maxX;

- (CGFloat)minY;

- (CGFloat)maxY;

- (void)setHeight:(CGFloat)height;

- (void)setWidth:(CGFloat)width;

- (void)setFrameX:(CGFloat)frameX;

- (void)setFrameY:(CGFloat)frameY;

- (void)setBoundsX:(CGFloat)boundsX;

- (void)setBoundsY:(CGFloat)boundsY;

- (void)setCenterPoint:(NSPoint)centerPt;

- (void)setMinY:(CGFloat)minY;

- (void)setMaxY:(CGFloat)maxY;


- (void)setMinX:(CGFloat)minX;

- (void)setMaxX:(CGFloat)maxX;

@end
