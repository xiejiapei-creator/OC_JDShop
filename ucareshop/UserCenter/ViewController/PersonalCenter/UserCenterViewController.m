//
//  UserCenterViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/22.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "UserCenterViewController.h"
#import "WalletTableViewCell.h"
#import "ShoppingCartViewController.h"
#import "SearchHotContentViewController.h"
#import "ProfileTableViewCell.h"
#import "OrderTableViewCell.h"
#import "AddressTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "SettingViewController.h"
#import "RechargeViewController.h"
#import "AddressManagementTableViewController.h"
#import "MyOrderViewController.h"
#import "LoginViewController.h"
#import "ViewController.h"
#import "URLRequest.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface UserCenterViewController () <UITableViewDataSource,UITableViewDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *searchButtonItem;
@property (nonatomic, strong) UIBarButtonItem *cartButtonItem;

@property (nonatomic, strong) URLRequest *urlRequest;
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic) NSInteger messageCount;

//系统核实
@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSInteger memberId;

@end

@implementation UserCenterViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //账号ID
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    self.statusCode = [plistDict[@"statusCode"] integerValue];
    
    [self requestForInfomation:self.statusCode];
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

//设置
- (void)click:(id)sender {
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    settingViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingViewController animated:YES];
}
//购物车
- (void)cart:(id)sender {
    //账号ID
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSInteger statusCode = [plistDict[@"statusCode"] integerValue];
    
    if (statusCode == 1) {
        ViewController *notificationViewController = [[ViewController alloc] init];
        notificationViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notificationViewController animated:YES];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
//搜索
- (void)search:(id)sender {
    SearchHotContentViewController *searchHotContentViewController = [[SearchHotContentViewController alloc] init];
    searchHotContentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchHotContentViewController animated:YES];
}
//登录
- (void)login:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginViewController animated:YES];
}
//注册
- (void)registerEvent:(id)sender {
     RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;//设置为0不起作用
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfo"];
            if (!cell) {
                cell = [[ProfileTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.statusCode == 1) {
                cell.gradeLabel.hidden = NO;
                cell.phoneNumberLabel.hidden = NO;
                cell.scoreLabel.hidden = NO;
                cell.nameLabel.hidden = NO;
                cell.settingButton.hidden = NO;
                cell.loginButton.hidden = YES;
                cell.registerButton.hidden = YES;
                
                
                [cell.settingButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
                cell.nameLabel.text = self.userInfoDict[@"nickname"];//呵呵
                
                NSString *score = [NSString stringWithFormat:@"积分：%@",self.userInfoDict[@"integral"]];
                cell.scoreLabel.text = score;//123
                NSString *phoneNumber = self.userInfoDict[@"telephone"] ;//15600001111
                NSString *headNumber = [phoneNumber substringToIndex:3];
                NSString *tailNumber = [phoneNumber substringFromIndex:7];
                NSString *phoneSecurityNumber = [NSString stringWithFormat:@"%@****%@",headNumber,tailNumber];
                cell.phoneNumberLabel.text = phoneSecurityNumber;
                cell.gradeLabel.text = self.userInfoDict[@"level"];//钻石
                cell.gradeLabel.font = [UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:22];
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userInfoDict[@"imageUrl"]]];
                cell.profileImageView.image = [UIImage imageWithData:data];
            } else {
                cell.gradeLabel.hidden = YES;
                cell.phoneNumberLabel.hidden = YES;
                cell.scoreLabel.hidden = YES;
                cell.nameLabel.hidden = YES;
                cell.settingButton.hidden = YES;
                cell.loginButton.hidden = NO;
                cell.registerButton.hidden = NO;
                
                
                cell.profileImageView.image = [UIImage imageNamed:@"userCenter_UserCenterViewController_profile"];
                [cell.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
                [cell.registerButton addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
        case 1: {
            WalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wallet"];
            if (!cell) {
                cell = [[WalletTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"wallet"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
            if (self.statusCode == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userInfoDict[@"balance"]];//10000.00
            } else {
                cell.detailTextLabel.text = @"";
            }
            return cell;
        }
        case 2: {
            OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
            if (!cell) {
                cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"order"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
            if (self.statusCode == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userInfoDict[@"orderCount"]];//12
            } else {
                cell.detailTextLabel.text = @"";
            }
            return cell;
        }
        case 3: {
            AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"address"];
            if (!cell) {
                cell = [[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"address"];
            
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
            return cell;
        }
        case 4: {
            NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notice"];
            if (!cell) {
                cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"notice"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
            if (self.statusCode == 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userInfoDict[@"messageCount"]];//34
            } else {
                cell.detailTextLabel.text = @"";
            }
            return cell;
        }
        default:
            return nil;
            break;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.statusCode == 1) {
        switch (indexPath.row) {
        case 1: {
            RechargeViewController  *rechargeViewController  = [[RechargeViewController  alloc] init];
            rechargeViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechargeViewController animated:YES];
            break;
        }
        case 2: {
            MyOrderViewController  *myOrderViewController  = [[MyOrderViewController  alloc] init];
            myOrderViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myOrderViewController animated:YES];
            break;
        }
        case 3: {
            AddressManagementTableViewController  *addressManagementTableViewController   = [[AddressManagementTableViewController  alloc] init];
            addressManagementTableViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressManagementTableViewController animated:YES];
            break;
        }
        case 4: {
            ViewController  *notificationViewController    = [[ViewController  alloc] init];
            notificationViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:notificationViewController animated:YES];
            break;
        }
        default:
            break;
    }
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"个人中心";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    [self.view addSubview:self.tableView];
    
    //导航栏按钮需要初始化后才能使用
    UIImage *cart = [UIImage imageNamed:@"home_homeViewController_rightBarButtonItem_enable"];
    UIImage *search = [UIImage imageNamed:@"home_homeViewController_leftBarButtonItem_enable"];
    self.searchButtonItem = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    self.cartButtonItem = [[UIBarButtonItem alloc] initWithImage:cart style:UIBarButtonItemStylePlain target:self action:@selector(cart:)];
    self.navigationItem.rightBarButtonItem = self.cartButtonItem;
    self.navigationItem.leftBarButtonItem = self.searchButtonItem;
}
// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)requestForInfomation:(NSInteger)statusCode {
    if (statusCode == 1) {
        //获取个人中心展示的信息
        self.urlRequest = [[URLRequest alloc] init];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setObject:@"3" forKey:@"memberId"];
        
        self.userInfoDict = [[NSMutableDictionary alloc] init];
        __weak UserCenterViewController *weakSelf = self;
        self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = content[@"content"];
                [weakSelf.userInfoDict removeAllObjects];
                weakSelf.userInfoDict = dict[@"re"];
                [weakSelf.tableView reloadData];
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [self.urlRequest startRequest:tempDict pathUrl:@"/member/getMemberCenterInfo"];
    }
    else
    {
        [self.tableView reloadData];
    }
}

#pragma mark - Getters and Setters

@end
