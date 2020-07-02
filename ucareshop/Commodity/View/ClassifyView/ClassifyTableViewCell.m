//
//  ClassifyTableViewCell.m
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ClassifyTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ClassifyTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIView *rightBorder;
@property (nonatomic, strong, readwrite) UILabel *classifyName;
@property (nonatomic, strong, readwrite) UIView *bottomBorder;
@property (nonatomic, strong, readwrite) UIView *topBorder;
@property (nonatomic, strong, readwrite) UIView *leftBorder;

@end

@implementation ClassifyTableViewCell

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

- (void) hideBorder {
    self.rightBorder.alpha = 0.0;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.classifyName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.classifyName.textColor = [UIColor colorWithHexString:@"#d2d2d2"];
    self.classifyName.textAlignment = NSTextAlignmentCenter;
    self.classifyName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.classifyName];
    
    self.rightBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.rightBorder.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    [self.contentView addSubview:self.rightBorder];
    
    self.bottomBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomBorder.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    [self.contentView addSubview:self.bottomBorder];
    
    self.topBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.topBorder.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    self.topBorder.alpha = 0.0;
    [self.contentView addSubview:self.topBorder];
    
    self.leftBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftBorder.backgroundColor = UIColor.cyanColor;
    self.leftBorder.hidden = YES;
    [self.contentView addSubview:self.leftBorder];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.classifyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@30);
    }];
    [self.rightBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.width.equalTo(@1);
    }];
    [self.bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@5);
    }];
}

#pragma mark - Getters and Setters

@end
