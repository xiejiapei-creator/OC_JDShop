//
//  AddAddress.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddAddressView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddAddressView ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *defaultAddressLabel;
@property (nonatomic, readwrite) UIButton *saveAddressButton;

@end

@implementation AddAddressView


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
    
    self.defaultAddressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.defaultAddressLabel.text = @"设为默认地址";
    self.defaultAddressLabel.font = [UIFont systemFontOfSize:18];
    self.defaultAddressLabel.textAlignment = NSTextAlignmentLeft;
    self.defaultAddressLabel.textColor = [UIColor grayColor];
    
    self.saveAddressButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveAddressButton setTitle:@"保存" forState:UIControlStateNormal];
    self.saveAddressButton.layer.cornerRadius = 8;
    self.saveAddressButton.layer.masksToBounds = YES;
    self.saveAddressButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.saveAddressButton setTintColor:[UIColor whiteColor]];
    [self.saveAddressButton setBackgroundColor:[UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1]];
    
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(7, 15)];
    [checkPath addLineToPoint:CGPointMake(15, 20)];
    [checkPath addLineToPoint:CGPointMake(25, 6)];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = checkPath.CGPath;
    self.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.maskLayer.lineWidth = 3.0;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.frame = CGRectMake(10, 10, 30, 30);
    self.maskLayer.cornerRadius = 15;
    self.maskLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.checkButton.frame = CGRectMake(0, 0, 40, 40);
    [self.checkButton.layer addSublayer:self.maskLayer];

    [self addSubview:self.defaultAddressLabel];
    [self addSubview:self.saveAddressButton];
    [self addSubview:self.checkButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.defaultAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.left.equalTo(self.mas_left).offset(60);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    [self.saveAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultAddressLabel).offset(50);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@60);
    }];
}
#pragma mark - Getters and Setters

@end
