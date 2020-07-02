//
//  IconModel.m
//  瀑布流
//
//  Created by FDC-Fabric on 2018/12/14.
//  Copyright © 2018年 FDC-Fabric. All rights reserved.
//

#import "IconModel.h"
#import "IconModel.h"
@implementation IconModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if(self = [super init]){
        
        [self setValuesForKeysWithDictionary:dic];
        
        
    }
    
    return self;
    
}
+(instancetype)IconWithDictionay:(NSDictionary *)dic{
    
    return [[self alloc]initWithDic:dic];
    
    
}

@end
