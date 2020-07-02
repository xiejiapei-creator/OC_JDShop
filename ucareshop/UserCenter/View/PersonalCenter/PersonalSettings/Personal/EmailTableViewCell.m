//
//  EmailTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "EmailTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface EmailTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *emailLabel;
@property (nonatomic, readwrite) UITextField *emailTextField;

@end

@implementation EmailTableViewCell

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
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.emailLabel.text = @"邮箱";
    self.emailLabel.font = [UIFont systemFontOfSize:18];
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.emailTextField.placeholder = @"请输入邮箱";
    self.emailTextField.font = [UIFont systemFontOfSize:18];
    self.emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.emailLabel];
    [self.contentView addSubview:self.emailTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.emailLabel.mas_right).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
