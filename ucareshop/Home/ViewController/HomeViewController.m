//
//  HomeViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "HomeViewController.h"
#import "ShoppingCartViewController.h"
#import "ClassifyViewController.h"
#import "ViewController.h"
#import "EventCollectionViewCell.h"
#import "CommodityDetailViewController.h"
#import "PageControllTableViewCell.h"
#import "CollectionTableViewCell.h"
#import "SearchHotContentViewController.h"
#import "ScrollTableViewCell.h"
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "URLRequest.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RecommendTableViewCell.h"
#import "CommodityDetailViewController.h"

#import <Masonry/Masonry.h>

#import "ClassifyViewController.h"

#pragma mark - @class

#pragma mark - 常量

const CGFloat maxOffsetY = 250;

#pragma mark - 枚举

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

#pragma mark - 私有属性

@property (nonatomic, getter=isLogin) BOOL *login;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *searchButtonItem;
@property (nonatomic, strong) UIBarButtonItem *notificationButtonItem;
@property (nonatomic, strong) CollectionTableViewCell *collectionCell;
@property (nonatomic, strong) ScrollTableViewCell *scrollCell;
@property(strong, nonatomic) UILabel *recommendLabel;
@property(strong, nonatomic) UILabel *detailTextLabel;
@property(strong, nonatomic) UIButton *imageBtn;
@property (nonatomic) NSInteger num;
 
@property (nonatomic) BOOL canScroll;

@end

@implementation HomeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.selectedIndex = 0;//PUSH后选中tab，在viewWillAppear里修改
    [self.collectionCell.collectionView reloadData];
    [self picURLRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scrollCell.autoScrollView.timer invalidate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Events

- (void)moreInformation:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 1;
}
//导航栏按钮
- (void)notification:(id)sender {
    
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
- (void)search:(id)sender {
    SearchHotContentViewController *searchHotContentViewController = [[SearchHotContentViewController alloc] init];
    searchHotContentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchHotContentViewController animated:YES];
}

- (void)detail:(NSString *)goodsID {
    CommodityDetailViewController *commodityDetailViewController = [[CommodityDetailViewController alloc] init];
    commodityDetailViewController.hidesBottomBarWhenPushed = YES;
    commodityDetailViewController.commodityID = goodsID;
    [self.navigationController pushViewController:commodityDetailViewController animated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

//节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 200;
    }
    else if (indexPath.row == 1)
    {
        return 50;
    }
    else
    {
        //获取状态栏的rect
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        //获取导航栏的rect
        CGRect navRect = self.navigationController.navigationBar.frame;
        return self.view.bounds.size.height - 250 + statusRect.size.height + navRect.size.height - 9;
    }
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            self.scrollCell = [tableView dequeueReusableCellWithIdentifier:@"scroll"];
            if (!self.scrollCell) {
                self.scrollCell = [[ScrollTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scroll"];
            }
            return self.scrollCell;
        }
        case 1: {
            RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendLabel"];
            if (!cell) {
                cell = [[RecommendTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"recommendLabel"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.text = @"更多";//右文本
            UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [imageBtn setImage:[UIImage imageNamed:@"home_classificationViewController_arrow_right"] forState:UIControlStateNormal];
            imageBtn.frame = CGRectMake(0, 0, 25, 25);
            [imageBtn addTarget:self action:@selector(moreInformation:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = imageBtn;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右指示器
            cell.detailTextLabel.userInteractionEnabled = YES;
            cell.detailTextLabel.textColor = [UIColor blackColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreInformation:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            
            [cell.detailTextLabel addGestureRecognizer:tap];
            
            return cell;
        }
        case 2:
        {
            self.collectionCell = [tableView dequeueReusableCellWithIdentifier:@"collectionView"];
             if (!self.collectionCell) {
                 self.collectionCell = [[CollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionView"];
             }
             __weak HomeViewController *weakSelf = self;
             self.collectionCell.blockProperty = ^(NSInteger row, NSString *goodsId) {
                 [weakSelf detail:goodsId];
             };
             return self.collectionCell;
        }
        default:
            return nil;
            break;
    }
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"首页";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:    [UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:26.0f]}];
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    
    //导航栏按钮需要初始化后才能使用
    UIImage *cart = [UIImage imageNamed:@"home_homeViewController_rightBarButtonItem_enable"];
    UIImage *search = [UIImage imageNamed:@"home_homeViewController_leftBarButtonItem_enable"];
    self.searchButtonItem = [[UIBarButtonItem alloc] initWithImage:search style:UIBarButtonItemStylePlain target:self action:@selector(search:)];
    self.notificationButtonItem = [[UIBarButtonItem alloc] initWithImage:cart style:UIBarButtonItemStylePlain target:self action:@selector(notification:)];
    self.navigationItem.rightBarButtonItem = self.notificationButtonItem;
    self.navigationItem.leftBarButtonItem = self.searchButtonItem;

    //表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.scrollEnabled = YES;
    
    [self.view addSubview:self.tableView];
    
    self.canScroll = YES;
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

//广告接口
- (void)picURLRequest {
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        //广告图片显示接口
        URLRequest *picURLRequest = [[URLRequest alloc] init];
        __weak HomeViewController *weakSelf = self;
        picURLRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSArray *listArry = [NSArray arrayWithArray:content[@"content"]];
                if ((listArry.count > 2) && (listArry.count < 11)) {
                    weakSelf.scrollCell.autoScrollView.scrollImage = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in listArry) {
                        if (dict[@"url"] && ![dict[@"url"]  isEqual: @""]) {
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"url"]]];
                            UIImage *image = [UIImage imageWithData:data];
                            if (image) {
                                [weakSelf.scrollCell.autoScrollView.scrollImage addObject:image];
                            } else {
                                [weakSelf.scrollCell.autoScrollView.scrollImage addObject:@""];
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.scrollCell.autoScrollView.scrollSize = CGSizeMake(self.view.bounds.size.width, 200);
                            // 更新界面
                        weakSelf.scrollCell.autoScrollView.duration = 3;
                    });
                }
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [picURLRequest startRequest:nil pathUrl:@"/advertisement/queryAdvertisementList"];
    });
}


#pragma mark - Getters and Setters

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomCellOffset =  250;
//    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        // dao ding l
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
//        NSLog(@"aaaaaaaaaa");
        self.canScroll = NO;
        self.collectionCell.canContentScroll = YES;
    }
    else
    {
//        NSLog(@"bbbbbbbbbbbbb");
        self.canScroll = YES;
        self.collectionCell.canContentScroll = NO;
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.collectionCell.canContentScroll = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - public methods

@end
