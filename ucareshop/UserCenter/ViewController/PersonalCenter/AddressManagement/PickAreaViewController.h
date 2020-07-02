//
//  PickAreaViewController.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>
#import "PickerView.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举



NS_ASSUME_NONNULL_BEGIN

typedef void (^TransBlock)(NSDictionary * content);
/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface PickAreaViewController : UIViewController

@property(strong, nonatomic) PickerView *pickerView;
@property (nonatomic, readwrite) NSString *areaName;
@property (nonatomic, readwrite) NSString *provinceName;
@property (nonatomic, readwrite) NSString *cityName;
@property (nonatomic, readwrite) NSString *districtName;

@property (copy, nonatomic) TransBlock transBlock;//定义一个block属性，用于回传数据

//省级市
@property (nonatomic, strong) NSMutableArray *provinceList;
@property (nonatomic, strong) NSMutableArray *provinceInfoList;
@property (nonatomic, strong) NSMutableArray *provinceCodeList;
@property (nonatomic, strong) NSMutableArray *cityList;
@property (nonatomic, strong) NSMutableArray *cityCodeList;
@property (nonatomic, strong) NSMutableArray *cityInfoList;
@property (nonatomic, strong) NSMutableArray *districtList;
@property (nonatomic, strong) NSMutableArray *districtCodeList;
@property (nonatomic, strong) NSMutableArray *districtInfoList;

//名称
@property (nonatomic, readwrite) NSString *seletedProvinceName;
@property (nonatomic, readwrite) NSString *seletedCityName;
@property (nonatomic, readwrite) NSString *seletedDistrictName;
@property (nonatomic, readwrite) NSString *seletedProvinceCode;
@property (nonatomic, readwrite) NSString *seletedCityCode;

//view传值给vc
@property (nonatomic, copy) void(^blockAddressCodeForDistrict)(NSString *addressCode);

@end

NS_ASSUME_NONNULL_END
