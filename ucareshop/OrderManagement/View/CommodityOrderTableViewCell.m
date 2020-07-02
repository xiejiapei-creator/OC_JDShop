//
//  CommodityOrderTableViewCell.m
//  ucareshop
//
//  Created by liushuting on 2019/8/21.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommodityOrderTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommodityOrderTableViewCell ()

#pragma mark - 私有属性
    
@property (nonatomic, strong, readwrite) UIImageView *commodityImage;
@property (nonatomic, strong, readwrite) UILabel *commodityName;
@property (nonatomic, strong, readwrite) UILabel *priceTitle;
@property (nonatomic, strong, readwrite) UILabel *price;
@property (nonatomic, strong, readwrite) UILabel *primePrice;
@property (nonatomic, strong, readwrite) UIView *line;

@property (nonatomic, strong, readwrite) UILabel *commodityNumber;
@property (nonatomic, strong, readwrite) UILabel *multiple;
@property (nonatomic, strong, readwrite) UIView *cellContentView;
@property (nonatomic, strong, readwrite) UIButton *commentButton;
@property (nonatomic, strong, readwrite) UIButton *accomplishComment;
    
@end

@implementation CommodityOrderTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)updateCellConstrain {
    [self updateCommodityname];
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    
    self.cellContentView = [[UIView alloc]initWithFrame:CGRectZero];
    self.cellContentView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.cellContentView.layer.borderWidth = 1.0;
    [self.contentView addSubview:self.cellContentView];
    
    //commodity图片
    self.commodityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.commodityImage.contentMode = UIViewContentModeScaleToFill;
    self.commodityImage.image = [UIImage imageNamed:@"shoppingCart_shoppingCartViewController_commodityImage_enable"];
    self.commodityImage.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.commodityImage.layer.borderWidth = 2.0;
    [self.cellContentView addSubview:self.commodityImage];
    //commodity名字
    self.commodityName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityName.textColor = UIColor.blackColor;
    self.commodityName.textAlignment = NSTextAlignmentCenter;
    self.commodityName.adjustsFontSizeToFitWidth = YES;
    [self.cellContentView addSubview:self.commodityName];
    //commodityPrice-title
    self.priceTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.priceTitle.textColor = UIColor.blackColor;
    self.priceTitle.textAlignment = NSTextAlignmentLeft;
    self.priceTitle.text = @"规格/型号";
    self.priceTitle.font = [UIFont systemFontOfSize:16];
    [self.cellContentView addSubview:self.priceTitle];
    //commodityPrice
    self.price = [[UILabel alloc]initWithFrame:CGRectZero];
    self.price.textColor = UIColor.redColor;
    self.price.font = [UIFont systemFontOfSize:16];
    self.price.textAlignment = NSTextAlignmentCenter;
    self.price.adjustsFontSizeToFitWidth = YES;
    [self.cellContentView addSubview:self.price];
    //comodityPrimePrice
    self.primePrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.primePrice.textColor = UIColor.lightGrayColor;
    self.primePrice.textAlignment = NSTextAlignmentCenter;
    self.primePrice.adjustsFontSizeToFitWidth = YES;
    self.primePrice.font = [UIFont systemFontOfSize:14];
    [self.cellContentView addSubview:self.primePrice];
    //commodityNumber
    self.commodityNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityNumber.textColor = UIColor.redColor;
    self.commodityNumber.textAlignment = NSTextAlignmentCenter;
    self.commodityNumber.adjustsFontSizeToFitWidth = YES;
    [self.cellContentView addSubview:self.commodityNumber];
    //mutipleImage
    self.multiple = [[UILabel alloc]initWithFrame:CGRectZero];
    self.multiple.textColor = UIColor.redColor;
    self.multiple.textAlignment = NSTextAlignmentCenter;
    self.multiple.text = @"x";
    [self.cellContentView addSubview:self.multiple];
    self.line = [[UIView alloc]initWithFrame:CGRectZero];
    self.line.backgroundColor = UIColor.lightGrayColor;
    [self.cellContentView addSubview:self.line];
    
    self.commentButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.commentButton.layer.borderColor = [UIColor colorWithHexString:@"#ffae4b"].CGColor;
    self.commentButton.layer.borderWidth = 1.0;
    self.commentButton.layer.cornerRadius = 5.0;
    [self.commentButton setTitle:@"去评论～" forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.commentButton.hidden = YES;
    [self.cellContentView addSubview:self.commentButton];
    
    self.accomplishComment = [[UIButton alloc]initWithFrame:CGRectZero];
    self.accomplishComment.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
    self.accomplishComment.layer.borderWidth = 1.0;
    self.accomplishComment.layer.cornerRadius = 5.0;
    self.accomplishComment.hidden = YES;
    [self.accomplishComment setTitle:@"已评论" forState:UIControlStateNormal];
    [self.accomplishComment setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
    self.accomplishComment.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cellContentView addSubview:self.accomplishComment];
}

// 添加约束
- (void)createSubViewsConstraints {
    
    [self.cellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.contentView.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.contentView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.contentView.mas_safeAreaLayoutGuideRight);
    }];
    [self.commodityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(15);
        make.left.equalTo(self.contentView.mas_left).mas_offset(10);
        make.height.equalTo(@90);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-8);
    }];
    [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(15);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@20);
        make.height.equalTo(@10);
    }];
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitle.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@20);
        make.height.equalTo(@10);
    }];
    [self.primePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitle.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
    [self.commodityNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(10);
        make.right.equalTo(self.cellContentView.mas_right).mas_offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [self.multiple mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(10);
        make.right.equalTo(self.commodityNumber.mas_left);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.primePrice.mas_top).mas_offset(10);
        make.left.right.equalTo(self.primePrice);
        make.height.equalTo(@1);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-5);
        make.right.equalTo(self.cellContentView.mas_right).mas_offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.accomplishComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-5);
        make.right.equalTo(self.cellContentView.mas_right).mas_offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
}

- (void) updateCommodityname {
    CGFloat nameWidth = [self.commodityName sizeThatFits:CGSizeZero].width;
    [self.commodityName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(15);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(nameWidth));
        make.height.equalTo(@20);
    }];
    
    CGFloat commodityPrice = [self.price sizeThatFits:CGSizeZero].width;
    [self.price mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitle.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(commodityPrice));
        make.height.equalTo(@20);
    }];
    CGFloat primePrice = [self.primePrice sizeThatFits:CGSizeZero].width;
    [self.primePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.price.mas_bottom);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(primePrice));
        make.height.equalTo(@20);
    }];
}

#pragma mark - Getters and Setters

@end
