//
//  OldPasswordTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "OldPasswordTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface OldPasswordTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *oldPasswordLabel;
@property (nonatomic, readwrite) UITextField *inputPasswordTextField;

@end

@implementation OldPasswordTableViewCell

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
    self.oldPasswordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.oldPasswordLabel.text = @"旧密码";
    self.oldPasswordLabel.font = [UIFont systemFontOfSize:18];
    
    self.inputPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inputPasswordTextField.placeholder = @"点击输入密码";
    self.inputPasswordTextField.font = [UIFont systemFontOfSize:18];
    self.inputPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.oldPasswordLabel];
    [self.contentView addSubview:self.inputPasswordTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.oldPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.inputPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.oldPasswordLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
