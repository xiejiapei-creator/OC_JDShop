//
//  PaymentOrderViewController.h
//  ucareshop
//
//  Created by liushuting on 2019/8/24.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

#pragma mark - 块传值

typedef void (^passPaymentOrderMessage)(NSDictionary *orderMessage);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface PaymentOrderViewController : UIViewController

@property (nonatomic, strong, readwrite) NSDictionary *orderMessage;

@end

NS_ASSUME_NONNULL_END
