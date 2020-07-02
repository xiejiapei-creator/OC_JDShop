//
//  ChangePasswordViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ChangePasswordViewController.h"
#import "OldPasswordTableViewCell.h"
#import "NewPasswordTableViewCell.h"
#import "ConfirmTableViewCell.h"
#import "VerificationCodeTableViewCell.h"
#import "ShowAlertInfoTool.h"
#import "UITextField+LXDValidate.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ChangePasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
#pragma mark - 私有属性
@property (nonatomic, strong) UIBarButtonItem *saveButtonItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) OldPasswordTableViewCell *oldPasswordCell;
@property (nonatomic, strong) NewPasswordTableViewCell *passwordCell;
@property (nonatomic, strong) ConfirmTableViewCell * confirmCell;
@property (nonatomic, strong) VerificationCodeTableViewCell * codeCell;
@property (nonatomic, strong) NSString *oldPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *confirmPassword;
@property (nonatomic, strong) NSString *code;


@property (nonatomic, strong) URLRequest *urlRequestForVerificationCode;
@property (nonatomic, strong) URLRequest *urlRequestForPassword;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSString *mobile;


@end

@implementation ChangePasswordViewController

{
    int waitTime;
    NSTimer *timer;//定时器
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.codeCell.inputVerificationCodeTextField.delegate = self;
    self.confirmCell.confirmPasswordTextField.delegate = self;
    self.passwordCell.inputNewPasswordTextField.delegate = self;
    self.oldPasswordCell.inputPasswordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.codeCell.inputVerificationCodeTextField.delegate = nil;
    self.confirmCell.confirmPasswordTextField.delegate = nil;
    self.passwordCell.inputNewPasswordTextField.delegate = nil;
    self.oldPasswordCell.inputPasswordTextField.delegate = nil;
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

//发送验证码
- (void)sendCode:(id)sender {
    [self startTime];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"15659281705" forKey:@"telephone"];
    self.urlRequestForVerificationCode = [[URLRequest alloc] init];
    __weak ChangePasswordViewController *weakSelf = self;
    self.urlRequestForVerificationCode.transDataBlock = ^(NSDictionary * _Nonnull content) {
         NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            [ShowAlertInfoTool alertSpecialInfo:VerificationCode viewController:weakSelf];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [self.urlRequestForVerificationCode startRequest:dict pathUrl:@"/member/sendValidCode4UpdatePassword"];
}

//保存
- (void)save:(id)sender {
    if (self.password && self.oldPassword && self.confirmPassword && self.code && ![self.password  isEqual: @""] && ![self.oldPassword  isEqual: @""] && ![self.confirmPassword  isEqual: @""] && ![self.code  isEqual: @""]) {
        
        if ([self.oldPasswordCell.inputPasswordTextField validatePassword] && [self.passwordCell.inputNewPasswordTextField validatePassword] && [self.confirmPassword isEqualToString:self.password] && [self.codeCell.inputVerificationCodeTextField validateAuthen]) {
            NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"oldPassword",@"newPassword",@"validCode",nil];
            NSArray *valuesArr = [[NSArray alloc] initWithObjects:@"15659281705",self.oldPassword,self.password,self.code,nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
            self.urlRequestForPassword = [[URLRequest alloc] init];
            __weak ChangePasswordViewController *weakSelf = self;
            self.urlRequestForPassword.transDataBlock = ^(NSDictionary * _Nonnull content) {
                NSInteger errorStatusCode = [content[@"code"] integerValue];
                if (errorStatusCode == 1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                    NSInteger statusCode = [dict[@"code"] integerValue];
                    if (statusCode == 1) {
                        [ShowAlertInfoTool alertSuccessInfo:PasswordChangeSuccessInfo viewController:weakSelf];
                    }
                    if (statusCode == 2) {
                        [ShowAlertInfoTool alertSpecialInfo:OldPasswordErrorInfo viewController:weakSelf];
                    }
                    if (statusCode == 4) {
                        [ShowAlertInfoTool alertSpecialInfo:VerificationCodeNotMatchInfo viewController:weakSelf];
                    }
                    if (statusCode == 3) {
                        [ShowAlertInfoTool alertSpecialInfo:OldAndNewPasswordMismatchedInfo viewController:weakSelf];
                    }
                } else {
                   NSLog(@"%@",content[@"msg"]);
                }
            };
            [self.urlRequestForPassword startRequest:dict pathUrl:@"/member/updatePassword"];
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
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
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.passwordCell.inputNewPasswordTextField == textField) {
        self.password = @"";
    }
    if (self.oldPasswordCell.inputPasswordTextField == textField) {
        self.oldPassword = @"";
    }
    if (self.confirmCell.confirmPasswordTextField == textField) {
        self.confirmPassword = @"";
    }
    if (self.codeCell.inputVerificationCodeTextField == textField) {
        self.code = @"";
    } 
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.passwordCell.inputNewPasswordTextField == textField) {
        self.password = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.oldPasswordCell.inputPasswordTextField == textField) {
        self.oldPassword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.confirmCell.confirmPasswordTextField == textField) {
        self.confirmPassword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.codeCell.inputVerificationCodeTextField == textField) {
        self.code = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return YES;
}

//获取编辑完成后的内容 （改动）
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.oldPasswordCell.inputPasswordTextField == textField) {
        if ([textField validatePassword]) {
            self.oldPassword = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:PasswordErrorInfo viewController:self];
        }
    }
    if (self.passwordCell.inputNewPasswordTextField == textField) {
        if ([textField validatePassword]) {
            self.password = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:PasswordErrorInfo viewController:self];
        }
    }
    if (self.confirmCell.confirmPasswordTextField == textField) {
        if ([textField.text isEqualToString:self.password]) {
            self.confirmPassword = textField.text;
        } else {
            [ShowAlertInfoTool alertSpecialInfo:OldAndNewPasswordMismatchedInfo viewController:self];
        }
    }
    if (self.codeCell.inputVerificationCodeTextField == textField) {
        if ([textField validateAuthen]) {
            self.code = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:VerificationCodeErrorInfo viewController:self];
        }
    }
}

