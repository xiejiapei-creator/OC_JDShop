//
//  EventCollectionViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/22.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "EventCollectionViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface EventCollectionViewCell ()

#pragma mark - 私有属性

@end

@implementation EventCollectionViewCell


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
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.imageView.layer.cornerRadius = 8.0f;
    self.imageView.layer.masksToBounds = YES;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLabel];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.priceLabel.textColor = [UIColor redColor];
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.priceLabel];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.right.left.equalTo(self);        make.top.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.right.left.equalTo(self);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.mas_centerX);
        make.right.left.equalTo(self);
        make.bottom.equalTo(self.nameLabel.mas_top).offset(-10);
    }];
}

#pragma mark - Getters and Setters

@end
