//
//  EMChartMouseLayer.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "EMChartMouseLayer.h"
#import "EMChartGraphLayer.h"
#import "EMGraphLayerAccessory.h"

@implementation EMChartMouseLayerTagText
- (instancetype)init {
    if (self = [super init]) {
        _leftTagText = nil;
        _rightTagText = nil;
        _topTagText = nil;
        _bottomTagText = nil;
    }
    return self;
}
@end

@implementation EMChartMouseLayerDot
- (instancetype)init {
    if (self = [super init]) {
        _frame = CGRectZero;
        _color = nil;
        _solid = NO;
    }
    return self;
}
@end

@implementation EMChartMouseLayer {
    NSMutableDictionary *_mAttributeDict; ///< 公用属性字典，用于绘制文本
    NSMutableParagraphStyle *_paragraphStyle;///< 段落对象，用于设置文本左右对齐
}

- (instancetype)init {
    self = [super init];
    _crossLineShow = NO;
    _paragraphStyle = [NSMutableParagraphStyle new];
    _mAttributeDict = [NSMutableDictionary new];
    _paragraphStyle.alignment = NSTextAlignmentCenter;
    _mAttributeDict[NSParagraphStyleAttributeName] = _paragraphStyle;
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    if (_crossLineShow) {
        // 绘制十字线
        [self drawCrossLineInContext:ctx];
        // 绘制游标
        [self drawTagsInContext:ctx];
        // 绘制渲染区域
        [self drawRenderingAreaInContext:ctx];
        // 绘制圆点
        [self drawDotsInContext :ctx];
    }
}

// 绘制圆点
- (void)drawDotsInContext :(CGContextRef)ctx {
    for (EMChartMouseLayerDot *dot in _dots) {
        CGPathDrawingMode drawingMode = -1;
        if (dot.isSolid) {
            CGContextSetFillColorWithColor(ctx, dot.color.CGColor);
            CGContextAddEllipseInRect(ctx, dot.frame);
            drawingMode = kCGPathFill;
        } else {
            CGContextSetStrokeColorWithColor(ctx, dot.color.CGColor);
            CGContextSetLineWidth(ctx, 0.5f);
            drawingMode = kCGPathStroke;
        }
        CGContextAddEllipseInRect(ctx, dot.frame);
        CGContextDrawPath(ctx, drawingMode);
    }
}

// 绘制渲染区域
- (void)drawRenderingAreaInContext:(CGContextRef)ctx {
    if (CGRectIsNull(_renderingAreaRect)) {return;}
    
    CGContextSetFillColorWithColor(ctx, (_renderingAreaColor?:[[NSColor blueColor]colorWithAlphaComponent:0.5]).CGColor);
    CGContextFillRect(ctx, _renderingAreaRect);
}

// 绘制十字线
- (void)drawCrossLineInContext:(CGContextRef)ctx {
    CGContextSetStrokeColorWithColor(ctx, (_crossLineColor?:[NSColor lightGrayColor]).CGColor);
    // 设置虚线
    CGFloat dash[4] = {4, 2, 2, 2};
    CGContextSetLineDash(ctx, 0.0, dash, 4);
    CGPoint aPoints[2];//坐标点
    
    CGFloat minX = CGRectGetMinX(_graphFrame);
    CGFloat maxX = CGRectGetMaxX(_graphFrame);
    CGFloat minY = CGRectGetMinY(_graphFrame);
    CGFloat maxY = CGRectGetMaxY(_graphFrame);

    // 画横线
    if ( _mousePoint.y > minY  &&  _mousePoint.y < maxY) {
        aPoints[0] =CGPointMake(minX, _mousePoint.y);//坐标1
        aPoints[1] =CGPointMake(maxX, _mousePoint.y);//坐标2
        CGContextAddLines(ctx, aPoints, 2);//添加线
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
    }
    
    // 画竖线
    if ( _mousePoint.x > minX  &&  _mousePoint.x < maxX) {
        aPoints[0] =CGPointMake(_mousePoint.x, minY);//坐标1
        aPoints[1] =CGPointMake(_mousePoint.x, maxY);//坐标2
        CGContextAddLines(ctx, aPoints, 2);//添加线
        CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
    }
}

