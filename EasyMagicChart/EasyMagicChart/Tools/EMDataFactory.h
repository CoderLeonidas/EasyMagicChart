//
//  EMDataFactory.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//  数据工厂，顾名思义用来加工数据，主要有以下职能：原始数据修补，原始数据转换为绘图数据，数据统计值获取(最大值、最小值、平均值等)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EMDataFactory;
@class EMExtremum;
/**
 数据修补和数据转化的顺序任意，但注意在任何一个操作执行后，taskName_product_map中product的periodicDatas为执行该步骤后的数据
 */
@protocol EMDataFactoryDelegate <NSObject>

/**
 供外部根据业务需要，对原始数据进行修补
 
 @param dataFactory 数据工厂对象
 @param datas 待修补的数据
 @param taskName 任务名称
 @return 修补后的数据
 */
- (NSArray *)dataFactory:(EMDataFactory *)dataFactory repairDatas:(NSArray *)datas taskName:(NSString*)taskName;

/**
 供外部根据业务需要，将原始数据加工成绘图所需的数据
 
 @param dataFactory 数据工厂对象
 @param datas 待转化的数据
 @param taskName 任务名称
 @return 转化后的数据
 */
- (NSArray *)dataFactory:(EMDataFactory *)dataFactory convertDatas:(NSArray *)datas taskName:(NSString*)taskName;

@end

/**
 数据加工任务
 */
@interface EMDataFactoryTask : NSObject
@property (nonatomic, copy) NSString *name; ///< 加工任务名称
@property (nonatomic, copy) NSArray *rawDatas; ///< 外部提供的原始数据

@end

/**
 数据加工后的成品
 */
@interface EMDataFactoryProduct : NSObject
@property (atomic, copy) NSArray *periodicDatas; ///< 阶段性数据，供分为2个阶段，执行修补后，为修补后的数据；执行转化处理后，为转化处理后的数据，此时的数据已经可以用于绘图
@property (nonatomic, strong, readonly) EMExtremum *extremumY;

@end

/**
 数据加工厂
 @discussion
 1.用于规范数据修补和转换的流程
 2.加工分为2个步骤：数据修补(去掉部分数据或补充部分数据)和数据转化(转化为可以用于EMGraph的DataSource，可配合EMGraphChartLayer直接用于绘图)
 3.数据修补和数据转化的顺序任意，但注意在任何一个操作执行后，taskName_product_map中product的periodicDatas为执行该步骤后的数据
 4.数据修补和数据转化，视外部业务逻辑而定，因此通过代理方法交给外部去确定具体处理逻辑
 */
@interface EMDataFactory : NSObject
@property (nonatomic, weak) id <EMDataFactoryDelegate> delegate;

@property (nonatomic, copy) NSArray <EMDataFactoryTask*> *tasks; ///< 数据加工任务
@property (nonatomic, copy, readonly) NSDictionary <NSString *, EMDataFactoryProduct *> *taskName_product_map; ///< 数据加工任务对应的数据加工产品

@property (nonatomic, strong, readonly) EMExtremum *extremumY;

@property (nonatomic, assign, readonly) NSUInteger maxDataCount; ///< 多组数据中的最大数据长度

/**
 异步处理所有任务的数据修补操作
 */
- (void)repairWithCallBack:(void(^)(void))callBack;

/**
 异步处理所有任务的数据转化操作
 */
- (void)convertWithCallBack:(void(^)(void))callBack;

/**
 清理工厂，停止所有正在执行的操作，准备下次数据加工
 */
- (void)clean;

@end

NS_ASSUME_NONNULL_END
