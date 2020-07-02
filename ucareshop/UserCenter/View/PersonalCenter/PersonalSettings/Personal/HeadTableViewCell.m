//
//  ProfileTableViewCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "HeadTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface HeadTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, readwrite) UIImageView *profileimageView;
@property (nonatomic, readwrite) UIButton *changeImageButton;

@end

@implementation HeadTableViewCell

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
    self.profileimageView = [[UIImageView alloc] init];
    self.profileimageView.layer.masksToBounds = YES;
    self.profileimageView.layer.cornerRadius = 40;
    
    self.changeImageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.changeImageButton setTitle:@"点击修改头像" forState:UIControlStateNormal];
    self.changeImageButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.changeImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.changeImageButton];
    [self.contentView addSubview:self.profileimageView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.profileimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_safeAreaLayoutGuideTop).offset(15);
        make.height.width.equalTo(@80);
    }];
    [self.changeImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.profileimageView.mas_bottom);
        make.height.equalTo(@40);
        make.width.equalTo(@300);
    }];
}

#pragma mark - Getters and Setters

@end
