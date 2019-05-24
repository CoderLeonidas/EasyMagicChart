//
//  EMGraphicsAlgorithm.h
//  EasyMagicChart
//
//  Created by Leonidas on 2019/4/30.
//  Copyright © 2019 EasyMagicChart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMGraph.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMGraphicsAlgorithm : NSObject
@property (nonatomic, assign) SEL algorithmSelecotr;
+ (instancetype)algorithmWithGraphType:(EMGraphType )type;


@end

NS_ASSUME_NONNULL_END
