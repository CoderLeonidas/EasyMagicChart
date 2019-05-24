//
//  EMTypicalColor.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSColor;

@interface EMGLNColor : NSObject
/// 价格相关
@property (nonatomic, strong) NSColor *normalColor;///< "平"颜色
@property (nonatomic, strong) NSColor *gainColor;///< "涨"颜色
@property (nonatomic, strong) NSColor *loseColor;///< "跌"颜色
@end
/**
 程序中用到的常规颜色，单例，支持换肤，换肤时再获取一次单例对象即可
 */
@interface EMTypicalColor : NSObject

/// 价格相关
@property (nonatomic, strong) EMGLNColor *glnColor;

/// 控件相关
@property (nonatomic, strong) NSColor *backgroundColor; ///< 常用背景色
@property (nonatomic, strong) NSColor *gridColor; ///< 常用网格线色
@property (nonatomic, strong) NSColor *textColor; ///< 常用文本色
@property (nonatomic, strong) NSColor *backgroundTextColor; ///<  常用背景文本色
@property (nonatomic, strong) NSColor *lineColor; ///< 常用趋势线条色
@property (nonatomic, strong) NSColor *crossLineColor; ///<  常用十字线色
@property (nonatomic, strong) NSColor *selfSelectStockColor;///< 常用自选股颜色
@property (nonatomic, strong) NSColor *anti_selfSelectStockColor;///< 常用自选股颜色黑白取反

@property (nonatomic, strong) NSColor *orangeNameColor;
@property (nonatomic, strong) NSColor *titleBGColor;

/// 特殊颜色
@property (nonatomic, strong) NSColor *blueLineColor; ///< 常用蓝色线条色
@property (nonatomic, strong) NSColor *orangeLineColor; ///< 常用橙色线条色

@property (nonatomic, strong) NSColor *formulaLineColor1;
@property (nonatomic, strong) NSColor *formulaLineColor2;
@property (nonatomic, strong) NSColor *formulaLineColor3;
@property (nonatomic, strong) NSColor *formulaLineColor4;
@property (nonatomic, strong) NSColor *formulaLineColor5;
@property (nonatomic, strong) NSColor *formulaLineColor6;
@property (nonatomic, strong) NSColor *formulaLineColor7;
@property (nonatomic, strong) NSColor *formulaLineColor8;
@property (nonatomic, strong) NSColor *formulaLineColor9;
@property (nonatomic, strong) NSColor *formulaLineColor10;

+ (EMTypicalColor *)sharedTypicalColor;


+ (id)colorWithValue:(CGFloat)fValue;
+ (id)colorWithValue:(CGFloat)fValue glnColor:(EMGLNColor *)glnColor;

@end
