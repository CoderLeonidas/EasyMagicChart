
//
//  EMControlTool.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/27.
//  Copyright © 2019 年 EasyMagicChart. All rights reserved.
//

#import "EMControlTool.h"
#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "EMCommonlyUsedToolKit.h"

static NSDateFormatter *_dateFormatter; ///< 定义成类内的静态变量，防止重复创建太耗时
static NSInteger _wholeDaySeconds;

@implementation EMControlTool

+ (void)initialize {
    if (self == [EMControlTool class]) {
        _dateFormatter = [NSDateFormatter new];
        _wholeDaySeconds = 24*60*60;
    }
}

+ (NSView *)getViewFromXibWithClassName:(NSString *)className {
    if (nil == className || [className isEqualToString:@""]) {
        return nil;
    }
    NSView *view;
    Class viewClass = NSClassFromString(className);
    NSArray *topLevelObjects ;
    NSBundle *bundle = [NSBundle bundleForClass:viewClass];
    [bundle loadNibNamed:className owner:nil topLevelObjects: &topLevelObjects];
    for (id obj in topLevelObjects) {
        if ([obj isKindOfClass:[viewClass class]]) {
            view = obj;
            break;
        }
    }
    NSAssert(view, @"Fail to get view <%@> from boundle, it is nil! Please check whether the <Custom Class> of the xib is empty", className);

    return view;
}

+ (id)getControlFromXibWithClassName:(NSString *)className {
    if (nil == className || [className isEqualToString:@""]) {
        return nil;
    }
    id control;
    Class controlClass = NSClassFromString(className);
    NSArray *topLevelObjects ;
    NSBundle *bundle = [NSBundle bundleForClass:controlClass];
    [bundle loadNibNamed:className owner:nil topLevelObjects: &topLevelObjects];
    for (id obj in topLevelObjects) {
        if ([obj isKindOfClass:[controlClass class]]) {
            control = obj;
            break;
        }
    }

    NSAssert(control, @"Fail to get view <%@> from boundle, it is nil! Please check whether the <Custom Class> of the xib is empty", className);
    return control;
}

+ (NSView*)getViewFromXibWithViewClass:(Class)viewClass {
    if (nil == viewClass) {
        return nil;
    }
    NSView *view;
    NSArray *topLevelObjects ;
    NSBundle *bundle = [NSBundle bundleForClass:viewClass];
    [bundle loadNibNamed:NSStringFromClass(viewClass) owner:nil topLevelObjects: &topLevelObjects];
    for (id obj in topLevelObjects) {
        if ([obj isKindOfClass:viewClass]) {
            view = obj;
            break;
        }
    }

    NSAssert(view, @"Fail to get view <%@> from boundle, it is nil! Please check whether the <Custom Class> of the xib is empty", NSStringFromClass(viewClass));
    return view;
}

+ (void)setBGColor:(NSColor *)aColor toViews:(NSArray <NSView*>*)views {
    if (nil == aColor || 0 == views.count) return;
    [views enumerateObjectsUsingBlock:^(NSView * _Nonnull aView, NSUInteger idx, BOOL * _Nonnull stop) {
        [self setBGColor:aColor toView:aView];
    }];
}

+ (void)setBGColor:(NSColor *)aColor toView:(NSView*)aView {
    if (nil == aColor || nil == aView) return;
    if ([aView isKindOfClass:[NSView class]] && [aColor isKindOfClass:[NSColor class]]) {
        if ([aView isKindOfClass:[NSTableView class]]) {
            ((NSTableView*)aView).backgroundColor = aColor;
            [((NSTableView*)aView).enclosingScrollView setDrawsBackground:NO];
        } else if ([aView isKindOfClass:[NSTextField class]]) {
            ((NSTextField*)aView).backgroundColor = aColor;
        } else {
            if (!aView.wantsLayer) {
                aView.wantsLayer = YES;
            }
            aView.layer.backgroundColor = aColor.CGColor;
        }
    }
}

+ (void)setBGColor:(NSColor *)aColor alpha:(CGFloat)alpha toView:(NSView*)aView {
    if (nil == aColor || nil == aView) return;
    aColor = [aColor colorWithAlphaComponent:alpha];
    [self setBGColor:aColor toView:aView];
}

