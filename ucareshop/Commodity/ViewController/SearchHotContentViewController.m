//
//  SearchHotContentViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/29.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "SearchHotContentViewController.h"
#import "NavigationSearchView.h"
#import "CommodityDetailViewController.h"
#import "SearchHotView.h"
#import "SearchResultView.h"
#import "SearchFailedView.h"
#import "SearchTabelView.h"
#import <Masonry/Masonry.h>
#import "URLRequest.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface SearchHotContentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController  *searchViewController;

@property (nonatomic, strong) SearchHotView *searchHotView;
@property (nonatomic, strong) NavigationSearchView *navigationSearchView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) SearchResultView *searchResultView;
@property (nonatomic, strong) SearchFailedView *searchFailedView;
@property (nonatomic, strong) SearchTabelView *searchTabelView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) BOOL isHidden;

@end

@implementation SearchHotContentViewController

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

//跳转到详情界面
- (void)detail:(NSString *)goodsID {
    [self.navigationController setNavigationBarHidden:NO animated:YES];//隐藏导航栏，因为下半部分要上移动
    
    CommodityDetailViewController *commodityDetailViewController = [[CommodityDetailViewController alloc] init];
    commodityDetailViewController.commodityID = goodsID;
    commodityDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityDetailViewController animated:YES];
}

//点击取消
- (void)didClickCancelButton:(id)sender {
    self.searchResultView.searchTextField.text = @"";
    self.searchFailedView.searchTextField.text = @"";
    
    self.searchHotView.hidden = NO;
    self.tableView.hidden = NO;
    self.searchFailedView.hidden = YES;
    self.searchResultView.hidden = YES;
    [self.tableView reloadData];
    [self.navigationSearchView setHidden:YES];
    [self.maskView setHidden:YES];
    [self.searchTabelView setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationSearchView.searchTextField resignFirstResponder];
}
//开始编辑文本
- (void)searchTextFieldDidBeginEditing:(id)sender {

    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏，因为下半部分要上移动
    self.searchHotView.hidden = YES;//子页面出来，父页面隐藏
    [self.navigationSearchView setHidden:NO];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.hidden = NO;
    self.maskView.alpha = 0.3;
    self.searchTabelView.hidden = YES;
    CGPoint center = self.navigationSearchView.center;
    center.y -= 44;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.navigationSearchView.center = center;
        self.maskView.alpha = 1.0;
    } completion:nil];
    [self.navigationSearchView.searchTextField becomeFirstResponder];
}
//点击键盘上的搜索按钮
- (void)searchBarSearchButtonClicked {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏，因为下半部分要上移动
    self.searchHotView.hidden = YES;
    self.tableView.hidden = YES;
    self.navigationSearchView.hidden = YES;
    self.maskView.hidden = YES;
    self.searchTabelView.hidden = YES;
    
    //集合视图的数据
    //只用这个searchResultView.text来搜索
    //其余地方赋予值给它
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:self.searchResultView.text  forKey:@"goodsName"];
    
    __weak SearchHotContentViewController *weakSelf = self;
    URLRequest *urlRequestForResult = [[URLRequest alloc] init];
    urlRequestForResult.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSDictionary *dict = content[@"content"];
            weakSelf.searchResultView.events = [NSArray arrayWithArray:dict[@"re"]];
            [weakSelf.searchResultView reload];//重新加载
            if (weakSelf.searchResultView.events.count == 0) {
                self.searchFailedView.hidden = NO;
                self.searchResultView.hidden = YES;
                self.tableView.hidden = YES;
            } else {
                self.searchFailedView.hidden = YES;
                self.searchResultView.hidden = NO;
                self.tableView.hidden = YES;
            }
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForResult startRequest:tempDict pathUrl:@"/getGoodsByName"];
    self.searchResultView.blockGoodsId = ^(NSString *goodsID) {
        [weakSelf detail:goodsID];
    };
}
//清除内容跳转界面
- (void)clearContent:(id)sender {
    self.searchResultView.searchTextField.text = @"";
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏，因为下半部分要上移动
    self.searchHotView.hidden = NO;
    self.navigationSearchView.hidden = YES;
    self.maskView.hidden = YES;
    self.tableView.hidden = YES;
    self.searchResultView.hidden = YES;
}
#pragma mark - UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.navigationSearchView.searchTextField) {
        //YES
        [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏导航栏，因为下半部分要上移动
        self.searchHotView.hidden = YES;//子页面出来，父页面隐藏
        self.maskView.hidden = YES;
        self.tableView.hidden = YES;
        //NO
        self.navigationSearchView.hidden = NO;
        
        self.searchTabelView.nameList = nil;
        [self.searchTabelView.tableView reloadData];
        self.searchTabelView.hidden = NO;
        
        NSString *fullName = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //非空的情况下才能够补全
        if (fullName && ![fullName  isEqual: @""]) {
            self.searchTabelView.nameList = nil;
            [self searchCompletion:fullName];
        } else {
            //要是没有输入字符的话就应该清空之前的数据再刷新
            self.searchTabelView.nameList = nil;
            [self.searchTabelView.tableView reloadData];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.navigationSearchView.searchTextField) {
        self.searchResultView.searchTextField.text = textField.text;
    }
    if (textField == self.searchFailedView.searchTextField) {
        self.searchResultView.searchTextField.text = textField.text;
    }
    [self.searchResultView.collectionView reloadData];
    [self searchBarSearchButtonClicked];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//每一个分组下对应的tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
//设置每行对应的cell（展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"searchContent"];
    cell.textLabel.font = [UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:22];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.goodsName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    self.searchResultView.searchTextField.text = self.goodsName;
    
    [self searchBarSearchButtonClicked];
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"搜索";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    
    //热门搜索数据
    URLRequest *hotSearchRequest = [[URLRequest alloc] init];
    __weak SearchHotContentViewController *weakSelf = self;
    hotSearchRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
         if (errorStatusCode == 1) {
             NSDictionary *dict = content[@"content"];
             weakSelf.dataSource = [NSArray arrayWithArray:dict[@"re"]];
             [weakSelf.tableView reloadData];
         } else {
             NSLog(@"%@",content[@"msg"]);
         }
    };
    [hotSearchRequest startRequest:nil pathUrl:@"/getPopularSearchContent"];
    //建表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
