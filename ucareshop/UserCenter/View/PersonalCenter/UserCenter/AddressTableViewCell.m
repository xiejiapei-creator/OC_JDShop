//
//  AddressTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddressTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddressTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *addressLabel;
@property (nonatomic, strong, readwrite) UIImageView *addressImageView;

@end

@implementation AddressTableViewCell

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
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.text = @"地址管理";
    self.addressLabel.font = [UIFont systemFontOfSize:18];
    self.addressImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.addressImageView.image = [UIImage imageNamed:@"userCenter_UserCenterViewController_address"];
    
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.addressImageView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(80);
    }];
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
}

#pragma mark - Getters and Setters

@end
