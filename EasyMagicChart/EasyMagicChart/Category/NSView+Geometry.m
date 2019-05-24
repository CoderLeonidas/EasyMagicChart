//
//  NSView+Geometry.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import "NSView+Geometry.h"

@implementation NSView (Geometry)


- (CGFloat)frameX {
    return NSMinX(self.frame);
}

- (CGFloat)frameY {
    return NSMinY(self.frame);
}

- (CGFloat)boundsX {
    return NSMinX(self.bounds);
}


- (CGFloat)boundsY {
    return NSMinY(self.bounds);
}

- (CGFloat)width {
    return NSWidth(self.frame);
}

- (CGFloat)height {
    return NSHeight(self.frame);
}

- (NSPoint)centerPoint {
    return NSMakePoint([self frameX]+ 0.5 * [self width],
                       [self frameY] + 0.5 * [self height]);
}

- (CGFloat)centerX {
    return [self centerPoint].x;
}

- (CGFloat)centerY {
    return [self centerPoint].y;
}

- (CGFloat)minX {
    return NSMinX(self.frame);
}

- (CGFloat)maxX {
    return NSMaxX(self.frame);
}

- (CGFloat)minY {
    return NSMinY(self.frame);
}

- (CGFloat)maxY {
    return NSMaxY(self.frame);
}

- (void)setHeight:(CGFloat)height {
    if ([self height] == height){
        return;
    }
    NSSize size = self.frame.size;
    size.height = height;
    [self setFrameSize:size];
}

- (void)setWidth:(CGFloat)width {
    if ([self width] == width){
        return;
    }
    NSSize size = self.frame.size;
    size.width = width;
    [self setFrameSize:size];
}

- (void)setFrameX:(CGFloat)frameX {
    if ([self frameX] == frameX){
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.x = frameX;
    [self setFrameOrigin:origin];
}

- (void)setFrameY:(CGFloat)frameY{
    if ([self frameY] == frameY){
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.y = frameY;
    [self setFrameOrigin:origin];
}

- (void)setBoundsX:(CGFloat)boundsX {
    if ([self boundsX] == boundsX){
        return;
    }
    NSPoint origin = self.bounds.origin;
    origin.x = boundsX;
    [self setBoundsOrigin:origin];
}

- (void)setBoundsY:(CGFloat)boundsY {
    if ([self boundsY] == boundsY){
        return;
    }
    NSPoint origin = self.bounds.origin;
    origin.y = boundsY;
    [self setBoundsOrigin:origin];
}

/**
centerX = x + 0.5 * w
centerY = y + 0.5 * h
 */
- (void)setCenterPoint:(NSPoint)centerPt {
    NSPoint curCenterPt = [self centerPoint];
    if (NSEqualPoints(centerPt, curCenterPt)) {
        return;
    }
    NSPoint newOrigin = NSMakePoint(centerPt.x - 0.5 * [self width],
                                    centerPt.y - 0.5 * [self height]);
    [self setFrameOrigin:newOrigin];
}

- (void)setMinY:(CGFloat)minY {
    if ([self minY] ==  minY) {
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.y = minY;
    [self setFrameOrigin:origin];
}


- (void)setMaxY:(CGFloat)maxY {
    if ([self maxY] ==  maxY) {
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.y = maxY - [self height];
    [self setFrameOrigin:origin];
}

- (void)setMinX:(CGFloat)minX {
    if ([self minX] ==  minX) {
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.x = minX;
    [self setFrameOrigin:origin];
}


- (void)setMaxX:(CGFloat)maxX {
    if ([self maxX] ==  maxX) {
        return;
    }
    NSPoint origin = self.frame.origin;
    origin.x = maxX - [self width];
    [self setFrameOrigin:origin];
}

@end