/**
 MARK: - Demo如下
 需求：
    将aView下所有子视图中的tag=1的NSTextField对象的textColor设置为_normalTextColor。
 举个🌰：
 //NSDictionary *propertyKV = @{@"textColor": _normalTextColor};
 //NSDictionary *propertyConditionKV = @{@"tag": @1};
 //[EMControlTool setPropertyKV:propertyKV
 //                      inView:aView
 //             forControlClass:[NSTextField class]
 //               needRecursion:YES
 //     withPropertyConditionKV:propertyConditionKV
 //                 needDisplay:YES];

 */
+ (void)setPropertyKV:(NSDictionary *)aPropertyKV
               inView:(NSView*)aView
      forControlClass:(Class)aControlClass
        needRecursion:(BOOL)needRecursion
withPropertyConditionKV:(NSDictionary *)aPropertyConditionKV
          needDisplay:(BOOL)needDisplay {
    
    if (nil == aPropertyKV || nil == aView || nil == aControlClass) {return;}
    
    for (NSView *subView in aView.subviews) {
        if ([subView isKindOfClass:aControlClass]) {
            if (nil != aPropertyConditionKV) {
                BOOL shouldSet = YES;
                for (NSString *propertyConditionKey in aPropertyConditionKV.allKeys) {
                    // 对于identifier，判断是否有条件中的前缀
                    if ([propertyConditionKey isEqualToString:@"identifier"]) {
                        if (![[subView valueForKeyPath:propertyConditionKey] hasPrefix:aPropertyConditionKV[propertyConditionKey]]) {
                            shouldSet = NO;
                            break;
                        }
                    } else {
                        if (![[subView valueForKeyPath:propertyConditionKey] isEqual: aPropertyConditionKV[propertyConditionKey]]) {
                            shouldSet = NO;
                            break;
                        }
                    }
                    
                }
                if (shouldSet) {
                    for (NSString *propertyKey in aPropertyKV.allKeys) {
                        [subView setValue:aPropertyKV[propertyKey] forKeyPath:propertyKey];
                    }
                }
                
            } else {
                for (NSString *propertyKey in aPropertyKV.allKeys) {
                    [subView setValue:aPropertyKV[propertyKey] forKeyPath:propertyKey];
                }
            }
            
            [subView setNeedsDisplay:needDisplay];
            
        } else if ([subView isKindOfClass:[NSView class]] && needRecursion)  {
            [self setPropertyKV:aPropertyKV
                         inView:subView
                forControlClass:aControlClass
                  needRecursion:needRecursion
        withPropertyConditionKV:aPropertyConditionKV
                    needDisplay:needDisplay];
        }
    }
}


+ (NSTextField *)macLabel {
    NSTextField  *label  = [NSTextField new];
    label.editable = NO;
    label.backgroundColor = [NSColor clearColor];
    label.bordered = NO;
    [label sizeToFit];
    return label;
}

+ (void)setButton:(NSButton *)button
   withTitleColor:(NSColor *)titleColor
             font:(NSFont *)font {
    if (nil == button) {return;}
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (nil != titleColor) {
        attributes[NSForegroundColorAttributeName] = titleColor;
    }
    if (nil != font) {
        attributes[NSFontAttributeName] = font;
    }
    
    button.attributedTitle = [[NSAttributedString alloc] initWithString:button.title attributes:attributes];
}

