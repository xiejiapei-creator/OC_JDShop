//
//  NotPaymentView.h
//  ucareshop
//
//  Created by liushuting on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>
#import "OrderModel.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

#pragma mark - block传值

typedef void (^ passPaymentOrderMessage)(NSDictionary * _Nonnull orderMessage);
typedef void (^passNotPaymentOrderNumber)(NSString * _Nonnull orderNumber);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface NotPaymentView : UIView

@property (nonatomic, copy) passPaymentOrderMessage orderMessageValue;
@property (nonatomic, copy) passNotPaymentOrderNumber jumpAction;
@property (nonatomic, copy) passNotPaymentOrderNumber cancelOrder;
@property (nonatomic, strong, readwrite) OrderModel *orderModel;
@property (nonatomic, strong, readonly) UITableView *notPaymentOrderTable;
- (void) createData;
- (void) startRefresh;
@end

NS_ASSUME_NONNULL_END
