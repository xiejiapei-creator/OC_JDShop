//
//  AddressSuperViewController.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>
#import "NewNameTableViewCell.h"
#import "PhoneNumberTableViewCell.h"
#import "PostalCodeTableViewCell.h"
#import "AreaTableViewCell.h"
#import "DetailTableViewCell.h"
#import "AddAddressView.h"
#import "URLRequest.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

typedef void(^TransDataBlock)(NSDictionary * _Nonnull dict);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface AddressSuperViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

//保存数据列表
@property (copy, nonatomic) TransDataBlock transDataBlock;//定义一个block属性，用于回传数据
@property (nonatomic, strong) AddAddressView *addAddressView;

//文本框
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, readwrite) NSString *areaName;
@property (nonatomic, readwrite) NSString *provinceName;
@property (nonatomic, readwrite) NSString *cityName;
@property (nonatomic, readwrite) NSString *districtName;

//单元格
@property (nonatomic, strong) NewNameTableViewCell *nameCell;
@property (nonatomic, strong) PhoneNumberTableViewCell *phoneNumberCell;
@property (nonatomic, strong) PostalCodeTableViewCell *postalCodeCell;
@property (nonatomic, strong) AreaTableViewCell *areaCell;
@property (nonatomic, strong) DetailTableViewCell *detailCell;

//数据库
@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic, strong) NSDictionary *updateAddressInfoDict;
@property (nonatomic) BOOL isCheck;
@property (nonatomic) NSInteger addressID;

@end

NS_ASSUME_NONNULL_END
