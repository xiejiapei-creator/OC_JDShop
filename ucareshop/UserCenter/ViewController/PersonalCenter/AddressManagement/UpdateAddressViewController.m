//
//  UpdateAddressViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "UpdateAddressViewController.h"
#import "ShowAlertInfoTool.h"
#import "UITextField+LXDValidate.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface UpdateAddressViewController ()

#pragma mark - 私有属性

@property(nonatomic) NSString *isDefault;

@end

@implementation UpdateAddressViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    
    //获取单个详细地址
    self.urlRequest = [[URLRequest alloc] init];
    self.updateAddressInfoDict = [[NSDictionary alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:self.updateAddressId forKey:@"addressId"];
    __weak UpdateAddressViewController *weakSelf = self;
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.updateAddressInfoDict = dict[@"re"];
            //设置默认文本
            weakSelf.nameCell.nameTextField.text = weakSelf.updateAddressInfoDict[@"receiver"];
            weakSelf.name = weakSelf.updateAddressInfoDict[@"receiver"];
            weakSelf.phoneNumberCell.phoneNumberTextField.text = weakSelf.updateAddressInfoDict[@"telephone"];
            weakSelf.phoneNumber = weakSelf.updateAddressInfoDict[@"telephone"];
            weakSelf.postalCodeCell.postalCodeTextField.text = weakSelf.updateAddressInfoDict[@"postcode"];
            weakSelf.postalCode = weakSelf.updateAddressInfoDict[@"postcode"];
            weakSelf.detailCell.detailTextField.text = weakSelf.updateAddressInfoDict[@"addrDetail"];
            weakSelf.detail = weakSelf.updateAddressInfoDict[@"addrDetail"];
            //地区
            NSString *province = weakSelf.updateAddressInfoDict[@"province"];
            weakSelf.provinceName = weakSelf.updateAddressInfoDict[@"province"];
            NSString *city = weakSelf.updateAddressInfoDict[@"city"];
            weakSelf.cityName = weakSelf.updateAddressInfoDict[@"city"];
            NSString *district = weakSelf.updateAddressInfoDict[@"district"];
            weakSelf.districtName = weakSelf.updateAddressInfoDict[@"district"];
            NSString *areaName = [NSString stringWithFormat:@"%@,%@,%@",province,city,district];
            weakSelf.areaCell.areaTextField.text = areaName;
            //选中状态
            NSInteger checkStatus = [weakSelf.updateAddressInfoDict[@"isDefault"] integerValue];
            if (checkStatus == 1) {
                weakSelf.addAddressView.maskLayer.strokeColor = [UIColor greenColor].CGColor;
                weakSelf.isCheck = YES;
            } else {
                weakSelf.addAddressView.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
                weakSelf.isCheck = NO;
            }
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/address/getAddress"];
    [self.addAddressView.saveAddressButton addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Events

- (void)update:(UIButton *)sender {
    
    if (self.isCheck) {
        self.isDefault = @"1";
    } else {
        self.isDefault = @"2";
    }
    
    if (self.updateAddressId && ![self.updateAddressId  isEqual: @""] && self.name && ![self.name  isEqual: @""] && self.phoneNumber && ![self.phoneNumber  isEqual: @""] && self.provinceName && ![self.provinceName  isEqual: @""] && self.cityName && ![self.cityName  isEqual: @""] && self.districtName && ![self.districtName  isEqual: @""] && self.postalCode && ![self.postalCode  isEqual: @""]  && self.detail && ![self.detail  isEqual: @""]) {
        
        if ([self.phoneNumberCell.phoneNumberTextField validatePhoneNumber] && [self.postalCodeCell.postalCodeTextField validatePostCode]) {
            NSArray *values = [[NSArray alloc] initWithObjects:self.updateAddressId,self.name,self.phoneNumber,self.provinceName,self.cityName,self.districtName,self.postalCode,self.detail,self.isDefault,nil];
            
            NSArray *keys = [[NSArray alloc] initWithObjects:@"id",@"receiver",@"telephone",@"province",@"city",@"district",@"postcode",@"addrDetail",@"isDefault",nil];

            NSDictionary *dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            
            __weak UpdateAddressViewController *weakSelf = self;
            self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                NSInteger errorStatusCode = [content[@"code"] integerValue];
                if (errorStatusCode == 1) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    NSLog(@"更新地址成功");
                } else {
                    NSLog(@"%@",content[@"msg"]);
                }
            };
            [self.urlRequest startRequest:dict pathUrl:@"/address/updateAddress"];
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"修改地址";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Getters and Setters

@end
