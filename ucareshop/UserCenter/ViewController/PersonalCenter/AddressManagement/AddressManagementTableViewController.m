//
//  AddressManagementTableViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AddressManagementTableViewController.h"
#import "AddAddressViewController.h"
#import "AddressManagementTableViewCell.h"
#import "URLRequest.h"
#import "UpdateAddressViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface AddressManagementTableViewController () <UITableViewDataSource,UITableViewDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *addButtonItem;
@property (nonatomic) NSIndexPath *indexPath;

//获取地址信息
@property (nonatomic, strong) URLRequest *urlRequestForAllAddress;
@property (nonatomic, strong) URLRequest *urlRequestForDefaultAddress;

@property (nonatomic, strong) NSArray *listAddress;
@property (nonatomic, strong) NSDictionary *addressInfoDict;

@property (nonatomic, strong) NSString *recever;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic) BOOL isDefault;


@property (nonatomic) NSInteger statusCode;
@property (nonatomic) NSString *mobile;

@property (nonatomic) NSString *indexString;

@end

@implementation AddressManagementTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadURLRequest];
    [self.tableView reloadData];
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

- (void)add:(id)sender {
    //在push到下一个界面时候调用传值
    AddAddressViewController *addAddressViewController = [[AddAddressViewController  alloc] init];
    addAddressViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAddressViewController animated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listAddress.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;//设置为0不起作用
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressManagement"];
    if (!cell) {
        cell = [[AddressManagementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressManagement"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //获得地址信息
    self.addressInfoDict = self.listAddress[indexPath.row];
    self.recever = self.addressInfoDict[@"receiver"];
    self.telephone = self.addressInfoDict[@"telephone"];
    self.address = self.addressInfoDict[@"completeAddress"];

    //显示到UI界面
    cell.nameLabel.text = self.recever;
    cell.phoneNumberLabel.text = self.telephone;
    cell.addressLabel.text = self.address;
    //联动颜色 + 颜色按钮状态改变
    __weak AddressManagementTableViewController *weakSelf = self;
    NSInteger checkStatus = [self.addressInfoDict[@"isDefault"] integerValue];
    if (checkStatus == 1) {
        self.isDefault = YES;
    } else {
        self.isDefault = NO;
    }
    if (self.isDefault) {
        cell.maskLayer.strokeColor = [UIColor greenColor].CGColor;
        self.indexPath = indexPath;
    } else {
        cell.maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    
    cell.transChangeColorBlock = ^() {
        //改变选中的为默认地址
        NSDictionary *dict = self.listAddress[indexPath.row];
        NSInteger index = [dict[@"id"] integerValue];
        self.indexString = [NSString stringWithFormat:@"%ld",(long)index];
        
        //设置默认地址
        NSArray *newKeysArr = [[NSArray alloc] initWithObjects:@"memberId",@"addressId",nil];
        NSArray *newValuesArr = [[NSArray alloc] initWithObjects:@"3",self.indexString,nil];
        NSDictionary *newDict = [NSDictionary dictionaryWithObjects:newValuesArr forKeys:newKeysArr];
        self.urlRequestForDefaultAddress = [[URLRequest alloc] init];
        self.urlRequestForDefaultAddress.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                [weakSelf reloadURLRequest];
                //可能删除掉就不会产生断续效果
                //因为请求了两次
//                [weakSelf.tableView reloadData];
                NSLog(@"改变默认地址成功");
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [self.urlRequestForDefaultAddress startRequest:newDict pathUrl:@"/address/setAddressDefault"];
    };
    //支持垃圾桶删除操作
    cell.transTrashBlock = ^{
        NSDictionary *dict = self.listAddress[indexPath.row];
        NSInteger index = [dict[@"id"] integerValue];
        NSString *indexString = [NSString stringWithFormat:@"%ld",(long)index];
        
        //获取地址列表
        URLRequest *urlRequestForDeleteAddress = [[URLRequest alloc] init];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setValue:indexString forKey:@"addressId"];
        urlRequestForDeleteAddress.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = content[@"content"];
                NSInteger deleteStatus = [dict[@"code"] integerValue];
                if (deleteStatus == 1) {
                    NSLog(@"删除成功");
                    [self reloadURLRequest];
                }
                if (deleteStatus == 2) {
                    NSLog(@"删除地址失败");
                }
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [urlRequestForDeleteAddress startRequest:tempDict pathUrl:@"/address/deleteAddress"];

    };
    //支持编辑操作
    cell.TransEditBlock = ^{
        NSDictionary *dict = self.listAddress[indexPath.row];
        NSInteger index = [dict[@"id"] integerValue];
        self.indexString = [NSString stringWithFormat:@"%ld",(long)index];
        
        //在push到下一个界面时候调用传值
        UpdateAddressViewController *updateAddressViewController = [[UpdateAddressViewController  alloc] init];
        updateAddressViewController.updateAddressId = self.indexString;
        
        updateAddressViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:updateAddressViewController animated:YES];
    };
    return cell;
}
//删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSDictionary *dict = self.listAddress[indexPath.row];
        NSInteger index = [dict[@"id"] integerValue];
        NSString *indexString = [NSString stringWithFormat:@"%ld",(long)index];
        
        
        //获取地址列表
        URLRequest *urlRequestForDeleteAddress = [[URLRequest alloc] init];
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [tempDict setValue:indexString forKey:@"addressId"];
        urlRequestForDeleteAddress.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSDictionary *dict = content[@"content"];
                NSInteger deleteStatus = [dict[@"code"] integerValue];
                if (deleteStatus == 1) {
                    NSLog(@"删除成功");
                    [self reloadURLRequest];
                }
                if (deleteStatus == 2) {
                    NSLog(@"删除地址失败");
                }
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [urlRequestForDeleteAddress startRequest:tempDict pathUrl:@"/address/deleteAddress"];
    }   
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)reloadURLRequest {
    //获取地址列表
    self.urlRequestForAllAddress = [[URLRequest alloc] init];
    self.listAddress = [[NSArray alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setValue:@"3" forKey:@"memberId"];
    
    [self.urlRequestForAllAddress startRequest:tempDict pathUrl:@"/address/getAddressList"];
    __weak AddressManagementTableViewController *weakSelf = self;
    self.urlRequestForAllAddress.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.listAddress = dict[@"re"];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
}

#pragma mark - Getters and Setters

@end