#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            self.oldPasswordCell = [tableView dequeueReusableCellWithIdentifier:@"oldPassword"];
            if (!self.oldPasswordCell) {
                self.oldPasswordCell = [[OldPasswordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oldPassword"];
            }
            self.oldPasswordCell.inputPasswordTextField.delegate = self;
            self.oldPasswordCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.oldPasswordCell;
        }
        case 1: {
            self.passwordCell = [tableView dequeueReusableCellWithIdentifier:@"newPassword"];
            if (!self.passwordCell) {
                self.passwordCell = [[NewPasswordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPassword"];
            }
            self.passwordCell.inputNewPasswordTextField.delegate = self;
            self.passwordCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.passwordCell;
        }
        case 2: {
            self.confirmCell = [tableView dequeueReusableCellWithIdentifier:@"confirm"];
            if (!self.confirmCell) {
                self.confirmCell = [[ConfirmTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirm"];
            }
            self.confirmCell.confirmPasswordTextField.delegate = self;
            self.confirmCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.confirmCell;
        }
        case 3: {
            self.codeCell = [tableView dequeueReusableCellWithIdentifier:@"verificationCode"];
            if (!self.codeCell) {
                self.codeCell = [[VerificationCodeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"verificationCode"];
            }
            self.codeCell.inputVerificationCodeTextField.delegate = self;
            [self.codeCell.sendVerificationCodeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
            self.codeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.codeCell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - 开始计时

- (void)startTime {
    [timer invalidate];
    waitTime = 60;
    [self updateVareyButton];
    __weak ChangePasswordViewController *weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(updateWaitTime) userInfo:nil repeats:YES];
}
- (void)updateVareyButton {
     NSString *title = @"获取验证码";
    if (waitTime > 0) {
        title = [NSString stringWithFormat:@"%d秒后重发",waitTime];
        [self.codeCell.sendVerificationCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.codeCell.sendVerificationCodeButton.userInteractionEnabled = NO;
    }
    [self.codeCell.sendVerificationCodeButton setTitle:title forState:UIControlStateNormal];
}
- (void)updateWaitTime {
    waitTime = waitTime - 1;
    [self updateVareyButton];
    if (waitTime <= 0) {
        [self.codeCell.sendVerificationCodeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self.codeCell.sendVerificationCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.codeCell.sendVerificationCodeButton.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"修改密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - Getters and Setters

    
@end
