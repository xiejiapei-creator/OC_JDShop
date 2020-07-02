//
//  ScrollTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/10/9.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "ScrollTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ScrollTableViewCell ()

#pragma mark - 私有属性

@end

@implementation ScrollTableViewCell

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
    //轮播图
    self.autoScrollView = [[AutoScrollView alloc]initWithFrame:CGRectZero];
    self.autoScrollView.pageView.currentPageIndicatorTintColor = UIColor.cyanColor;
    [self addSubview:self.autoScrollView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.autoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@200);
    }];
}

#pragma mark - Getters and Setters

@end
