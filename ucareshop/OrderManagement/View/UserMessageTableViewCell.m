//
//  UserMessageTableViewCell.m
//  ucareshop
//
//  Created by liushuting on 2019/8/21.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "UserMessageTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface UserMessageTableViewCell ()

#pragma mark - 私有属性
    
@property (nonatomic, strong, readwrite) UILabel *title;
@property (nonatomic, strong, readwrite) UILabel *content;
@property (nonatomic, strong, readwrite) UIView *bottomLine;
@property (nonatomic, strong, readwrite) UIView *allSelection;
@property (nonatomic, strong, readwrite) UIView *nonSelection;
@property (nonatomic, strong, readwrite) UIView *whiteDot;
@property (nonatomic, assign, readwrite) BOOL allSelected;

@end

@implementation UserMessageTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
        [self addGesture];
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

- (void) allSelect {
    self.allSelected = !self.allSelected;
    if (self.allSelected == YES) {
        self.allSelection.hidden = NO;
        self.nonSelection.hidden = YES;
    } else {
        self.allSelection.hidden = YES;
        self.nonSelection.hidden = NO;
    }
    self.status(self.allSelected);
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //userMessageTitle
    self.status = ^(BOOL status) {};
    self.title = [[UILabel alloc]initWithFrame:CGRectZero];
    self.title.textColor = UIColor.blackColor;
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.title];
    //userMessageContent
    self.content = [[UILabel alloc]initWithFrame:CGRectZero];
    self.content.textColor = UIColor.lightGrayColor;
    self.content.numberOfLines = 0;
    self.content.textAlignment = NSTextAlignmentLeft;
    self.content.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.content];
    //bottomLine
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:self.bottomLine];
    
    //单选按钮--选择后
    self.allSelection = [[UIView alloc]initWithFrame:CGRectZero];
    self.allSelection.backgroundColor = UIColor.blueColor;
    self.allSelection.userInteractionEnabled = YES;
    self.allSelection.hidden = YES;
    //遮罩路径
    UIBezierPath *radioButtonPath = [UIBezierPath bezierPath];
    [radioButtonPath addArcWithCenter:CGPointMake(10, 25) radius:8 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //加一个遮罩
    CAShapeLayer *radioButtonMask = [CAShapeLayer layer];
    radioButtonMask.frame = self.allSelection.bounds;
    radioButtonMask.path = radioButtonPath.CGPath;
    radioButtonMask.strokeColor = UIColor.blackColor.CGColor;
    radioButtonMask.lineWidth = 1.0;
    self.allSelection.layer.mask = radioButtonMask;
    [self.contentView addSubview:self.allSelection];
    //画小白点
    self.whiteDot = [[UIView alloc]initWithFrame:CGRectZero];
    self.whiteDot.backgroundColor = UIColor.whiteColor;
    self.whiteDot.layer.cornerRadius = 3;
    [self.allSelection addSubview:self.whiteDot];
    //单选按钮--选择前
    self.nonSelection = [[UIView alloc]initWithFrame:CGRectZero];
    self.nonSelection.backgroundColor = UIColor.clearColor;
    self.nonSelection.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.nonSelection.layer.borderWidth = 1.0;
    self.nonSelection.layer.cornerRadius = 10.0;
    self.nonSelection.hidden = YES;
    [self.contentView addSubview:self.nonSelection];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.contentView.mas_left).mas_offset(20);
        make.width.equalTo(self.contentView.mas_width).dividedBy(3);
        make.height.equalTo(@50);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.title.mas_right).mas_offset(10);
        make.width.equalTo(self.title.mas_width).multipliedBy(2);
        make.height.equalTo(@50);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.allSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.contentView.mas_left).mas_offset(20);
        make.height.equalTo(@50);
        make.width.equalTo(@20);
    }];
    [self.whiteDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.allSelection);
        make.height.equalTo(@6);
        make.width.equalTo(@6);
    }];
    [self.nonSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).mas_offset(20);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
}

- (void) addGesture {
    self.allSelected = NO;
    UITapGestureRecognizer *allSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelect)];
    [self.nonSelection addGestureRecognizer:allSelectGesture];
    UITapGestureRecognizer *nonSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelect)];
    [self.allSelection addGestureRecognizer:nonSelectGesture];
}

- (void) updateCellConstraints {
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.allSelection.mas_right).mas_offset(10);
        make.width.equalTo(self.contentView.mas_width).dividedBy(3);
        make.height.equalTo(@50);
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-8);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

- (void) updateTitleConstrain {
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.contentView.mas_left).mas_offset(20);
        make.width.equalTo(self.contentView.mas_width).dividedBy(3);
        make.height.equalTo(@50);
    }];
    [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(5);
        make.bottom.equalTo(self.bottomLine.mas_top).mas_offset(-4);
        make.left.equalTo(self.title.mas_right).mas_offset(10);
        make.width.equalTo(self.title.mas_width).multipliedBy(2);
        make.height.equalTo(@50);
    }];
}

#pragma mark - Getters and Setters

@end
