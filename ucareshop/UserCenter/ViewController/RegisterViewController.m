//
//  RegisterViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/28.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RegisterViewController.h"
#import "RegisterView.h"
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "LoginViewController.h"
#import "RetrievePasswordViewController.h"
#import "UserProtocolViewController.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RegisterViewController () <UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) RegisterView *registerView;
@property (nonatomic, strong) URLRequest *urlRequest;
//用户输入
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSString *password;
//系统核实
@property (nonatomic) NSInteger statusCode;
//验证码
@property (nonatomic, strong) URLRequest *urlRequestForVerificationCode;
@property (nonatomic) NSInteger statusCodeForVerificationCode;

@end

@implementation RegisterViewController

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
    self.registerView.phoneNumberTextField.delegate = self;
    self.registerView.codeTextField.delegate = self;
    self.registerView.passwordTextField.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.registerView.phoneNumberTextField.delegate = nil;
    self.registerView.codeTextField.delegate = nil;
    self.registerView.passwordTextField.delegate = nil;
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

//注册
- (void)registerSuccess:(UIButton *)sender {
    if (![self.password  isEqual: @""] && ![self.phoneNumber  isEqual: @""] && ![self.verificationCode  isEqual: @""] && self.password && self.phoneNumber && self.verificationCode) {
        
        if (self.registerView.isCheck) {
            
            if ([self validatePhoneNumberForLogin:self.phoneNumber] && [self.registerView.passwordTextField validatePassword] && [self.registerView.codeTextField validateAuthen]) {
                //post
                NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"password",@"type",@"code",nil];
                NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,self.password,@(1),self.verificationCode,nil];
                NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
                
                self.urlRequest = [[URLRequest alloc] init];
                __weak RegisterViewController *weakSelf = self;
                self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                    NSInteger errorStatusCode = [content[@"code"] integerValue];
                    if (errorStatusCode == 1) {
                        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                        weakSelf.statusCode = [dict[@"code"] integerValue];
                        if (weakSelf.statusCode == 1) {
                            LoginViewController *loginViewController = [[LoginViewController alloc] init];
                            loginViewController.hidesBottomBarWhenPushed = YES;
                            [weakSelf.navigationController pushViewController:loginViewController animated:YES];
                        }
                        if (weakSelf.statusCode == 3) {
                            [ShowAlertInfoTool alertSpecialInfo:PhoneNumberUsedInfo viewController:weakSelf];
                        }
                        if (weakSelf.statusCode == 2) {
                            [ShowAlertInfoTool alertSpecialInfo:VerificationCodeNotMatchInfo viewController:weakSelf];
                        }
                    } else {
                        NSLog(@"%@",content[@"msg"]);
                    }
                };
                [self.urlRequest startRequest:dict pathUrl:@"/home/register"];
            } else {
                [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
            }
        } else {
            [ShowAlertInfoTool alertSpecialInfo:ProtocolNotRead viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyInfo viewController:self];
    }
}
//用户协议
- (void)userProtocol:(UIButton *)sender {
    UserProtocolViewController *userProtocolViewController = [[UserProtocolViewController alloc] init];
    userProtocolViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userProtocolViewController animated:YES];
}
//发送验证码
- (void)sendCodeMessage:(UIButton *)sender {
    
    //及时改变值，clearMode会保存phoneNumber的值，错误发送验证码
    if ([self validatePhoneNumberForLogin:self.registerView.phoneNumberTextField.text]) {
        NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"type",nil];
        NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,@"1",nil];
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];
        self.urlRequestForVerificationCode = [[URLRequest alloc] init];
        __weak RegisterViewController *weakSelf = self;
        self.urlRequestForVerificationCode.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                weakSelf.statusCodeForVerificationCode = [dict[@"code"] integerValue];
                if (weakSelf.statusCodeForVerificationCode == 1) {
                    [weakSelf.registerView startTime];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.registerView.phoneNumberTextField == textField) {
        NSString *phone = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.phoneNumber = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if (self.registerView.passwordTextField == textField) {
        self.password = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    if (self.registerView.codeTextField == textField) {
        self.verificationCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.registerView.phoneNumberTextField == textField) {
        self.phoneNumber = @"";
    }
    if (self.registerView.passwordTextField == textField) {
        self.password = @"";
    }
    if (self.registerView.codeTextField == textField) {
        self.verificationCode = @"";
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.registerView.phoneNumberTextField == textField) {
        NSString *phone = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([self validatePhoneNumberForLogin:phone]) {
            self.phoneNumber = phone;
        } else {
            [ShowAlertInfoTool alertValidate:PhoneNumberErrorInfo viewController:self];
        }
    }
    if (self.registerView.passwordTextField == textField) {
        if ([textField validatePassword]) {
            self.password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            } else {
            [ShowAlertInfoTool alertValidate:PasswordErrorInfo viewController:self];
            }
    }
    if (self.registerView.codeTextField == textField) {
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
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.registerView = [[RegisterView alloc] init];
    [self.registerView.conformButton addTarget:self action:@selector(registerSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.sendCodeButton addTarget:self action:@selector(sendCodeMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.registerView.agreementButton addTarget:self action:@selector(userProtocol:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerView];
    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
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
