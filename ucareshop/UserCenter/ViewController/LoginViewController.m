//
//  LoginViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "RetrievePasswordViewController.h"
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "HomeViewController.h"
#import "URLRequest.h"
#import "UITextField+LXDValidate.h"
#import "AppDelegate.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface LoginViewController () <UITextFieldDelegate>

#pragma mark - 私有属性


@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) URLRequest *urlRequest;
//用户输入
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *password;
//系统核实
@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSString *mobile;

@end

@implementation LoginViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.loginView.phoneNumberTextField.delegate = self;
    self.loginView.passwordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.loginView.phoneNumberTextField.delegate = nil;
    self.loginView.passwordTextField.delegate = nil;
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
- (void)registerAccount:(UIButton *)sender {
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}
//找回密码
- (void)retrievePassword:(UIButton *)sender {
    RetrievePasswordViewController *retrievePasswordViewController = [[RetrievePasswordViewController alloc] init];
    retrievePasswordViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:retrievePasswordViewController animated:YES];
}
//跳转到首页
- (void)goHome {
    self.loginView.phoneNumberTextField.delegate = nil;
    self.loginView.passwordTextField.delegate = nil;
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 0;
}
//登录
- (void)loginSuccess:(UIButton *)sender {
    
    if (self.password && self.phoneNumber && ![self.password  isEqual: @""] && ![self.phoneNumber  isEqual: @""]) {
        
        if ([self validatePhoneNumberForLogin:self.phoneNumber] && [self validatePassword:self.password] ) {
            //post
            NSArray *keysArr = [[NSArray alloc] initWithObjects:@"telephone",@"password",nil];
            NSArray *valuesArr = [[NSArray alloc] initWithObjects:self.phoneNumber,self.password,nil];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:valuesArr forKeys:keysArr];        
            self.urlRequest = [[URLRequest alloc] init];
            __weak LoginViewController *weakSelf = self;
            self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
                NSInteger errorStatusCode = [content[@"code"] integerValue];
                if (errorStatusCode == 1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:content[@"content"]];
                    weakSelf.statusCode = [dict[@"code"] integerValue];
                    if (self.statusCode == 1) {
                        NSDictionary *memberRe = [NSDictionary dictionaryWithDictionary:dict[@"re"]];
                        weakSelf.memberID = [memberRe[@"id"] integerValue];
                        
                        //存储uid到本地
                        NSString *uid = content[@"uid"];
                        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                        NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
                        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] init];
                        
                        [plistDict setValue:uid forKey:@"uid"];
                        [plistDict setValue:@(1) forKey:@"statusCode"];
                        [plistDict setValue:weakSelf.phoneNumber forKey:@"phoneNumber"];
                        [plistDict setValue:@(weakSelf.memberID) forKey:@"memberID"];
                        [plistDict setValue:weakSelf.password forKey:@"password"];
                        [plistDict writeToFile:filePath atomically:YES];
                        
                        
                        
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        
                        URLRequest *urlRequestForOrderNumber = [[URLRequest alloc] init];
                        urlRequestForOrderNumber.transDataBlock = ^(NSDictionary * _Nonnull content) {
                            NSInteger errorStatusCode = [content[@"code"] integerValue];
                            if (errorStatusCode == 1) {
                                NSInteger count = [content[@"content"] integerValue];
                                NSString *num  = [NSString stringWithFormat:@"%ld",(long)count];
                                delegate.shoppingCartNavigationController.tabBarItem.badgeValue = num;
                            } else {
                                NSLog(@"%@",content[@"msg"]);
                            }
                        };
                        [urlRequestForOrderNumber startRequest:nil pathUrl:@"/order/getCartGoodsNum"];
                        
                        
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                        tab.selectedIndex = 0;
                    }
                    if (weakSelf.statusCode == 2) {
                        [ShowAlertInfoTool alertSpecialInfo:PhoneNumerNotExitInfo viewController:weakSelf];
                    }
                    if (weakSelf.statusCode == 3)  {
                        [ShowAlertInfoTool alertSpecialInfo:MismatchWarningInfo viewController:weakSelf];
                    }
                } else {
                    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
                    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
                    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                    [plistDict setObject:@(0) forKey:@"statusCode"];
                    [plistDict writeToFile:filePath atomically:YES];
                    NSLog(@"%@",content[@"msg"]);
                }
            };
            [self.urlRequest startRequest:dict pathUrl:@"/home/login"];
        } else {
            [ShowAlertInfoTool alertSpecialInfo:InputErrorInfo viewController:self];
        }
    } else {
        [ShowAlertInfoTool alertSpecialInfo:EmptyNumberWarningInfo viewController:self];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.loginView.phoneNumberTextField ) {
        self.phoneNumber = @"";
    }
    if (self.loginView.passwordTextField == textField) {
        self.password = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.loginView.phoneNumberTextField ) {
        NSString *phone = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.phoneNumber = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }
    if (self.loginView.passwordTextField == textField) {
        NSString *password = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.loginView.phoneNumberTextField ) {
        NSString *phone = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([self validatePhoneNumberForLogin:phone]) {
            self.phoneNumber = phone;
        } else {
            [ShowAlertInfoTool alertValidate:PhoneNumberErrorInfo viewController:self];
        }
    }
    if (self.loginView.passwordTextField == textField) {
        NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([self validatePassword:password]) {
            self.password = password;
        } else {
            [ShowAlertInfoTool alertValidate:PasswordErrorInfo viewController:self];
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
    self.title = @"登陆";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.loginView = [[LoginView alloc] init];
    [self.loginView.createAccountButton addTarget:self action:@selector(registerAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.forgetPasswordButton addTarget:self action:@selector(retrievePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.loginButton addTarget:self action:@selector(loginSuccess:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginView];
    
    UIBarButtonItem *goHome = [[UIBarButtonItem alloc ] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = goHome;
    
    self.loginView.phoneNumberTextField.delegate = self;
    self.loginView.passwordTextField.delegate = self;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (BOOL)validatePhoneNumberForLogin: (NSString *)phoneNumber
{
    NSString * reg = @"^\\d{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", reg];
    return [predicate evaluateWithObject: phoneNumber];
}
- (BOOL)validatePassword:(NSString *)password
{
    NSString * length = @"^\\w{6,20}$";    //长度
    NSString * number = @"^\\w*\\d+\\w*$";   //数字
    NSString * lower = @"^\\w*[a-z]+\\w*$";   //小写字母
    NSString * upper = @"^\\w*[A-Z]+\\w*$";  //大写字母
    
    return [self validateWithRegExp: length :password] && [self validateWithRegExp: number :password] && [self validateWithRegExp: lower :password] && [self validateWithRegExp: upper :password];
}
- (BOOL)validateWithRegExp: (NSString *)regExp :(NSString *)password
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject: password];
}

#pragma mark - Getters and Setters

@end
