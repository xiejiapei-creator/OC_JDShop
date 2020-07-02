//
//  RechargeTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "RechargeTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface RechargeTableViewCell ()

#pragma mark - 私有属性


@property (nonatomic, strong, readwrite) UILabel *rechargeLabel;
@property (nonatomic, strong, readwrite) UILabel *moneySymbolLabel;

@end

@implementation RechargeTableViewCell

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
    self.rechargeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rechargeLabel.textAlignment = NSTextAlignmentLeft;
    self.rechargeLabel.text = @"充值金额";
    self.rechargeLabel.font = [UIFont systemFontOfSize:22];
    self.moneySymbolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.moneySymbolLabel.text = @"¥";
    self.moneySymbolLabel.font = [UIFont systemFontOfSize:22];
    self.moneyNumberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.moneyNumberTextField.placeholder = @"输入金额";
    self.moneyNumberTextField.font = [UIFont systemFontOfSize:22];
    self.moneyNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.contentView addSubview:self.rechargeLabel];
    [self.contentView addSubview:self.moneySymbolLabel];
    [self.contentView addSubview:self.moneyNumberTextField];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@140);
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    [self.moneySymbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
        make.width.equalTo(@60);
        make.top.equalTo(self.rechargeLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    [self.moneyNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
        make.top.equalTo(self.rechargeLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.moneySymbolLabel.mas_right).offset(5);
    }];
}

#pragma mark - Getters and Setters

@end
