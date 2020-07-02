//
//  ConfirmTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ConfirmTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ConfirmTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *confirmPasswordLabel;
@property (nonatomic, readwrite) UITextField *confirmPasswordTextField;

@end

@implementation ConfirmTableViewCell

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
    self.confirmPasswordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.confirmPasswordLabel.text = @"确认密码";
    self.confirmPasswordLabel.font = [UIFont systemFontOfSize:18];
    
    self.confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.confirmPasswordTextField.placeholder = @"请再次输入新密码";
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:18];
    self.confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.confirmPasswordLabel];
    [self.contentView addSubview:self.confirmPasswordTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.confirmPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.confirmPasswordLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
