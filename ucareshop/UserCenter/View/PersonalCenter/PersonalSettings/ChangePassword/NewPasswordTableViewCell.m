//
//  NewPasswordTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "NewPasswordTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface NewPasswordTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *passwordLabel;
@property (nonatomic, readwrite) UITextField *inputNewPasswordTextField;

@end

@implementation NewPasswordTableViewCell

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
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.passwordLabel.text = @"新密码";
    self.passwordLabel.font = [UIFont systemFontOfSize:18];
    
    self.inputNewPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inputNewPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputNewPasswordTextField.placeholder = @"请输入新密码(6-20位数字或字母组合)";
    self.inputNewPasswordTextField.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.passwordLabel];
    [self.contentView addSubview:self.inputNewPasswordTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.inputNewPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.passwordLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
