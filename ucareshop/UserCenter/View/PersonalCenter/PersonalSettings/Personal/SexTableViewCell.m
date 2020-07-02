//
//  SexTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SexTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface SexTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *sexLabel;
@property (nonatomic, readwrite) UISegmentedControl *sexSegmentedControl;

@end

@implementation SexTableViewCell

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
    self.sexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.sexLabel.text = @"性别";
    self.sexLabel.font = [UIFont systemFontOfSize:18];
    self.sexSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"男",@"女"]];
    
//    [self.sexSegmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:22.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.sexSegmentedControl.selectedSegmentIndex = 0;
    [self.contentView addSubview:self.sexLabel];
    [self.contentView addSubview:self.sexSegmentedControl];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.sexSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.sexLabel.mas_right).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
}

#pragma mark - Getters and Setters

@end
