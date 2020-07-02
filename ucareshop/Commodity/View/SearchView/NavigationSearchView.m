//
//  NavigationSearchView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "NavigationSearchView.h"
#import "SearchHotView.h"
#import "NavigationSearchView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface NavigationSearchView () <UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, readwrite) UITextField *searchTextField;
@property (nonatomic, readwrite) UIButton   *cancelButton;

@end

@implementation NavigationSearchView


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

- (void)editchange:(UITextField *)textfield {
    self.goodsName = textfield.text;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //搜索栏
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_search"]];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    [self.searchTextField addTarget:self action:@selector(editchange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.searchTextField];
    //取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:3.0 / 255.0 green:115.0 / 255.0 blue:255.0 / 255.0 alpha:1] forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.width.equalTo(@280);
        make.height.equalTo(@40);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTextField.mas_right).offset(30);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(7);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];

}

#pragma mark - Getters and Setters

@end