//    self.tableView.tableHeaderView = self.searchHotView;
    self.tableView.tableHeaderView = nil;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskView.backgroundColor = [UIColor colorWithRed:56.0 / 255.0 green:56.0 / 255.0 blue:56.0 / 255.0 alpha:1];
    [self.maskView setHidden:YES];
    [self.view addSubview:self.maskView];
    //搜索页
    self.navigationSearchView = [[NavigationSearchView alloc] initWithFrame:CGRectZero];
    [self.navigationSearchView setHidden:YES];
    [self.view addSubview:self.navigationSearchView];
    [self.navigationSearchView.cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationSearchView.searchTextField.delegate = self;
    self.searchResultView.searchTextField.delegate = self;
    self.searchFailedView.searchTextField.delegate = self;
    
    self.searchHotView = [[SearchHotView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.searchHotView];
    
    
    //换页
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTextFieldDidBeginEditing:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.searchHotView addGestureRecognizer:tapGestureRecognizer];
    

    
    //搜索结果页
    [self.searchResultView setHidden:YES];
    [self.view addSubview:self.searchResultView];
    self.searchResultView.searchTextField.text = self.navigationSearchView.goodsName;
    [self.searchResultView.clearButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];

    
    //搜索无结果页
    [self.searchFailedView setHidden:YES];
    [self.view addSubview:self.searchFailedView];
    self.searchFailedView.searchTextField.text = self.navigationSearchView.goodsName;
    [self.searchFailedView.clearButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索补全页
    [self.searchTabelView setHidden:YES];
    [self.view addSubview:self.searchTabelView];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchHotView.mas_bottom).offset(7);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.navigationSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationSearchView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.searchTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navigationSearchView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.searchHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@120);
    }];
    [self.searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.searchFailedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


//自动补全热搜名称
- (void)searchCompletion:(NSString *)fullName {
    URLRequest *searchCompletion = [[URLRequest alloc] init];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:fullName  forKey:@"name"];
    
    __weak SearchHotContentViewController *weakSelf = self;
    searchCompletion.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
         if (errorStatusCode == 1) {
             NSDictionary *dict = content[@"content"];
             weakSelf.searchTabelView.nameList = [NSArray arrayWithArray:dict[@"re"]];
             
             weakSelf.searchTabelView.blockSeletedName = ^(NSString * _Nonnull seletedName) {
                 if (![seletedName  isEqual: @""] && seletedName) {
                     self.searchResultView.searchTextField.text = seletedName;
                     [self searchBarSearchButtonClicked];
                 }
             };
             [weakSelf.searchTabelView.tableView reloadData];
         } else {
             NSLog(@"%@",content[@"msg"]);
         }
    };
    [searchCompletion startRequest:tempDict pathUrl:@"/getGoodsName"];
}

#pragma mark - Getters and Setters
- (SearchResultView *)searchResultView {
    if (!_searchResultView) {
        _searchResultView = [[SearchResultView alloc] initWithFrame:CGRectZero];
    }
    return _searchResultView;
}
- (SearchFailedView *)searchFailedView {
    if (!_searchFailedView) {
        _searchFailedView = [[SearchFailedView alloc] initWithFrame:CGRectZero];
    }
    return _searchFailedView;
}
- (SearchTabelView *)searchTabelView {
    if (!_searchTabelView) {
        _searchTabelView = [[SearchTabelView alloc] initWithFrame:CGRectZero];
    }
    return _searchTabelView;
}


@end
