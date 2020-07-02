//
//  RechargeViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RechargeViewController.h"
#import "RechargeTableViewCell.h"
#import "ShowAlertInfoTool.h"
#import "UITextField+LXDValidate.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RechargeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *conformButton;
@property (nonatomic, strong) RechargeTableViewCell *cell;

@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSInteger memberId;
@property (nonatomic, copy) NSString *moneyText;

@end

@implementation RechargeViewController


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cell.moneyNumberTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.cell.moneyNumberTextField.delegate = nil;
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

- (void)conform:(id)sender {
    if (self.moneyText && ![self.moneyText  isEqual: @""]) {
        if (!self.cell.moneyNumberTextField.validateMoney) {
            [ShowAlertInfoTool alertValidate:MoneyErrorInfo viewController:self];
        } else {
            double money = [self.moneyText doubleValue];
            if (money == 0) {
                [ShowAlertInfoTool alertSpecialInfo:ZeroErrorInfo viewController:self];
            } else {
                //充值接口
                self.urlRequest = [[URLRequest alloc] init];
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                
                NSString *moneyString = [NSString stringWithFormat:@"%f",money];
                [tempDict setObject:@"3" forKey:@"memberId"];
                [tempDict setObject:moneyString forKey:@"addNum"];
                __weak RechargeViewController *weakSelf = self;
                self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                    NSInteger errorStatusCode = [content[@"code"] integerValue];
                    if (errorStatusCode == 1) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [ShowAlertInfoTool alertSuccessInfo:RechargeMoneySuccessInfo viewController:weakSelf];
                    } else {
                        NSLog(@"%@",content[@"msg"]);
                    }
                };
                [self.urlRequest startRequest:tempDict pathUrl:@"/member/recharge"];
            }
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.moneyText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.moneyText = @"";
    return YES;
}


#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//设置为0不起作用
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"recharge"];
    if (!self.cell) {
        self.cell =  [[RechargeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recharge"];
    }
    self.cell.moneyNumberTextField.delegate = self;
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return self.cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.cell.moneyNumberTextField.delegate = self;
    
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
    
    self.conformButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.conformButton.layer.cornerRadius = 8;
    self.conformButton.layer.masksToBounds = YES;
    [self.conformButton setTitle:@"确认" forState:UIControlStateNormal];
    self.conformButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.conformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.conformButton setBackgroundColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1]];
    [self.conformButton addTarget:self action:@selector(conform:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conformButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.conformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@60);
        make.left.right.equalTo(self.view);
    }];
}

#pragma mark - Getters and Setters

@end
