//
//  AddAddress.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

typedef void(^TransferCheckStatus)(BOOL isCheck);
/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface AddAddressView : UIView

@property (nonatomic, readonly) UILabel *defaultAddressLabel;
@property (nonatomic, readonly) UIButton *saveAddressButton;
@property (nonatomic, copy) TransferCheckStatus transferCheckStatus;

@property (nonatomic, readwrite) CAShapeLayer *maskLayer;


@property (nonatomic, readwrite) UIButton *checkButton;


@end

NS_ASSUME_NONNULL_END