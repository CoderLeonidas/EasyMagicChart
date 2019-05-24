//
//  EMCommonlyUsedToolKit.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/28.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//
#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "EMCommonlyUsedToolKit.h"
@implementation EMCommonlyUsedToolKit

+ (void)getYear:(int*)year Month:(int*)month Day:(int*)day WithDate:(int)date {
    if (year){
        *year  = date / 10000;
    }
    if (month) {
        *month = (date % 10000) / 100;
    }
    if (day) {
        *day = date % 100;
    }
}

+ (void)getHour:(int*)hour minute:(int*)minute second:(int*)second withTime:(int)time hasSecond:(BOOL)hasSecond {
    if (hasSecond) {
        if (hour) {
            *hour = time / 10000;
        }
        if (minute) {
            *minute = time / 100 % 100;
        }
        if (second) {
            *second = time % 100;
        }
        return;
    } else {
        if (hour) {
            *hour = time / 100;
        }
        if (minute) {
            *minute = time % 100;
        }
        return;
    }
}

+ (BOOL)isLeapYear:(NSUInteger)year {
    // 世纪闰年：能被400整除
    if(year % 400 == 0) {
        return YES;
    }
    // 普通闰年：能被4整除，不能被100整除
    if((year % 100 != 0) && (year % 4 == 0)) {
        return YES;
    }
    return NO;
}

+ (NSAttributedString *)colorStringWithString:(NSString *)string color:(NSColor *)color {
    if (nil == color || 0 == string.length) {
        return nil;
    }
    NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:string];
    [mAttribute addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, string.length)];
    return [mAttribute  copy];
}

+ (NSString*)formattedPriceStringWithDecimal:(int)decimal price:(double)price {
    return [NSString stringWithFormat:@"%.*lf", decimal, price];
}

