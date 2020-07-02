//
//  AccountNumberTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/28.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "LoginView.h"
#import "RegisterViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface LoginView ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UIImageView *profileimageView;
@property (nonatomic, readwrite) UIImageView *passwordImageView;
@property (nonatomic, readwrite) UITextField *phoneNumberTextField;
@property (nonatomic, readwrite) UITextField *passwordTextField;
@property (nonatomic, readwrite) UISwitch *secretSwitch;
@property (nonatomic, readwrite) UIButton *forgetPasswordButton;
@property (nonatomic, readwrite) UIButton *loginButton;
@property (nonatomic, readwrite) UIButton *createAccountButton;

@property (nonatomic, readwrite) UIImageView *logo;

@end

@implementation LoginView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

#pragma mark - Events

//切换明文/密文
- (void)secureSwitchAction:(UISwitch *)sender {
    //切换
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    //去掉光标空白部分
    NSString* text = self.passwordTextField.text;
    self.passwordTextField.text = @" ";
    self.passwordTextField.text = text;
//    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.profileimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_LoginViewController_id"]];
    self.passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_LoginViewController_lock"]];
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneNumberTextField.placeholder = @"手机号码";
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:18];
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.placeholder = @"登陆密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
//    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.secretSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.secretSwitch addTarget:self action:@selector(secureSwitchAction:) forControlEvents:UIControlEventValueChanged];
    self.secretSwitch.on = YES;
    [self.passwordTextField setSecureTextEntry:YES];
    
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.forgetPasswordButton setTitleColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1] forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.forgetPasswordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.masksToBounds = YES;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.loginButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1];
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:25];
    
    
    self.createAccountButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.createAccountButton setTitleColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1] forState:UIControlStateNormal];
    [self.createAccountButton setTitle:@"创建账号" forState:UIControlStateNormal];
    self.createAccountButton.titleLabel.font = [UIFont systemFontOfSize:22];
    
    
    [self addSubview:self.profileimageView];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.passwordImageView];
    [self addSubview:self.phoneNumberTextField];
    [self addSubview:self.secretSwitch];
    [self addSubview:self.createAccountButton];
    [self addSubview:self.loginButton];
    [self addSubview:self.forgetPasswordButton];
    //线条
    UIBezierPath *linePathTop = [UIBezierPath bezierPath];
    [linePathTop  moveToPoint:CGPointMake(0, 130)];
    [linePathTop  addLineToPoint:CGPointMake(500, 130)];
    CAShapeLayer *maskLayerTop = [CAShapeLayer layer];
    maskLayerTop.path = linePathTop.CGPath;
    maskLayerTop.strokeColor = [UIColor grayColor].CGColor;
    maskLayerTop.lineWidth = 1.0;
    maskLayerTop.frame = CGRectMake(0, 125, 500, 10);
    [self.layer addSublayer:maskLayerTop];
    
    UIBezierPath *linePathBottom = [UIBezierPath bezierPath];
    [linePathBottom moveToPoint:CGPointMake(0, 175)];
    [linePathBottom addLineToPoint:CGPointMake(500, 175)];
    CAShapeLayer *maskLayerBottom = [CAShapeLayer layer];
    maskLayerBottom.path = linePathBottom.CGPath;
    maskLayerBottom.strokeColor = [UIColor grayColor].CGColor;
    maskLayerBottom.lineWidth = 1.0;
    maskLayerBottom.frame = CGRectMake(0, 170, 500, 10);
    [self.layer addSublayer:maskLayerBottom];
    
    //矩形
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(167, 105, 80, 80)];
    logo.image = [UIImage imageNamed:@"userCenter_UserCenterViewController_profile"];
    [self addSubview:logo];
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(72, 40, 90, 90)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = rectPath.CGPath;
    maskLayer.lineWidth = 1.0;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:250.0/255.0 alpha:0.2].CGColor;
    maskLayer.frame = CGRectMake(90, 60, 100, 100);
    [self.layer addSublayer:maskLayer];
    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.profileimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(210);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo (@30);
        make.height.equalTo(@30);
    }];
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.left.equalTo(self).offset(20);
        make.width.equalTo (@30);
        make.height.equalTo(@30);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(210);
        make.left.equalTo(self.profileimageView.mas_right).offset(20);
        make.right.equalTo (self.mas_right);
        make.height.equalTo(@40);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.left.equalTo(self.passwordImageView.mas_right).offset(20);
        make.right.equalTo (self.mas_right);
        make.height.equalTo(@40);
    }];
    [self.secretSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo (@50);
        make.height.equalTo(@40);
    }];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secretSwitch.mas_bottom).offset(50);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo (@150);
        make.height.equalTo(@20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPasswordButton.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo (@300);
        make.height.equalTo(@50);
    }];
    [self.createAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo (@150);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Getters and Setters

@end
