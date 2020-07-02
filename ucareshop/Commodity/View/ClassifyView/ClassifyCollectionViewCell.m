//
//  ClassifyCollectionViewCell.m
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ClassifyCollectionViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ClassifyCollectionViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIImageView *commodityImage;
@property (nonatomic, strong, readwrite) UILabel *commodityName;
@property (nonatomic, strong, readwrite) UILabel *commodityPrice;
@property (nonatomic, strong, readwrite) UILabel *primePrice;

@end

@implementation ClassifyCollectionViewCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
        [self updateCommodityname];
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
    
    self.commodityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.commodityImage.contentMode = UIViewContentModeScaleToFill;
    self.commodityImage.contentMode = UIViewContentModeScaleAspectFit;
    self.commodityImage.backgroundColor = UIColor.whiteColor;
    self.commodityImage.layer.cornerRadius = 10;
    self.commodityImage.layer.borderWidth = 1.0;
    self.commodityImage.layer.borderColor = UIColor.whiteColor.CGColor;
    self.commodityImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.commodityImage];
    
    self.commodityName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityName.textAlignment = NSTextAlignmentCenter;
    self.commodityName.font = [UIFont systemFontOfSize:16];
    self.commodityName.text = @"gfewgfl";
    [self.contentView addSubview:self.commodityName];
    
    self.commodityPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityPrice.textAlignment = NSTextAlignmentCenter;
    self.commodityPrice.textColor = [UIColor colorWithHexString:@"#d2d2d2"];
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", 20];
    self.commodityName.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.commodityPrice];
    //comodityPrimePrice
    self.primePrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.primePrice.textColor = UIColor.lightGrayColor;
    self.primePrice.textAlignment = NSTextAlignmentCenter;
    self.primePrice.adjustsFontSizeToFitWidth = YES;
    self.primePrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d", @"¥", 100] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
    self.primePrice.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.primePrice];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.commodityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@80);
        make.width.equalTo(self.contentView);
    }];
    [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityImage.mas_bottom).mas_offset(5);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    [self.commodityPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom).mas_offset(5);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    [self.primePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityPrice.mas_bottom).mas_offset(5);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
}

- (void) updateCommodityname {
    CGFloat nameWidth = [self.commodityName sizeThatFits:CGSizeZero].width;
    [self.commodityName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityImage.mas_bottom).mas_offset(5);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.width.equalTo(@(nameWidth));
    }];
    
    CGFloat commodityPrice = [self.commodityPrice sizeThatFits:CGSizeZero].width;
    [self.commodityPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.width.equalTo(@(commodityPrice));
    }];
    CGFloat primePrice = [self.primePrice sizeThatFits:CGSizeZero].width;
    [self.primePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityPrice.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(primePrice));
        make.height.equalTo(@20);
    }];
}

#pragma mark - Getters and Setters

@end
