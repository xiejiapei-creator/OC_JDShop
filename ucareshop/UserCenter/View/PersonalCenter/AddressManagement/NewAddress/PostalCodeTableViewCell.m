//
//  PostalCodeTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PostalCodeTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface PostalCodeTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *postalCodeLabel;
@property (nonatomic, readwrite) UITextField *postalCodeTextField;

@end

@implementation PostalCodeTableViewCell

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
    self.postalCodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.postalCodeLabel.text = @"邮政编码";
    self.postalCodeLabel.font = [UIFont systemFontOfSize:18];
    
    self.postalCodeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.postalCodeTextField.placeholder = @"请输入邮政编码";
    self.postalCodeTextField.font = [UIFont systemFontOfSize:18];
    self.postalCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.postalCodeLabel];
    [self.contentView addSubview:self.postalCodeTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.postalCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.postalCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.postalCodeLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
