//
//  AddressManagementTableViewCell.h
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

typedef void(^TransTrashBlock)(void);
//typedef void(^TransChangeColorBlock)(BOOL isCheck);
typedef void(^TransChangeColorBlock)(void);

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface AddressManagementTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *phoneNumberLabel;
@property (nonatomic, strong, readonly) UILabel *addressLabel;
@property (nonatomic, strong, readonly) UILabel *defaultAddressLabel;
@property (nonatomic, strong, readonly) UIButton *editButton;
@property (nonatomic, strong, readonly) UIButton *trashButton;
@property (nonatomic, strong, readwrite) UIButton *checkButton;
@property (nonatomic, strong, readwrite) CAShapeLayer *maskLayer;
//@property (nonatomic, readwrite) BOOL isCheck;
@property (copy, nonatomic) TransTrashBlock transTrashBlock;//定义一个block属性，用于回传数据
//@property (copy, nonatomic) TransChangeColorBlock transChangeColorBlock;//定义一个block属性，用于回传数据
@property (copy, nonatomic) TransChangeColorBlock transChangeColorBlock;//定义一个block属性，用于回传数据
@property (copy, nonatomic) void(^TransEditBlock)(void);

@end

NS_ASSUME_NONNULL_END
