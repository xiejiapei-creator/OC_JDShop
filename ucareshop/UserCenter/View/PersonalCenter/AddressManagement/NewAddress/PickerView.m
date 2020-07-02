//
//  PickerView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PickerView.h"
#import "URLRequest.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface PickerView ()

#pragma mark - 私有属性

@end

@implementation PickerView


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
    self.systemPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.systemPickerView];
    
    self.pickButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.pickButton setTitle:@"选中" forState:UIControlStateNormal];
    self.pickButton.layer.cornerRadius = 8;
    self.pickButton.layer.masksToBounds = YES;
    self.pickButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.pickButton setTintColor:[UIColor whiteColor]];
    [self.pickButton setBackgroundColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1]];
    [self addSubview:self.pickButton];

    [self.systemPickerView reloadAllComponents];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.systemPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.left.equalTo(self);
        make.height.equalTo(@400);
    }];
    [self.pickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@60);
        make.width.equalTo(@200);
        make.top.equalTo(self.systemPickerView.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

#pragma mark - Getters and Setters

@end
