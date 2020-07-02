//
//  RegisterView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/28.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RegisterView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RegisterView ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UIImageView *phoneImageView;
@property (nonatomic, readwrite) UIImageView *chatImageView;
@property (nonatomic, readwrite) UIImageView *passwordImageView;
@property (nonatomic, readwrite) UITextField *phoneNumberTextField;
@property (nonatomic, readwrite) UITextField *passwordTextField;
@property (nonatomic, readwrite) UITextField *codeTextField;
@property (nonatomic, readwrite) UISwitch *secretSwitch;
@property (nonatomic, readwrite) UIButton *sendCodeButton;
@property (nonatomic, readwrite) UIButton *conformButton;
@property (nonatomic, readwrite) UIButton *agreementButton;
@property (nonatomic, readwrite) UILabel *agreementLabel;
@property (nonatomic, readwrite) UILabel *symbolLabel;
@property (nonatomic, strong, readwrite) CAShapeLayer *maskLayer;

@property (nonatomic, strong, readwrite) UIButton *checkButton;

@end

@implementation RegisterView

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
        self.isCheck = YES;
        self.maskLayer.strokeColor = [UIColor greenColor].CGColor;
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
- (void)changeColor:(id)sender {
    if (self.isCheck) {
        self.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.isCheck = NO;
    } else {
        self.maskLayer.strokeColor = [UIColor greenColor].CGColor;
        self.isCheck = YES;
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - 开始计时

- (void)startTime {
    [timer invalidate];
    waitTime = 60;
    [self updateVareyButton];
    __weak RegisterView *weakSelf = self;
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

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.phoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_registerViewController_phone"]];
    self.chatImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_registerViewController_message"]];
    self.passwordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userCenter_LoginViewController_lock"]];
    
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneNumberTextField.placeholder = @"输入手机号码";
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:18];
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.codeTextField.placeholder = @"短信验证码";
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.font = [UIFont systemFontOfSize:18];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextField.placeholder = @"设置登录密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:18];
    
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    self.conformButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.conformButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.conformButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1];
    self.conformButton.layer.cornerRadius = 8;
    self.conformButton.layer.masksToBounds = YES;
    [self.conformButton setTitle:@"确认" forState:UIControlStateNormal];
    self.conformButton.titleLabel.font = [UIFont systemFontOfSize:24];
    
    self.secretSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.secretSwitch addTarget:self action:@selector(secureSwitchAction:) forControlEvents:UIControlEventValueChanged];
    self.secretSwitch.on = YES;
    [self.passwordTextField setSecureTextEntry:YES];
    
    self.agreementLabel = [[UILabel alloc] init];
    self.agreementLabel.text = @"已阅读并同意《";
    self.agreementLabel.font = [UIFont systemFontOfSize:18];
    self.symbolLabel = [[UILabel alloc] init];
    self.symbolLabel.text = @"》";
    self.symbolLabel.font = [UIFont systemFontOfSize:18];
    self.agreementButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.agreementButton setTitle:@"用户服务协议" forState:UIControlStateNormal];
    [self.agreementButton setTitleColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1] forState:UIControlStateNormal];
    self.agreementButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self addSubview:self.phoneImageView];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.passwordImageView];
    [self addSubview:self.phoneNumberTextField];
    [self addSubview:self.codeTextField];
    [self addSubview:self.chatImageView];
    [self addSubview:self.secretSwitch];
    [self addSubview:self.agreementLabel];
    [self addSubview:self.conformButton];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.checkButton];
    [self addSubview:self.symbolLabel];
    [self addSubview:self.agreementButton];
    
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
    maskLayer.lineWidth = 0.0;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1].CGColor;
    maskLayer.frame = CGRectMake(90, 60, 100, 100);
    [self.layer addSublayer:maskLayer];
    
    //选中
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(7, 19)];
    [checkPath addLineToPoint:CGPointMake(15, 25)];
    [checkPath addLineToPoint:CGPointMake(25, 9)];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = checkPath.CGPath;
    self.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.maskLayer.lineWidth = 3.0;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.frame = CGRectMake(10, 25, 30, 30);
    self.maskLayer.cornerRadius = 15;
    self.maskLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.checkButton.frame = CGRectMake(15, 435, 80, 85);
    [self.checkButton.layer addSublayer:self.maskLayer];
    [self.checkButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
}
// 添加约束
- (void)createSubViewsConstraints {
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(210);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.equalTo (@30);
        make.height.equalTo(@30);
    }];
    [self.chatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView.mas_bottom).offset(60);
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
        make.left.equalTo(self.phoneImageView.mas_right).offset(20);
        make.width.equalTo (@200);
        make.height.equalTo(@40);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneImageView.mas_bottom).offset(60);
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
        make.top.equalTo(self.phoneImageView.mas_bottom).offset(60);
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
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView.mas_bottom).offset(60);
        make.left.equalTo(self.mas_left).offset(70);
        make.width.equalTo (@130);
        make.height.equalTo(@20);
    }];
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView.mas_bottom).offset(60);
        make.left.equalTo(self.agreementLabel.mas_right);
        make.width.equalTo (@130);
        make.height.equalTo(@20);
    }];
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordImageView.mas_bottom).offset(60);
        make.left.equalTo(self.agreementButton.mas_right);
        make.width.equalTo (@20);
        make.height.equalTo(@20);
    }];
    [self.conformButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreementLabel.mas_bottom).offset(100);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo (@300);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Getters and Setters

@end
