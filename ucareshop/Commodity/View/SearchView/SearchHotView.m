//
//  SearchHotView.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SearchHotView.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface SearchHotView () < UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, readwrite) UILabel *hotSearchLabel;
@property (nonatomic, readwrite) UILabel *searchLabel;
@property (nonatomic, readwrite) UITextField *searchTextField;

@end

@implementation SearchHotView


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

//跳转
- (void)click:(id)sender {
}
//单击
- (void)tapClick:(id)sender {
//    searchTfDidBeginEditing();
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UITableViewDataSource

# pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    //搜索标签
    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.searchLabel.text = @"热门搜索";
    self.searchLabel.font = [UIFont systemFontOfSize:25];
    [self addSubview:self.searchLabel];
    
    //搜索栏
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchTextField.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.placeholder = @"汽车用品";
    self.searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commodity_searchCommodityViewController_search"]];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.delegate = self;
    [self.searchTextField setEnabled:FALSE];
    [self addSubview:self.searchTextField];
    
 
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        make.top.equalTo(self.searchTextField.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@380);
        make.height.equalTo(@44);
    }];
}

#pragma mark - Getters and Setters

@end
