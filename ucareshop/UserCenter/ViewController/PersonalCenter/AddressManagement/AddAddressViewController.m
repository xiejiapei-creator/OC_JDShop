//
//  AddAddressViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddAddressViewController.h"
#import "ShowAlertInfoTool.h"
#import "UITextField+LXDValidate.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddAddressViewController ()
#pragma mark - 私有属性

@property(nonatomic) NSString *isDefault;

@end

@implementation AddAddressViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self.addAddressView.saveAddressButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

#pragma mark - Events

//添加地址
- (void)save:(id)sender {
    
    if (self.name && ![self.name  isEqual: @""] && self.phoneNumber && ![self.phoneNumber  isEqual: @""] && self.provinceName && ![self.provinceName  isEqual: @""] && self.cityName && ![self.cityName  isEqual: @""] && self.districtName && ![self.districtName  isEqual: @""] && self.postalCode && ![self.postalCode  isEqual: @""]  && self.detail && ![self.detail  isEqual: @""]) {
        if (self.isCheck) {
            self.isDefault = @"1";
        } else {
            self.isDefault = @"2";
        }
        
        if ([self.phoneNumberCell.phoneNumberTextField validatePhoneNumber] && [self.postalCodeCell.postalCodeTextField validatePostCode]) {
            
            //初始化
              self.urlRequest = [[URLRequest alloc] init];
              //参数字典
              NSArray *keysArr = [[NSArray alloc] initWithObjects:@"memberId",@"receiver",@"telephone",@"province",@"city",@"district",@"postcode",@"addrDetail",@"isDefault",nil];
              NSArray *valuesArr = [[NSArray alloc] initWithObjects:@"3",self.name,self.phoneNumber,self.provinceName,self.cityName,self.districtName,self.postalCode,self.detail,self.isDefault,nil];
              NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
              //上传内容
              __weak AddAddressViewController *weakSelf = self;
              self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                  NSInteger errorStatusCode = [content[@"code"] integerValue];
                   if (errorStatusCode == 1) {
                       //跳转
                       [weakSelf.navigationController popViewControllerAnimated:YES];
                       NSLog(@"添加地址成功");
                   } else {
                       NSLog(@"%@",content[@"msg"]);
                   }
              };
              [self.urlRequest startRequest:dict pathUrl:@"/address/addAddress"];
            
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"添加地址";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Getters and Setters

@end
