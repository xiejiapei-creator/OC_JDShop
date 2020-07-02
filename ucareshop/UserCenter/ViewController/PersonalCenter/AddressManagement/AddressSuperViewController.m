//
//  AddressSuperViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddressSuperViewController.h"
#import "PickAreaViewController.h"
#import "ShowAlertInfoTool.h"
#import "UITextField+LXDValidate.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddressSuperViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) PickAreaViewController *pickAreaViewController;

@end

@implementation AddressSuperViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameCell.nameTextField.delegate = self;
    self.phoneNumberCell.phoneNumberTextField.delegate = self;
    self.postalCodeCell.postalCodeTextField.delegate = self;
    self.detailCell.detailTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.nameCell.nameTextField.delegate = nil;
    self.phoneNumberCell.phoneNumberTextField.delegate = nil;
    self.postalCodeCell.postalCodeTextField.delegate = nil;
    self.detailCell.detailTextField.delegate = nil;
    [self.view endEditing:YES];
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

- (void)changeColor:(id)sender {
    if (self.isCheck) {
        self.addAddressView.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.isCheck = NO;
    } else {
        self.addAddressView.maskLayer.strokeColor = [UIColor greenColor].CGColor;
        self.isCheck = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.nameCell.nameTextField == textField) {
        self.name = @"";
    }
    if (self.phoneNumberCell.phoneNumberTextField == textField) {
        self.phoneNumber = @"";
    }
    if (self.postalCodeCell.postalCodeTextField == textField) {
        self.postalCode = @"";
    }
    if (self.detailCell.detailTextField == textField) {
        self.detail = @"";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.nameCell.nameTextField == textField) {
        self.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.phoneNumberCell.phoneNumberTextField == textField) {
        self.phoneNumber = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.postalCodeCell.postalCodeTextField == textField) {
        self.postalCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.detailCell.detailTextField == textField) {
        self.detail = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}

//获取编辑完成后的内容
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.nameCell.nameTextField == textField) {
        self.name = textField.text;
    }
    if (self.phoneNumberCell.phoneNumberTextField == textField) {
        if ([textField validatePhoneNumber]) {
            self.phoneNumber = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:PhoneNumberErrorInfo viewController:self];
        }
    }
    if (self.postalCodeCell.postalCodeTextField == textField) {
        if ([textField validatePostCode]) {
            self.postalCode = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:PostCodeErrorInfo viewController:self];
        }
    }
    if (self.detailCell.detailTextField == textField) {
        self.detail = textField.text;
    }
}

#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//设置为0不起作用
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            self.nameCell = [tableView dequeueReusableCellWithIdentifier:@"name"];
            if (!self.nameCell) {
                self.nameCell = [[NewNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
            }
            
            self.nameCell.nameTextField.delegate = self;
            self.nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.nameCell;
        }
        case 1: {
            self.phoneNumberCell = [tableView dequeueReusableCellWithIdentifier:@"phone"];
            if (!self.phoneNumberCell) {
                self.phoneNumberCell = [[PhoneNumberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phone"];
            }
            self.phoneNumberCell.phoneNumberTextField.delegate = self;
            self.phoneNumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.phoneNumberCell;
        }
        case 2: {
            self.postalCodeCell = [tableView dequeueReusableCellWithIdentifier:@"postalCode"];
            if (!self.postalCodeCell) {
                self.postalCodeCell = [[PostalCodeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postalCode"];
            }
            self.postalCodeCell.postalCodeTextField.delegate = self;
            self.postalCodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.postalCodeCell;
        }
        case 3: {
            self.areaCell = [tableView dequeueReusableCellWithIdentifier:@"area"];
            if (!self.areaCell) {
                self.areaCell = [[AreaTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"area"];
            }
            self.areaCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.areaCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.areaCell.areaTextField.delegate = self;
            if (self.areaName) {
                self.areaCell.areaTextField.text = self.areaName;//这里顺序有问题
            }
            self.areaCell.areaTextField.allowsEditingTextAttributes = NO;
            return self.areaCell;
        }
        case 4: {
            self.detailCell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
            if (!self.detailCell) {
                self.detailCell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail"];
            }
            self.detailCell.detailTextField.delegate = self;
            self.detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //执行顺序不对，ditc 和 text（copy)不能联动
            return self.detailCell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        self.pickAreaViewController = [[PickAreaViewController alloc] init];
        self.pickAreaViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.pickAreaViewController animated:YES];
        

        __weak AddressSuperViewController *weakSelf = self;
        weakSelf.pickAreaViewController.transBlock = ^(NSDictionary * content) {
            self.provinceName = content[@"provinceName"];
            self.cityName = content[@"cityName"];
            self.districtName = content[@"districtName"];
            self.areaName = [NSString stringWithFormat:@"%@,%@,%@",self.provinceName,self.cityName,self.districtName];
            [self.tableView reloadData];//在代码块传值完成后刷行界面
        };
        [self.tableView reloadData];
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
}

// 添加子视图
- (void)createSubViews {
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.sectionHeaderHeight = 0.1;//还需要连着一块儿设置
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    //尾行
    self.addAddressView = [[AddAddressView alloc] init];
    [self.view addSubview:self.addAddressView];
    
    self.isCheck = NO;
    [self.addAddressView.checkButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@500);
    }];
    [self.addAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Getters and Setters

@end
