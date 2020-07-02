//
//  RetrieveView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RetrieveView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RetrieveView ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UIImageView *profileimageView;
@property (nonatomic, readwrite) UIImageView *chatImageView;
@property (nonatomic, readwrite) UIImageView *passwordImageView;
@property (nonatomic, readwrite) UITextField *passwordTextField;
@property (nonatomic, readwrite) UITextField *codeTextField;
@property (nonatomic, readwrite) UITextField *phoneNumberTextField;
@property (nonatomic, readwrite) UISwitch *secretSwitch;
@property (nonatomic, readwrite) UIButton *sendCodeButton;
@property (nonatomic, readwrite) UIButton *conformButton;

@end

@implementation RetrieveView

{
    int waitTime;
    NSTimer *timer;//定时器
}

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
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - 开始计时

- (void)startTime {
    [timer invalidate];
    waitTime = 60;
    [self updateVareyButton];
    __weak RetrieveView *weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(updateWaitTime) userInfo:nil repeats:YES];
}
- (void)updateVareyButton {
    NSString *title = @"获取验证码";
    if (waitTime > 0) {
        title = [NSString stringWithFormat:@"%d秒后重发",waitTime];
        [self.sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.sendCodeButton.userInteractionEnabled = NO;
    }
    [self.sendCodeButton setTitle:title forState:UIControlStateNormal];
}
- (void)updateWaitTime {
    waitTime = waitTime - 1;
    [self updateVareyButton];
    if (waitTime <= 0) {
        [self.sendCodeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self.sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.sendCodeButton.userInteractionEnabled = YES;
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.profileimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_LoginViewController_id"]];
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneNumberTextField.placeholder = @"手机号码";
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:18];
   
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    self.chatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_registerViewController_message"]];
    self.passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_LoginViewController_lock"]];
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.codeTextField.placeholder = @"短信验证码";
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.font = [UIFont systemFontOfSize:18];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.placeholder = @"输入新的登录密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
//    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    self.conformButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.conformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.conformButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1];
    [self.conformButton setTitle:@"确认" forState:UIControlStateNormal];
    self.conformButton.titleLabel.font = [UIFont systemFontOfSize:24];
    self.conformButton.layer.cornerRadius = 8;
    self.conformButton.layer.masksToBounds = YES;
    
    self.secretSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.secretSwitch addTarget:self action:@selector(secureSwitchAction:) forControlEvents:UIControlEventValueChanged];
    self.secretSwitch.on = YES;
    [self.passwordTextField setSecureTextEntry:YES];
    
    [self addSubview:self.passwordTextField];
    [self addSubview:self.passwordImageView];
    [self addSubview:self.codeTextField];
    [self addSubview:self.chatImageView];
    [self addSubview:self.secretSwitch];
    [self addSubview:self.conformButton];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.profileimageView];
    [self addSubview:self.phoneNumberTextField];
    
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
    maskLayer.lineWidth = 0;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1].CGColor;
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
    [self.chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.left.equalTo(self).offset(20);
        make.width.equalTo (@30);
        make.height.equalTo(@30);
    }];
    [self.passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatImageView.mas_bottom).offset(50);
        make.left.equalTo(self).offset(20);
        make.width.equalTo (@30);
        make.height.equalTo(@30);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(210);
        make.left.equalTo(self.profileimageView.mas_right).offset(20);
        make.width.equalTo (@200);
        make.height.equalTo(@40);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.left.equalTo(self.chatImageView.mas_right).offset(20);
        make.width.equalTo (@150);
        make.height.equalTo(@40);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatImageView.mas_bottom).offset(50);
        make.left.equalTo(self.passwordImageView.mas_right).offset(20);
        make.right.equalTo (self.mas_right);
        make.height.equalTo(@40);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileimageView.mas_bottom).offset(60);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo (@120);
        make.height.equalTo(@40);
    }];
    [self.secretSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatImageView.mas_bottom).offset(50);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo (@70);
        make.height.equalTo(@40);
    }];
    [self.conformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView.mas_bottom).offset(100);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo (@300);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Getters and Setters

@end
