//
//  RetrievePasswordViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RetrievePasswordViewController.h"
#import "RetrieveView.h"
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "LoginViewController.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RetrievePasswordViewController () <UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) RetrieveView *retrieveView;
@property (nonatomic, strong) URLRequest *urlRequestForVerificationCode;
@property (nonatomic, strong) URLRequest *urlRequestForPassword;
//用户输入
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *password;
//系统核实
@property (nonatomic) NSInteger statusCodeForVerificationCode;
@property (nonatomic) NSInteger statusCodeForPassword;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSString *mobile;

@end

@implementation RetrievePasswordViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.retrieveView.phoneNumberTextField.delegate = self;
    self.retrieveView.codeTextField.delegate = self;
    self.retrieveView.passwordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.retrieveView.phoneNumberTextField.delegate = nil;
    self.retrieveView.codeTextField.delegate = nil;
    self.retrieveView.passwordTextField.delegate = nil;
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


//修改密码
- (void)RetrievePasswordSuccess:(UIButton *)sender {
    if (self.password && self.phoneNumber && self.verificationCode && ![self.password  isEqual: @""] && ![self.phoneNumber  isEqual: @""] && ![self.verificationCode  isEqual: @""]) {
        
        if ([self.retrieveView.phoneNumberTextField validatePhoneNumber] && [self.retrieveView.passwordTextField validatePassword] && [self.retrieveView.codeTextField validateAuthen]) {
            NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"validCode",@"newPassword",nil];
            NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,self.verificationCode,self.password,nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
            self.urlRequestForPassword = [[URLRequest alloc] init];
            __weak RetrievePasswordViewController *weakSelf = self;
            self.urlRequestForPassword.transDataBlock = ^(NSDictionary * _Nonnull content) {
                NSInteger errorStatusCode = [content[@"code"] integerValue];
                if (errorStatusCode == 1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                    NSInteger statusCode = [dict[@"code"] integerValue];
                    if (statusCode == 1) {
                        [ShowAlertInfoTool alertSuccessInfo:PasswordChangeSuccessInfo viewController:weakSelf];
                        LoginViewController *loginViewController = [[LoginViewController alloc] init];
                        loginViewController.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:loginViewController animated:YES];
                    }
                    if (statusCode == 2) {
                        [ShowAlertInfoTool alertSpecialInfo:VerificationCodeNotMatchInfo viewController:weakSelf];
                    }
                } else {
                    NSLog(@"%@",content[@"msg"]);
                }
            };
            [self.urlRequestForPassword startRequest:dict pathUrl:@"/member/findPassword"];
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}
//发送验证码
- (void)sendCodeMessage:(UIButton *)sender {
    if ([self validatePhoneNumberForLogin:self.retrieveView.phoneNumberTextField.text]) {
        NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"type",nil];
        NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,@"7",nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
        self.urlRequestForVerificationCode = [[URLRequest alloc] init];
        __weak RetrievePasswordViewController *weakSelf = self;
        self.urlRequestForVerificationCode.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                weakSelf.statusCodeForVerificationCode = [dict[@"code"] integerValue];
                if (weakSelf.statusCodeForVerificationCode == 1) {
                    [weakSelf.retrieveView startTime];
                    [ShowAlertInfoTool alertSpecialInfo:VerificationCode viewController:weakSelf];
                }
                if (weakSelf.statusCodeForVerificationCode == 2) {
                    [ShowAlertInfoTool alertSpecialInfo:PhoneNumerNotExitInfo viewController:weakSelf];
                }
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [self.urlRequestForVerificationCode startRequest:dict pathUrl:@"/home/getCode"];
    } else {
        [ShowAlertInfoTool alertValidate:PhoneNumberErrorInfo viewController:self];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (self.retrieveView.phoneNumberTextField == textField) {
        self.phoneNumber = @"";
    }
    if (self.retrieveView.passwordTextField == textField) {
        self.password = @"";
    }
    if (self.retrieveView.codeTextField == textField) {
        self.verificationCode = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.retrieveView.phoneNumberTextField == textField) {
        NSString *phone = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.phoneNumber = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if (self.retrieveView.passwordTextField == textField) {
        self.password = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.retrieveView.codeTextField == textField) {
        self.verificationCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.retrieveView.phoneNumberTextField == textField) {
        if ([textField validatePhoneNumber]) {
            self.phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        } else {
            [ShowAlertInfoTool alertValidate:PhoneNumberErrorInfo viewController:self];
        }
    }
    if (self.retrieveView.passwordTextField == textField) {
        if ([textField validatePassword]) {
            self.password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        } else {
            [ShowAlertInfoTool alertValidate:PasswordErrorInfo viewController:self];
        }
    }
    if (self.retrieveView.codeTextField == textField) {
        if ([textField validateAuthen]) {
            self.verificationCode = textField.text;
        } else {
            [ShowAlertInfoTool alertValidate:VerificationCodeErrorInfo viewController:self];
        }
    }
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.retrieveView = [[RetrieveView alloc] init];
    [self.retrieveView.conformButton addTarget:self action:@selector(RetrievePasswordSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.retrieveView.sendCodeButton addTarget:self action:@selector(sendCodeMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.retrieveView];
    
    self.retrieveView.phoneNumberTextField.delegate = self;
    self.retrieveView.passwordTextField.delegate = self;
    self.retrieveView.codeTextField.delegate = self;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.retrieveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (BOOL)validatePhoneNumberForLogin: (NSString *)phoneNumber
{
    NSString * reg = @"^\\d{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject: phoneNumber];
}
#pragma mark - Getters and Setters

@end
