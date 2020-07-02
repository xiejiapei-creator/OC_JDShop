//
//  IconModel.h
//  瀑布流
//
//  Created by FDC-Fabric on 2018/12/14.
//  Copyright © 2018年 FDC-Fabric. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IconModel : NSObject
@property(nonatomic,assign)float iconW;
@property(nonatomic,assign)float IconH;
-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)IconWithDictionay:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
