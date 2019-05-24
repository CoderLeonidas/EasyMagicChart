//
//  EMDataFactory.m
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import "EMDataFactory.h"
#import "EMCommonlyUsedToolKit.h"
#import "EMControlTool.h"

#import "EMGraph.h"

static const NSUInteger kMaxConcurrentOperationCount = 8;
@implementation EMDataFactoryTask
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@implementation EMDataFactoryProduct
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [EMCommonlyUsedToolKit dictionaryWithParam:self]];
}

@end

@interface EMDataFactory ()
@property (nonatomic, strong, readwrite) EMExtremum *extremumY;

@property (nonatomic, assign, readwrite) NSUInteger maxDataCount; ///< 多组数据中的最大数据长度

@end

@implementation EMDataFactory {
    NSMutableDictionary <NSString *, EMDataFactoryProduct *> *_interiorM_taskName_product_map;

    NSOperationQueue *_repairOperationQueue;
    NSOperationQueue *_convertOperationQueue;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _interiorM_taskName_product_map = [NSMutableDictionary new];
        _extremumY = [EMExtremum extremumWithMax:-MAXFLOAT min:MAXFLOAT];
        _maxDataCount = 0;
        _repairOperationQueue = [[NSOperationQueue alloc] init];
        _repairOperationQueue.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
        _repairOperationQueue.name = @"数据修补任务队列";
        
        _convertOperationQueue = [[NSOperationQueue alloc] init];
        _convertOperationQueue.maxConcurrentOperationCount = kMaxConcurrentOperationCount;
        _convertOperationQueue.name = @"数据加工任务队列";
    }
    return self;
}

- (void)repairWithCallBack:(void(^)(void))callBack {
    if (0 == _tasks.count) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(dataFactory:repairDatas:taskName:)]) {
        return;
    }
    
    for (EMDataFactoryTask *task in _tasks) {
        @synchronized (self) {
            EMDataFactoryProduct *product = _interiorM_taskName_product_map[task.name];
            if ((NSNull *)product == [NSNull null]) {
                product = [EMDataFactoryProduct new];
                _interiorM_taskName_product_map[task.name] = product;
            }
            
            if (0 == product.periodicDatas.count) {
                product.periodicDatas = task.rawDatas;
            }
            
            [_repairOperationQueue addOperationWithBlock:^{
                NSArray *repairedDatas = [self.delegate dataFactory:self
                                                        repairDatas:product.periodicDatas
                                                           taskName:task.name];
                @synchronized (self) {
                    product.periodicDatas = repairedDatas;
                    [self updateMaxDataCount];
                    if (callBack) {
                        callBack();
                    }
                }
            }];
        }
    }
}

- (void)convertWithCallBack:(void(^)(void))callBack {
    if (0 == _tasks.count) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(dataFactory:convertDatas:taskName:)]) {
        return;
    }
    
    for (EMDataFactoryTask *task in _tasks) {
        @synchronized (self) {
            EMDataFactoryProduct *product = _interiorM_taskName_product_map[task.name];
            if ((NSNull *)product == [NSNull null]) {
                product = [EMDataFactoryProduct new];
                _interiorM_taskName_product_map[task.name] = product;
            }
            if (0 == product.periodicDatas.count) {
                product.periodicDatas = task.rawDatas;

            }
            
            [_convertOperationQueue addOperationWithBlock:^{
                NSArray *convertDatas = [self.delegate dataFactory:self
                                                      convertDatas:product.periodicDatas
                                                          taskName:task.name];
                @synchronized (self) {
                    product.periodicDatas = convertDatas;
                    [self updateMaxAndMinValue];

                    if (callBack) {
                        callBack();
                    }
                }
            }];
        }
    }
}

- (void)clean {
    [_repairOperationQueue cancelAllOperations];
    [_convertOperationQueue cancelAllOperations];
    _tasks = @[];
    [_extremumY reset];
    _maxDataCount = 0;
    
    @synchronized (self) {
        [_interiorM_taskName_product_map removeAllObjects];
    }
}

- (NSDictionary<NSString *,EMDataFactoryProduct *> *)taskName_product_map {
    @synchronized (self) {
        return [_interiorM_taskName_product_map copy];
    }
}

- (NSUInteger)maxDataCount {
    @synchronized (self) {
        return _maxDataCount;
    }
}

- (EMExtremum *)extremumY {
    @synchronized (self) {
        return _extremumY;
    }
}

- (void)setTasks:(NSArray<EMDataFactoryTask *> *)tasks {
    _tasks = tasks;
    for (EMDataFactoryTask *task in _tasks) {
        @synchronized (self) {
            _interiorM_taskName_product_map[task.name] = [EMDataFactoryProduct new];
        }
    }
}

// TODO: 
- (void)updateMaxAndMinValue {
    @synchronized (self) {
        [_interiorM_taskName_product_map enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull taskName, EMDataFactoryProduct * _Nonnull product, BOOL * _Nonnull stop) {
            NSArray *convertedDatas = product.periodicDatas;
            if (![convertedDatas.firstObject isKindOfClass:[EMBaseGraphDataItem class]]) {
                return;
            }
            
            CGFloat maxV = [[convertedDatas valueForKeyPath:@"@max.lineValue"] doubleValue];
            CGFloat minV = [[convertedDatas valueForKeyPath:@"@min.lineValue"] doubleValue];
            
            [self->_extremumY updateWithMax:maxV min:minV];
            [product setValue:self->_extremumY forKey:@"extremumY"];
        }];
    }
}

- (void)updateMaxDataCount {
    @synchronized (self) {
        [_interiorM_taskName_product_map enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull taskName, EMDataFactoryProduct * _Nonnull product, BOOL * _Nonnull stop) {
            self->_maxDataCount = MAX(self->_maxDataCount, product.periodicDatas.count);
        }];
    }
}

@end
