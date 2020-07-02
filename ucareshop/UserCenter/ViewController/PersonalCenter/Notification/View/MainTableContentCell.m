//
//  MainTableContentCell.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "MainTableContentCell.h"
#import "MainTableViewCell.h"
#import <Masonry/Masonry.h>
#import "PrefixHeader.pch"

@interface MainTableContentCell ()

@property(nonatomic, strong) MainTableViewCell *MainCell;

@end

@implementation MainTableContentCell

#pragma mark - Super Class
- (void)setupSubViews {
    
    
    UIView *contentView = [UIView viewWithColor:[UIColor whiteColor]];
    [self.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    UIImageView *imageViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_home_clossstool_a"]];
    [contentView addSubview:imageViewIcon];
    [imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.width.height.equalTo(@39);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    self.MainCell = [[MainTableViewCell alloc] init];
    __weak MainTableContentCell *weakSelf = self;
    self.MainCell.seletedMessageContent = ^(NSString * _Nonnull seletedContent) {
        weakSelf.labelTitle = [UILabel labelWithText:seletedContent textColor:kRGBAlpha(102, 102, 102, 1) font:[UIFont systemFontOfSize:18]];
    };
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.textColor = [[UIColor grayColor] init];
    self.labelTitle.numberOfLines = 0;
    [contentView addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10);
         make.top.equalTo(self.contentView).offset(12);
    }];

}

@end
