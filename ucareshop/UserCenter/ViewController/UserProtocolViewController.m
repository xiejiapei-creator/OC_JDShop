//
//  UserProtocolViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/10.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "UserProtocolViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface UserProtocolViewController ()

#pragma mark - 私有属性

@property(nonatomic, strong) UITextView *infomationTextView;

@end

@implementation UserProtocolViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

#pragma mark - Events

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"用户服务协议";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.infomationTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.infomationTextView.text = @"第一条:所有权以及相关的权利：在本协议中是指：第一，所有权；第二，知识产权，包括但不限于著作权、专利权、商标权、商业秘密等；第三，除上述权利之外的对物、信息及其载体和表现形式的使用、利用、传播、复制、发行、编辑、修改、处分等权利。/n第二条:用户可以使用中国电信手机号码、宽带账号等作为本网站账号、登录本网站。用户也可以按照本网站要求的程序进行注册，获得在本网站的账号，登录本网站；按照本注册程序获得本网站账号的用户，可以在登录后通过“我的欢go”进行注册信息的变更及注销。用户也可以按照本网站要求的程序、使用用户拥有的其他第三方平台账号登录本网站。/n第三条:对于平台内经营者销售的商品，本网站依法履行平台责任，同时用户应当遵守与平台内经营者之间的约定，中国电信不参与平台内经营者与用户之间的交易或服务过程，不对平台内经营者的销售行为（包括但不限于发布商品信息、收取费用、商品配送、售后服务等）的合法性、真实性、有效性作任何明示和默示的担保，亦不对由此产生的后果承担法律责任。";
    self.infomationTextView.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.infomationTextView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.infomationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Getters and Setters

@end
