//
//  NoticeTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "NoticeTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface NoticeTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *noticeLabel;
@property (nonatomic, strong, readwrite) UIImageView *noticeImageView;

@end

@implementation NoticeTableViewCell

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
    self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noticeLabel.textAlignment = NSTextAlignmentLeft;
    self.noticeLabel.text = @"我的消息";
    self.noticeLabel.font = [UIFont systemFontOfSize:18];
    self.noticeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.noticeImageView.image = [UIImage imageNamed:@"userCenter_UserCenterViewController_notice"];
    
    [self.contentView addSubview:self.noticeLabel];
    [self.contentView addSubview:self.noticeImageView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(80);
    }];
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
}

#pragma mark - Getters and Setters

@end
