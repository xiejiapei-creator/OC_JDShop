//
//  classifyCollectionModel.h
//  ucareshop
//
//  Created by liushuting on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <Foundation/Foundation.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface classifyCollectionModel : NSObject

@property (nonatomic, strong, readwrite) NSString *commodityName;
@property (nonatomic, strong, readwrite) NSString *commodityImageName;
@property (nonatomic, assign, readwrite) int commodityNumber;
@property (nonatomic, assign, readwrite) int commodityPrice;
@property (nonatomic, assign, readwrite) int primePrice;
@property (nonatomic, strong, readwrite) NSString *typeName;
@property (nonatomic, strong, readwrite) NSString *commodityId;

@end

NS_ASSUME_NONNULL_END