+ (NSString *)monthEndDateWithDateStr:(NSString *)dateStr {
    [_dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *newDate = [_dateFormatter dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    
    [_dateFormatter setDateFormat:@"dd"];
    return [_dateFormatter stringFromDate:endDate];
}

+ (NSString *)thisYearDateStringWithFormat:(NSString *)format {
    
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    [_dateFormatter setDateFormat:format];
    NSString *thisYearString = [_dateFormatter stringFromDate:currentDate];
    return thisYearString;
}


#pragma mark - Tools

+ (NSDate*)thisYearOrignDate {
    // 提取今年年份
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    [_dateFormatter setDateFormat:@"yyyy"];
    NSString *thisYearString =  [_dateFormatter stringFromDate:currentDate];
    
    // 创建今年1月1日的date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:thisYearString.integerValue];
    [components setMonth:1];
    [components setDay:1];
    NSDate *thisYearOrignDate = [calendar dateFromComponents:components];
    return thisYearOrignDate;
}

+ (NSString *)dateStringSinceThisDate:(NSDate*)thisDate withOffsetDayCount:(NSInteger)dayCount forceLeapYear:(BOOL)forceLeapYear {
    if (nil == thisDate){
        return nil;
    }
    //明天此刻的时间
    NSDate *thisYearDate = [[NSDate alloc] initWithTimeInterval:_wholeDaySeconds * dayCount sinceDate:thisDate];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *yyyyMMdd = [_dateFormatter stringFromDate:thisYearDate];
    if (forceLeapYear) {
        if (dayCount > 59) {
             thisYearDate = [[NSDate alloc] initWithTimeInterval:_wholeDaySeconds * (dayCount - 1) sinceDate:thisDate];
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            yyyyMMdd = [_dateFormatter stringFromDate:thisYearDate];

        } else if (dayCount == 59) {
            thisYearDate = [[NSDate alloc] initWithTimeInterval:_wholeDaySeconds * (dayCount - 1) sinceDate:thisDate];
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
            yyyyMMdd = [_dateFormatter stringFromDate:thisYearDate];
            if ([yyyyMMdd containsString:@"-28"]) {
                NSMutableString *myyyyMMdd = [yyyyMMdd mutableCopy];
                [myyyyMMdd replaceOccurrencesOfString:@"-28" withString:@"-29" options:NSCaseInsensitiveSearch range:NSMakeRange(0, myyyyMMdd.length)];
                yyyyMMdd = [myyyyMMdd copy];
            }
        }
    }
    
    return yyyyMMdd;
}

+ (NSString *)timeStringSinceThisTime:(NSInteger)thisTime withOffsetMinutsCount:(NSInteger)minutsCount {
    int hour, minute, second;
    [EMCommonlyUsedToolKit getHour:&hour minute:&minute second:&second withTime:(int)thisTime hasSecond:NO];
    
    [_dateFormatter setDateFormat:@"hh:mm"];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    comp.hour = hour;
    comp.minute = minute;
    comp.second = 60 * minutsCount;
    NSString *hhmm = [_dateFormatter stringFromDate:[calender dateFromComponents:comp]];
    
    return hhmm;
}

+ (NSInteger)mostAppropriateScaleCountWithFont:(NSFont*)font height:(CGFloat)height {
    NSDictionary *attriDict = @{NSFontAttributeName:font ? : [NSFont systemFontOfSize:12.0]};
    return (int)(height) / (int)[@"100.00%" sizeWithAttributes:attriDict].height;
}

+ (void)showAlert:(NSString *)text {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = text;
    [alert runModal];
}

+ (NSColor *)randomColor {
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    return [NSColor colorWithRed:R/255.0 green:G/255.0  blue:B/255.0  alpha:1.0];
}

+(int)randomSigns {
    int n = rand()%21 - 10;
    if (0 == n) {
        return 1;
    }
    return n / abs(n);
}

+ (id)copyObjWithObj:(id)obj {
    if (nil == obj) {
        return nil;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        if ([arr.firstObject conformsToProtocol:@protocol(NSCopying)]) {
            return [[NSArray alloc] initWithArray:arr copyItems:YES];
        } else {
            NSMutableArray *marr = [NSMutableArray new];
            for (NSUInteger i = 0; i < arr.count; i++) {
                [marr addObject:[self copyObjWithObj:arr[i]] ];
            }
            return [marr copy];
        }
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [[NSDictionary alloc] initWithDictionary:obj copyItems:YES];
    }
    
    if ([obj isKindOfClass:[NSSet class]]) {
        return [[NSSet alloc] initWithSet:obj copyItems:YES];
    }
    
    Class aClass = NSClassFromString([obj className]);
    id copyOjb = [aClass new];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        char *iVar = property_copyAttributeValue(property, "V");
        NSString *iVarName = [NSString stringWithFormat:@"%s", iVar];
        free(iVar);
        id value = [obj valueForKey:iVarName];
        [copyOjb setValue:value forKey:iVarName];
    }
    free(properties);
    
    return copyOjb;
}

+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
    CFRelease(uuidStringRef);
    CFRelease(uuidRef);

    return uniqueId;
}

+ (NSAttributedString *)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL totalString:(NSString*)totalString {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: totalString];
    
    NSRange range = [totalString rangeOfString:inString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    [attrString endEditing];
    
    return attrString;
}

+ (NSAttributedString *)hyperlinkFromString:(NSString*)inString withURLString:(NSString*)aURLString totalString:(NSString*)totalString {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: totalString];
    
    NSRange range = [totalString rangeOfString:inString];
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:aURLString range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    [attrString endEditing];
    
    return attrString;
}



@end
