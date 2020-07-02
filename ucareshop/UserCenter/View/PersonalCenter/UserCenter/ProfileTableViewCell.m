//
//  profileView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ProfileTableViewCell.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface ProfileTableViewCell ()

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *phoneNumberLabel;
@property (nonatomic, strong, readwrite) UILabel *scoreLabel;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *gradeLabel;
@property (nonatomic, strong, readwrite) UIImageView *profileImageView;
@property (nonatomic, strong, readwrite) UIButton *settingButton;
@property (nonatomic, strong, readwrite) UIButton *loginButton;
@property (nonatomic, strong, readwrite) UIButton *registerButton;

@end

@implementation ProfileTableViewCell


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
    //登录状态
    //上半部分
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneNumberLabel.textAlignment = NSTextAlignmentLeft;
    self.phoneNumberLabel.font = [UIFont systemFontOfSize:16];
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scoreLabel.textAlignment = NSTextAlignmentLeft;
    self.scoreLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [self.nameLabel sizeToFit];
    
    self.gradeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.gradeLabel sizeToFit];
    self.gradeLabel.layer.cornerRadius = 6;
    self.gradeLabel.layer.masksToBounds = YES;
    self.gradeLabel.layer.borderWidth = 1.0;
    self.gradeLabel.textAlignment = NSTextAlignmentCenter;
    self.gradeLabel.font = [UIFont systemFontOfSize:14];
    self.gradeLabel.textColor = [UIColor redColor];
    self.gradeLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:241/255.0 blue:246/255.0 alpha:0.3];
    self.gradeLabel.layer.borderColor = [UIColor colorWithRed:235/255.0 green:130/255.0 blue:167/255.0 alpha:0.3].CGColor;
    
    //头像
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 40;
//    self.profileImageView.layer.borderColor = [UIColor purpleColor].CGColor;
//    self.profileImageView.layer.borderWidth = 10;
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.settingButton setImage:[UIImage imageNamed:@"userCenter_UserCenterViewController_setting"] forState:UIControlStateNormal];
    
    //未登录状态
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:25];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.masksToBounds = YES;
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    self.registerButton.layer.cornerRadius = 8;
    self.registerButton.layer.masksToBounds = YES;
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:185/255.0 blue:157/255.0 alpha:1];
    
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.gradeLabel];
    [self.contentView addSubview:self.profileImageView];
    [self.contentView addSubview:self.settingButton];
    [self.contentView addSubview:self.registerButton];
    [self.contentView addSubview:self.loginButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    //上半部分
    [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@80);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@150);
        make.top.equalTo(self.profileImageView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        make.left.equalTo(self.profileImageView.mas_right).offset(5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
//        make.width.equalTo(@150);
        make.left.equalTo(self.profileImageView.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(40);
    }];
    [self.gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@30);
//        make.width.equalTo(@30);
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(43);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@100);
        make.left.equalTo(self.profileImageView.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@100);
        make.left.equalTo(self.loginButton.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - Getters and Setters

@end