+ (NSDictionary*)dictionaryWithParam:(id)obj {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)param {
    if([param isKindOfClass:[NSNumber class]] ||
       [param isKindOfClass:[NSString class]] ||
       [param isKindOfClass:[NSValue class]] ||
       [param isKindOfClass:[NSNull class]]) {
        
        return param;
    }
    
    if([param isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = param;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([param isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = param;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    
    return [self dictionaryWithParam:param];
}

+ (NSArray *)convertDataSource:(NSArray *)dataSource
                withPropertyKV:(NSDictionary *)aPropertyKV
                 destClassName:(NSString *)className {
    if (0 == dataSource.count || 0 == aPropertyKV.count) {
        return nil;
    }
    Class destClass = NSClassFromString(className);
    NSMutableArray *mConvertedDatas = [NSMutableArray new];
    
    for (id obj in dataSource) {
        id item = [destClass new];
        for (NSString *propertyKey in aPropertyKV.allKeys) {
            [item setValue:[obj valueForKeyPath:aPropertyKV[propertyKey]]forKeyPath:propertyKey];
        }
        [mConvertedDatas addObject:item];
    }
    return [mConvertedDatas copy];
}

+ (void)getMaxValue:(CGFloat *)maxValue
           minValue:(CGFloat *)minValue
            inDates:(NSArray *)datas
       withObjClass:(NSString *)objClassName
       propertyName:(NSString *)propertyName {
    Class class = NSClassFromString(objClassName);
    BOOL isThisClass = [datas.firstObject isKindOfClass:class];
    if (!isThisClass) {return;}
    [datas enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        *maxValue = MAX(*maxValue, ((NSString  *)[obj valueForKeyPath:propertyName]).floatValue);
        *minValue = MIN(*minValue, ((NSString  *)[obj valueForKeyPath:propertyName]).floatValue);
    }];
}

+ (void)getMaxValue:(CGFloat *)maxValue
           minValue:(CGFloat *)minValue
            inDates:(NSArray *)datas
       withObjClass:(NSString *)objClassName
      propertyNames:(NSArray <NSString *>*)propertyNames
         ignoreZero:(BOOL)ignoreZero {
    Class class = NSClassFromString(objClassName);
    BOOL isThisClass = [datas.firstObject isKindOfClass:class];
    if (!isThisClass) {return;}
    [datas enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *propertyName in propertyNames) {

            *maxValue = MAX(*maxValue, ((NSString  *)[obj valueForKeyPath:propertyName]).floatValue);
            
            if (ignoreZero) {
                *minValue = MAX(MIN(*minValue, ((NSString  *)[obj valueForKeyPath:propertyName]).floatValue),FLT_EPSILON);
            } else {
                *minValue = MIN(*minValue, ((NSString  *)[obj valueForKeyPath:propertyName]).floatValue);
            }
        }
    }];
}

+ (NSArray *)orderValueArrayWithDict:(NSDictionary *)dict {
    NSMutableArray *orderValueArray = [[NSMutableArray alloc]init];
    NSArray *keyArray = [dict allKeys];
    NSArray*sortedArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        }else if ([obj1 integerValue] == [obj2 integerValue]){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    for (NSString *key in sortedArray) {
        [orderValueArray addObject:[dict objectForKey:key]];
    }
    return orderValueArray;
}

+ (void)performanceTestingWithTarget:(id)target
                              action:(SEL)action
                        callingCount:(NSUInteger)callingCount {
    TIME_START
    for (NSUInteger i = 0; i < callingCount; i++) {
        IMP imp = [target methodForSelector:action];
        void (*func)(id, SEL) = (void *)imp;
        func(target, action);
    }
    TIME_END
}

#define TRILLION_LIMIT          999999999999.9999       //万亿
#define HANDRED_MILLION_LIMIT   99999999.9999           //亿
#define TEN_THOUSAND_LIMIT      9999.9999               //万

+ (NSString *)unitWithNumber:(CGFloat)number {
    NSString *tempUnitName = nil;
    if ((number - TRILLION_LIMIT > 0) || (number + TRILLION_LIMIT < 0)) {
        tempUnitName = @"万亿";
    
    } else if ((number - HANDRED_MILLION_LIMIT > 0) || (number + HANDRED_MILLION_LIMIT < 0)){
        tempUnitName = @"亿";
    
    } else if ((number - TEN_THOUSAND_LIMIT > 0) || (number + TEN_THOUSAND_LIMIT < 0)){
        tempUnitName = @"万";
    }
    return tempUnitName;
    
}

+ (NSUInteger)divisorWithNumber:(CGFloat)number {
    NSUInteger divisor = 1;
    if (number >= MAXFLOAT || number <= -MAXFLOAT) {
        return divisor;
    }
    if ((number - TRILLION_LIMIT > 0) || (number + TRILLION_LIMIT < 0)) {
        divisor = (NSUInteger)TRILLION_LIMIT + 1;

    } else if ((number - HANDRED_MILLION_LIMIT > 0) || (number + HANDRED_MILLION_LIMIT < 0)){
        divisor = (NSUInteger)HANDRED_MILLION_LIMIT + 1;

    } else if ((number - TEN_THOUSAND_LIMIT > 0) || (number + TEN_THOUSAND_LIMIT < 0)){
        divisor = (NSUInteger)TEN_THOUSAND_LIMIT + 1;
    }
    return divisor;
}

+ (NSArray *)trimDatasWithOrignDate:(NSInteger)orignDate dateKey:(NSString*)dateKey length:(NSUInteger)length forward:(BOOL)forward inDatas:(NSArray *)datas {
    if (0 == datas.count ||  0 == dateKey.length) {
        return nil;
    }
    __block NSInteger orignDateIndex = -1;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:dateKey] integerValue] == orignDate) {
            orignDateIndex = idx;
            *stop = YES;
        }
    }];
    
    if (orignDateIndex < 0) {
        return nil;
    }
    
    NSInteger beginIdx = -1;
    NSInteger endIdx = -1;
    
    if (forward) {
        beginIdx = orignDateIndex;
        endIdx = orignDateIndex + (length - 1);
        endIdx = MIN(endIdx, datas.count);
    } else {
        endIdx = orignDateIndex;
        beginIdx = orignDateIndex - (length - 1);
        beginIdx = MAX(beginIdx, 0);
    }

    id data = nil;
    NSMutableArray *trimmedDatas = [NSMutableArray new];
    
    for (NSUInteger idx = beginIdx; idx <= endIdx; idx++) {
        data = datas[idx];
        [trimmedDatas addObject:data];
    }
    return trimmedDatas;
}

@end
