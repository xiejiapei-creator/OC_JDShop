//
//  URLRequest.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/4.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <Foundation/Foundation.h>
#import "LoginStatus.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN
typedef void (^TransDataBlock)(NSDictionary *  content);

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface URLRequest : NSObject

@property (nonatomic) NSString *iconURL;
@property (copy, nonatomic) TransDataBlock transDataBlock;//定义一个block属性，用于回传数据

- (void)startRequest:(NSDictionary *_Nullable)parameters pathUrl:(NSString *)pathUrl;

- (NSString *)requestForProfileImage:(NSDictionary *_Nullable)parameters pathUrl:(NSString *)pathUrl;

@end

NS_ASSUME_NONNULL_END
