//
//  WalletTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "WalletTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface WalletTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *walletLabel;
@property (nonatomic, strong, readwrite) UIImageView *walletImageView;

@end

@implementation WalletTableViewCell

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
    self.walletLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.walletLabel.textAlignment = NSTextAlignmentLeft;
    self.walletLabel.text = @"我的钱包";
    self.walletLabel.font = [UIFont systemFontOfSize:18];
    self.walletImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.walletImageView.image = [UIImage imageNamed:@"userCenter_UserCenterViewController_wallet"];
    
    [self.contentView addSubview:self.walletLabel];
    [self.contentView addSubview:self.walletImageView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(80);
    }];
    [self.walletImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
}

#pragma mark - Getters and Setters

@end
