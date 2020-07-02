//
//  SearchFailedView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/16.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "SearchFailedView.h"
#import <Masonry/Masonry.h>

@interface SearchFailedView () <UISearchBarDelegate,UITextFieldDelegate>

#pragma mark - 私有属性

@end

@implementation SearchFailedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
    }
    return self;
}

- (void)createSubViews {
    
    //搜索栏
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_search"]];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_clear_normal"] forState:UIControlStateNormal];
    [self.clearButton setImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_clear_selected"] forState:UIControlStateHighlighted];
    self.clearButton.frame = CGRectMake(0, 0, 30, 30);
    self.searchTextField.rightView = self.clearButton;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.searchTextField setEnabled:YES];
    [self addSubview:self.searchTextField];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_failed"]];
    [self addSubview:self.imageView];
}
- (void)createSubViewsConstraints {
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@380);
        make.height.equalTo(@44);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@250);
            make.height.equalTo(@250);
            make.center.equalTo(self);
    }];
}


@end
