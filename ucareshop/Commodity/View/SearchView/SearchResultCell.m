//
//  SearchResultCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/30.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SearchResultCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface SearchResultCell ()

#pragma mark - 私有属性

@end

@implementation SearchResultCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.nameLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    self.priceLabel.textColor = [UIColor redColor];
    [self addSubview:self.priceLabel];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@90);
        make.width.equalTo(@90);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@90);
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@90);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - Getters and Setters

@end
