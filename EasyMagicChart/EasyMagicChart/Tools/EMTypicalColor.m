//
//  EMTypicalColor.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMTypicalColor.h"
#import  <AppKit/AppKit.h>
@implementation EMGLNColor
@end

@implementation EMTypicalColor
static EMTypicalColor *typicalColor = nil;

+ (EMTypicalColor *)sharedTypicalColor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typicalColor = [[super allocWithZone:NULL] init];
    });
    return typicalColor;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedTypicalColor];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupColors];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)setupColors {
    _glnColor = [EMGLNColor new];
    _glnColor.gainColor   =  [NSColor redColor];
    _glnColor.loseColor   =  [NSColor greenColor];
    _glnColor.normalColor =  [NSColor blackColor];
    
    self.backgroundColor =  [NSColor lightGrayColor];;
    
    self.gridColor = [NSColor gridColor];;
    
    self.textColor = [NSColor textColor];;
    
    self.backgroundTextColor = [NSColor whiteColor];
    
    self.lineColor = [NSColor darkGrayColor];
    
    self.selfSelectStockColor = [NSColor orangeColor];
    self.anti_selfSelectStockColor = [NSColor orangeColor];
    
    self.crossLineColor = [NSColor blackColor];
    
    self.blueLineColor = [NSColor blueColor];;
    self.orangeLineColor = [NSColor orangeColor];
    
    self.orangeNameColor = [NSColor orangeColor];

    self.titleBGColor = [NSColor lightGrayColor];
    
    self.formulaLineColor1 = [NSColor blackColor];
    self.formulaLineColor2 = [NSColor blackColor];
    self.formulaLineColor3 = [NSColor blackColor];
    self.formulaLineColor4 = [NSColor blackColor];
    self.formulaLineColor5 = [NSColor blackColor];
    self.formulaLineColor6 = [NSColor blackColor];
    self.formulaLineColor7 = [NSColor blackColor];
    self.formulaLineColor8 = [NSColor blackColor];
    self.formulaLineColor9 = [NSColor blackColor];
    self.formulaLineColor10 = [NSColor blackColor];
}


+ (id)colorWithValue:(CGFloat)fValue {
    EMTypicalColor *typicalColor = [EMTypicalColor sharedTypicalColor];
    if (fValue > 0.000001) {
        return typicalColor.glnColor.gainColor;
    }
    else if (fValue < -0.000001) {
        return typicalColor.glnColor.loseColor;
    }
    else {
        return typicalColor.glnColor.normalColor;
    }
}

+ (id)colorWithValue:(CGFloat)fValue glnColor:(EMGLNColor *)glnColor {
    if (fValue > 0.000001) {
        return glnColor.gainColor;
    }
    else if (fValue < -0.000001) {
        return glnColor.loseColor;
    }
    else {
        return glnColor.normalColor;
    }
}

@end
