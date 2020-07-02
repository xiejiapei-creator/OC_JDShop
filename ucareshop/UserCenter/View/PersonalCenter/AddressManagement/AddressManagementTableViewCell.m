//
//  AddressManagementTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddressManagementTableViewCell.h"
#import "AddAddressView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddressManagementTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *phoneNumberLabel;
@property (nonatomic, strong, readwrite) UILabel *addressLabel;
@property (nonatomic, strong, readwrite) UILabel *defaultAddressLabel;
@property (nonatomic, strong, readwrite) UIButton *editButton;
@property (nonatomic, strong, readwrite) UIButton *trashButton;

@end

@implementation AddressManagementTableViewCell

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

//联动改变颜色
- (void)changeColor:(id)sender {
    //vc间反向传值 一个等号就可以
    //vc间多加了一层view，需要新加一个属性来传值
    self.transChangeColorBlock();
}
//垃圾桶删除操作
- (void)delete:(id)sender {
    self.transTrashBlock();
}
- (void)edit:(id)sender {
    self.TransEditBlock();
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods



// 添加子视图
- (void)createSubViews {
//    self.isCheck = NO;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [self.nameLabel sizeToFit];
    
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:18];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.textColor = [UIColor grayColor];
    
    self.defaultAddressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.defaultAddressLabel.textAlignment = NSTextAlignmentLeft;
    self.defaultAddressLabel.textColor = [UIColor grayColor];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editButton setImage:[UIImage imageNamed:@"userCenter_addAddressViewController_edit"] forState:UIControlStateNormal];
    self.trashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.trashButton setImage:[UIImage imageNamed:@"userCenter_addAddressViewController_trash"] forState:UIControlStateNormal];
    [self.trashButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];


    //线条
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, 75)];
    [linePath addLineToPoint:CGPointMake(500, 75)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = linePath.CGPath;
    maskLayer.strokeColor = [UIColor grayColor].CGColor;
    maskLayer.lineWidth = 1.0;
    [self.layer addSublayer:maskLayer];
    
    //选中
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(7, 19)];
    [checkPath addLineToPoint:CGPointMake(15, 25)];
    [checkPath addLineToPoint:CGPointMake(25, 9)];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = checkPath.CGPath;

    self.maskLayer.lineWidth = 3.0;
    self.maskLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskLayer.frame = CGRectMake(10, 25, 30, 30);
    self.maskLayer.cornerRadius = 15;
    self.maskLayer.backgroundColor = [UIColor grayColor].CGColor;
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.checkButton.frame = CGRectMake(0, 70, 80, 60);
    [self.checkButton.layer addSublayer:self.maskLayer];
    [self.checkButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.editButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.defaultAddressLabel];
    [self.contentView addSubview:self.editButton];
    [self.contentView addSubview:self.trashButton];
    [self.contentView addSubview:self.checkButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
//        make.width.equalTo(@80);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@150);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(self.contentView);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(5);
    }];
    [self.defaultAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@70);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(30);
        make.left.equalTo(self.contentView.mas_left).offset(50);
    }];
    [self.trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(30);
        make.right.equalTo(self.trashButton.mas_left).offset(-20);
    }];
}

#pragma mark - Getters and Setters

@end