// 绘制游标
- (void)drawTagsInContext:(CGContextRef)ctx {
    NSSize size = NSZeroSize;
    NSRect frame = NSZeroRect;
    // 变成实线
    CGFloat dash[2] = {1,0};
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGFloat minX = CGRectGetMinX(_graphFrame);
    CGFloat maxX = CGRectGetMaxX(_graphFrame);
    if (_mousePoint.x >= minX && _mousePoint.x <= maxX) {
        if (_tagText.topTagText.length > 0) {
            _mousePoint.y = MIN(_mousePoint.y, CGRectGetMaxY(_graphFrame));
            ((NSMutableParagraphStyle*)_mAttributeDict[NSParagraphStyleAttributeName]).alignment = NSTextAlignmentCenter;
            size = [self textSize:_tagText.topTagText withAttribute:_mAttributeDict];
            frame.size = size;
            frame.origin = NSMakePoint(_mousePoint.x - size.width * 0.5, NSMaxY(_graphFrame));
            [self drawText:_tagText.topTagText inRect:frame context:ctx withAttribute:_mAttributeDict];
            
        }
        if (_tagText.bottomTagText.length > 0) {
            _mousePoint.y = MAX(_mousePoint.y, CGRectGetMinY(_graphFrame));
            ((NSMutableParagraphStyle*)_mAttributeDict[NSParagraphStyleAttributeName]).alignment = NSTextAlignmentCenter;
            size = [self textSize:_tagText.bottomTagText withAttribute:_mAttributeDict];
            size.width +=2;
            frame.size = size;
            frame.origin = NSMakePoint(_mousePoint.x - size.width * 0.5, 1);
            [self drawText:_tagText.bottomTagText inRect:frame context:ctx withAttribute:_mAttributeDict];
        }
    }

    CGFloat minY = CGRectGetMinY(_graphFrame);
    CGFloat maxY = CGRectGetMaxY(_graphFrame);
    if (_mousePoint.y >= minY && _mousePoint.y <= maxY) {
        if (_tagText.leftTagText.length > 0) {
            ((NSMutableParagraphStyle*)_mAttributeDict[NSParagraphStyleAttributeName]).alignment = NSTextAlignmentRight;
            size = [self textSize:_tagText.leftTagText withAttribute:_mAttributeDict];
            frame.size = NSMakeSize(NSMinX(_graphFrame), size.height);
            frame.origin = NSMakePoint(0, _mousePoint.y - size.height * 0.5);
            [self drawText:_tagText.leftTagText inRect:frame context:ctx withAttribute:_mAttributeDict];
        }
        
        if (_tagText.rightTagText.length > 0) {
            ((NSMutableParagraphStyle*)_mAttributeDict[NSParagraphStyleAttributeName]).alignment = NSTextAlignmentLeft;
            size = [self textSize:_tagText.rightTagText withAttribute:_mAttributeDict];
            frame.size = NSMakeSize(NSMaxX(self.frame) - NSMaxX(_graphFrame), size.height);
            frame.origin = NSMakePoint(NSMaxX(_graphFrame), _mousePoint.y - size.height * 0.5);
            [self drawText:_tagText.rightTagText inRect:frame context:ctx withAttribute:_mAttributeDict];
        }
    }
}


- (NSSize)textSize:(NSString *)text withAttribute:(NSDictionary *)atrribute {
    if (0 == text.length || nil == atrribute) {
        return NSZeroSize;
    }
    NSSize size = [text sizeWithAttributes:atrribute];
    return size;
}

- (void)drawText:(NSString *)text
          inRect:(NSRect)rect
         context:(CGContextRef)ctx
   withAttribute:(NSDictionary*)attribute {
    CGContextSetStrokeColorWithColor(ctx, (_tagBorderColor?:[NSColor blueColor]).CGColor);
    CGContextStrokeRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, (_tagBGColor?:[NSColor clearColor]).CGColor);
    CGContextFillRect(ctx, rect);
    
    NSGraphicsContext *oldCtx = [NSGraphicsContext currentContext];
    NSGraphicsContext *newCtx = [NSGraphicsContext graphicsContextWithCGContext:ctx flipped:NO];
    [NSGraphicsContext setCurrentContext:newCtx];
    
    [text drawInRect:rect withAttributes:attribute];
    
    [NSGraphicsContext setCurrentContext:oldCtx];
}


#pragma mark - Setter

- (void)setMousePoint:(CGPoint)mousePoint {
    _mousePoint = mousePoint;
    [self refresh];
}

- (void)setCrossLineShow:(BOOL)isShow {
    if (_crossLineShow == isShow) {
        return;
    }
    _crossLineShow = isShow;
    [self refresh];
}

-(void)setTagFont:(NSFont *)tagFont {
    _tagFont = tagFont;
    _mAttributeDict[NSFontAttributeName] = _tagFont?: [NSFont systemFontOfSize:11.0];
}

- (void)setTagTextColor:(NSColor *)tagTextColor {
    _tagTextColor = tagTextColor;
    _mAttributeDict[NSForegroundColorAttributeName] = _tagTextColor?: [NSColor blackColor];
}

- (void)clear {
    _mousePoint = NSZeroPoint;
    _tagText = nil;
    _dots = @[];
}

@end
