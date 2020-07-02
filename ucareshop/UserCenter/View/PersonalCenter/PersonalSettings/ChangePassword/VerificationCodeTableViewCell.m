//
//  VerificationCodeTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "VerificationCodeTableViewCell.h"
#import <Masonry/Masonry.h>
#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface VerificationCodeTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *verificationCodePasswordLabel;
@property (nonatomic, readwrite) UITextField *inputVerificationCodeTextField;
@property (nonatomic, readwrite) UIButton *sendVerificationCodeButton;


@end

@implementation VerificationCodeTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.verificationCodePasswordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.verificationCodePasswordLabel.text = @"短信验证码";
    self.verificationCodePasswordLabel.font = [UIFont systemFontOfSize:18];
    
    self.inputVerificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inputVerificationCodeTextField.placeholder = @"短信验证码";
    self.inputVerificationCodeTextField.font = [UIFont systemFontOfSize:18];
    self.inputVerificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.sendVerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendVerificationCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendVerificationCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self.contentView addSubview:self.verificationCodePasswordLabel];
    [self.contentView addSubview:self.inputVerificationCodeTextField];
    [self.contentView addSubview:self.sendVerificationCodeButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.verificationCodePasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@120);
        make.height.equalTo(@40);
    }];
    [self.inputVerificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(120);
        make.right.equalTo(self.sendVerificationCodeButton.mas_left);
        make.height.equalTo(@40);
    }];
    [self.sendVerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
        make.width.equalTo(@140);
    }];
}

#pragma mark - Getters and Setters

@end
