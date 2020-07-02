//
//  PhoneNumberTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PhoneNumberTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface PhoneNumberTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *phoneNumberLabel;
@property (nonatomic, readwrite) UITextField *phoneNumberTextField;

@end

@implementation PhoneNumberTableViewCell

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
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneNumberLabel.text = @"手机号码";
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:18];
    
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneNumberTextField.placeholder = @"请输入手机号码";
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:18];
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.phoneNumberTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.phoneNumberLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
