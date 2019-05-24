//
//  EMGraphLayerAccessory.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 图层附件属性，保存一些不太变化的属性
 */
@interface EMGraphLayerAccessory : NSObject
@property (nonatomic, assign) CGFloat topSpacing;///< 图元距图层顶部的空隙
@property (nonatomic, assign) CGFloat bottomSpacing;///< 图元距图层底部的空隙
@property (nonatomic, assign) CGFloat leftSpacing;///<  图元距图层左侧的空隙
@property (nonatomic, assign) CGFloat rightSpacing;///< 图元距图层右侧的空隙

@end

NS_ASSUME_NONNULL_END
