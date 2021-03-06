//
//  AddAddressTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "NewNameTableViewCell.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface NewNameTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *nameLabel;
@property (nonatomic, readwrite) UITextField *nameTextField;

@end

@implementation NewNameTableViewCell

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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.text = @"姓名";
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextField.placeholder = @"请输入姓名";
    self.nameTextField.font = [UIFont systemFontOfSize:18];
    [self.nameTextField addSubview:self.nameLabel];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.nameTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
