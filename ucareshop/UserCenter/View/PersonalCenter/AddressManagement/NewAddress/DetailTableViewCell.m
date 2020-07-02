//
//  DetailTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "DetailTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface DetailTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *detailLabel;
@property (nonatomic, readwrite) UITextField *detailTextField;

@end

@implementation DetailTableViewCell

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
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.text = @"详细地址";
    self.detailLabel.font = [UIFont systemFontOfSize:18];
    
    self.detailTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.detailTextField.placeholder = @"请输入街道、门牌等详细地址";
    self.detailTextField.font = [UIFont systemFontOfSize:18];
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.detailTextField];
    [self.contentView addSubview:self.detailLabel];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.detailLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
