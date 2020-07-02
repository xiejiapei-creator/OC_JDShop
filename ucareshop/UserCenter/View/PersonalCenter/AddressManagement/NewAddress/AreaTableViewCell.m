//
//  AreaTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AreaTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AreaTableViewCell () 

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *areaLabel;
@property (nonatomic, readwrite) UITextField *areaTextField;

@end

@implementation AreaTableViewCell

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
    self.areaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.areaLabel.text = @"所在区域";
    self.areaLabel.font = [UIFont systemFontOfSize:18];
    
    self.areaTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.areaTextField.placeholder = @"选择所在区域，街道，区县";
    self.areaTextField.font = [UIFont systemFontOfSize:18];
    self.areaTextField.enabled = NO;
    self.areaTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.areaTextField];
    [self.contentView addSubview:self.areaLabel];
    

    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo (@80);
        make.height.equalTo(@40);
    }];
    [self.areaTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.areaLabel.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@40);
    }];

}

#pragma mark - Getters and Setters

@end
