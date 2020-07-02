//
//  UpdateAddressViewController.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>
#import "AddressSuperViewController.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface UpdateAddressViewController : AddressSuperViewController

@property (nonatomic, strong) NSMutableDictionary *addAddressDict;
@property (nonatomic) NSString *updateAddressId;
//默认文本
@property (nonatomic, strong) NSString *defaultName;
@property (nonatomic, strong) NSString *defaultPhoneNumber;
@property (nonatomic, strong) NSString *defaultPostalCode;
@property (nonatomic, strong) NSString *defaultAreaName;
@property (nonatomic, strong) NSString *defaultDetail;

@end

NS_ASSUME_NONNULL_END
