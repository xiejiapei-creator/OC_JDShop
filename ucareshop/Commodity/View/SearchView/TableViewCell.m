//
//  AccountNumberTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/28.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "TableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface TableViewCell ()

#pragma mark - 私有属性


@end

@implementation TableViewCell


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
    UIImage *image = [UIImage imageNamed:@"commodity_searchCommodityViewController_search"];
    self.wrongImage = [[UIImageView alloc] initWithImage:image];
    [self.contentView addSubview:self.wrongImage];
    [self.wrongImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor colorWithRed:45/255.0 green:79/255.0 blue:125/255.0 alpha:1];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wrongImage.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@60);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

// 添加约束
- (void)createSubViewsConstraints {

}

#pragma mark - Getters and Setters

@end
