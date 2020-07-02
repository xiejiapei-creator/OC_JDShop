//
//  ShoppingCartViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ShoppingCartViewController.h"
#import "LoginViewController.h"
#import "CommodityPayTableViewCell.h"
#import "ConfirmOrderViewController.h"
#import "HomeViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "CommodityCellData.h"
#import "ToastView.h"
#import "AppDelegate.h"
#import "URLRequest.h"
#import <UIImageView+WebCache.h>
#import "Masonry.h"
#import "LoginStatus.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *cellIdifier = @"commodityOrder";

#pragma mark - 枚举

@interface ShoppingCartViewController ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性
    
@property (nonatomic, strong, readwrite) UITableView *commodityPayTable;
@property (nonatomic, strong, readwrite) NSArray <CommodityCellData *> *commodityPayCellData;

@property (nonatomic, strong, readwrite) UIView *bottomView;
@property (nonatomic, strong, readwrite) UIView *allSelection;
@property (nonatomic, strong ,readwrite) UILabel *allSelectionText;
@property (nonatomic, strong, readwrite) UILabel *commodityPriceText;
@property (nonatomic, strong, readwrite) UILabel *commodityPrice;
@property (nonatomic, strong, readwrite) UIButton *confirmOrderButton;
@property (nonatomic, strong, readwrite) UIView *whiteDot;
@property (nonatomic, strong, readwrite) UIView *nonSelection;
@property (nonatomic, assign, readwrite, getter=isSelected) BOOL selected;
@property (nonatomic, assign, readwrite) int allCommodityPrice;
@property (nonatomic, strong, readwrite) UIView *leftBottomLine;
@property (nonatomic, strong, readwrite) UIView *bottomLine;
@property (nonatomic, strong, readwrite) NSMutableArray *mutipleSelectContent;

@property (nonatomic, assign, readwrite) int totalPrice;
@property (nonatomic, assign, readwrite) int primeTotalPrice;
@property (nonatomic, assign, readwrite) int selectionCount;
@property (nonatomic, assign, readwrite) NSInteger currentCell;

@property (nonatomic, strong, readwrite) UIImageView *shoppingCartImage;

@property (nonatomic, strong, readwrite) NSMutableArray <NSIndexPath *> *deleteArray;

@property (nonatomic, strong, readwrite) NSMutableArray *cartIdList;

@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, assign, readwrite) NSInteger commodityIndex;

@property (nonatomic, strong, readwrite) ToastView *toast;

@end

@implementation ShoppingCartViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([LoginStatus isLogin]) {
        [self addGesture];
        self.commodityPayCellData = [NSArray array];
        [self createCellData];
        if (!self.allCommodityPrice) {
            self.allCommodityPrice = 0;
        }
        //设置表示图可编辑
        self.commodityPayTable.editing = YES;
        self.commodityPayTable.allowsSelection = YES;
        self.commodityPayTable.allowsSelectionDuringEditing = YES;
        self.commodityPayTable.allowsMultipleSelectionDuringEditing = YES;
        self.commodityPayTable.allowsMultipleSelection = YES;
        //总价默认为0
        self.totalPrice = 0;
        self.primeTotalPrice = 0;
        self.deleteArray = [NSMutableArray array];
        self.mutipleSelectContent = [NSMutableArray array];
        self.cartIdList = [NSMutableArray arrayWithArray:@[]];
        self.selected = YES;
        [self allSelect];
        [self.commodityPayTable reloadData];
    } else {
        LoginViewController *login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.commodityPayTable.alpha = 1.0;
    self.bottomView.alpha = 1.0;
    self.shoppingCartImage.alpha = 0.0;
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

- (void) createTransitionAnimated {
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.commodityPayTable.alpha = 0.0;
        self.bottomView.alpha = 0.0;
        self.shoppingCartImage.alpha = 1.0;
    } completion:nil];
}

- (void) showAlert : (NSInteger) cartGoodsId :(NSString *)propertyId{
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确定不要了吗？" preferredStyle:UIAlertControllerStyleAlert];
    __weak ShoppingCartViewController *weakself = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCell:cartGoodsId];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CommodityCellData *data = self.commodityPayCellData[self.currentCell];
        data.commodityNumber = 1;
        [weakself.commodityPayTable reloadData];
    }];
    [toast addAction:confirmAction];
    [toast addAction:cancelAction];
    //这个block是在alert显示的同时执行的
    [self presentViewController:toast animated:YES completion:^{}];
}

- (void) allSelect {
    self.selected = !self.selected;
    if (self.selected == YES) {
        self.allSelection.alpha = 1.0;
        self.nonSelection.alpha = 0.0;
        self.allSelectionText.text = @"取消全选";
        self.selectionCount = (int)self.commodityPayCellData.count;
        [self updateCartCommodityname];
        [self selectAllCommodity];
    } else {
        self.allSelection.alpha = 0.0;
        self.nonSelection.alpha = 1.0;
        self.selectionCount = 0;
        self.allSelectionText.text = @"全选";
        [self updateCartCommodityname];
        [self deselectAllCommodity];
    }
}
//cell的操作

- (void) deleteCell : (NSInteger) cartGoodsId {
    NSMutableArray *deleteCell = [NSMutableArray arrayWithArray:self.commodityPayCellData];
    [deleteCell removeObject:self.commodityPayCellData[self.commodityIndex]];
//    NSArray *array = [NSArray arrayWithArray:self.mutipleSelectContent];
    self.selected = YES;
    [self allSelect];
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥", 0];
    self.commodityPayCellData = deleteCell;
    if (self.commodityPayCellData.count == 0) {
        [self createTransitionAnimated];
    }
    [_commodityPayTable reloadData];
    //把剩下的再选上
//    NSArray *array = self.mutipleSelectContent;
//    for (int i = 0; i < array.count; i ++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.commodityPayTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            if ([self.commodityPayTable.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
//                [self.commodityPayTable.delegate tableView:self.commodityPayTable didSelectRowAtIndexPath:indexPath];
//            }
//    }
    //删除商品的toast
    [self deleteCommodity : cartGoodsId];
}
//删除的接口，已联通
- (void) deleteCommodity : (NSInteger) cartGoodsId {
    __weak ShoppingCartViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:[NSString stringWithFormat:@"%ld", cartGoodsId] forKey:@"cartGoodsId"];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if ([content[@"msg"] isEqualToString:@"成功"]) {
                weakself.toast.toastType = @"success";
                weakself.toast.succeedToastLabel.text = @"删除商品成功";
                weakself.toast.duration = 1.0;
                [weakself.toast show:^{
                    [weakself changeCartBrand];
                }];
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = @"删除商品失败";
                weakself.toast.duration = 1.0;
                [weakself.toast show:^{}];
            }
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/deleteCartGoods"];
}
- (void) totalScore : (NSInteger) index :(int) number {
    self.totalPrice = 0;
    self.primeTotalPrice = 0;
    CommodityCellData *data = self.commodityPayCellData[index];
    data.commodityNumber = number;
    for (CommodityCellData * data in self.mutipleSelectContent) {
        self.totalPrice += data.commodityPrice * data.commodityNumber;
        self.primeTotalPrice += data.commodityNumber *data.primePrice;
    }
    if (self.totalPrice != 0) {
        self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" , self.totalPrice];
    }
    [self updateCartCommodityname];
}
- (void) jumpConfirmOrderView {
    if (self.mutipleSelectContent.count == 0) {
        self.toast.toastType = @"false";
        self.toast.toastLabel.text = @"至少选择一种商品";
        [self.toast show:^{}];
    } else if (self.mutipleSelectContent.count > 0) {
        self.toast.toastType = @"success";
        self.toast.succeedToastLabel.text = @"成功";
        self.toast.duration = 1.0;
        [self.toast show:^{
            ConfirmOrderViewController *confirmOrderView = [ConfirmOrderViewController new];
            confirmOrderView.orderMessage = [self createOrderMessage];
            confirmOrderView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:confirmOrderView animated:YES];
        }];
    }
}
- (void) jumpHome {
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 0;
}
- (void) calculateTotalScore {
    self.totalPrice = 0;
    self.totalPrice = 0;
    for (CommodityCellData * data in self.mutipleSelectContent) {
        self.totalPrice += data.commodityPrice * data.commodityNumber;
        self.primeTotalPrice += data.commodityNumber *data.primePrice;
    }
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,self.totalPrice];
}

- (void) changeCartBrand {
    URLRequest *urlRequestForOrderNumber = [[URLRequest alloc] init];
    urlRequestForOrderNumber.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSInteger count = [content[@"content"] integerValue];
            NSString *num  = [NSString stringWithFormat:@"%ld",(long)count];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.shoppingCartNavigationController.tabBarItem.badgeValue = num;
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForOrderNumber startRequest:nil pathUrl:@"/order/getCartGoodsNum"];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commodityPayCellData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ShoppingCartViewController *weakself = self;
    CommodityPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdifier forIndexPath:indexPath];
    CommodityCellData *data = self.commodityPayCellData[indexPath.row];
    cell.commodityName.text = data.commodityName;
    cell.commodityNumber.text = [NSString stringWithFormat:@"%d",data.commodityNumber];
    cell.priceTitle.text = data.commodityType;
//    //存储cell的下标
    cell.index = indexPath.row;
    
    NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
    [cell.commodityImage sd_setImageWithURL:arr[0]];
    
    cell.price.text = [NSString stringWithFormat:@"%@%d",@"¥" ,data.commodityPrice];
    cell.primePrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"¥" , data.primePrice] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
    cell.cartGoodsId = [NSString stringWithFormat:@"%@", data.cartGoodsId];
    cell.propertyId = data.propertyId;
    cell.commodityNumberValue = ^(NSString * _Nonnull commodityNumber) {
        [weakself totalScore:indexPath.row :[commodityNumber intValue]];
    };
    //删除商品
    cell.commodityIndex = ^(NSInteger cartGoodsId, NSInteger index) {
        weakself.commodityIndex = index;
        [weakself deleteCell:cartGoodsId];
    };
    //点击后的样式
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell updateCellConstrain];
    [cell setNeedsUpdateConstraints];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //当存在，不存
    CommodityCellData *data = self.commodityPayCellData[indexPath.row];
    if (![self.cartIdList containsObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]]) {
        [self.cartIdList addObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]];
    }
    if (![self.mutipleSelectContent containsObject:self.commodityPayCellData[indexPath.row]]) {
        [self.mutipleSelectContent addObject:self.commodityPayCellData[indexPath.row]];
        self.selectionCount++;
    }
    if (self.selectionCount < self.commodityPayCellData.count && self.selectionCount > 0) {
        self.allSelection.alpha = 0.0;
        self.nonSelection.alpha = 1.0;
        self.allSelectionText.text = @"全选";
        self.selected = NO;
        [self calculateTotalScore];
    } else if (self.selectionCount == self.commodityPayCellData.count) {
        self.selected = NO;
        [self allSelect];
    } else {
    //遍历，相乘再相加
        [self calculateTotalScore];
    }
    [self updateCartCommodityname];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    //把没选的删掉
    if ([self.mutipleSelectContent containsObject:self.commodityPayCellData[indexPath.row]]) {
        [self.mutipleSelectContent removeObject:self.commodityPayCellData[indexPath.row]];
        self.selectionCount--;
    }
    CommodityCellData *data = self.commodityPayCellData[indexPath.row];
    if (![self.cartIdList containsObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]]) {
        [self.cartIdList removeObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]];
    }
    if (self.selectionCount < self.commodityPayCellData.count && self.selectionCount > 0) {
        self.allSelection.alpha = 0.0;
        self.nonSelection.alpha = 1.0;
        self.allSelectionText.text = @"全选";
        self.selected = NO;
        [self calculateTotalScore];
    } else if (self.selectionCount == 0) {
        self.selected = YES;
        [self allSelect];
    } else {
        [self calculateTotalScore];
    }
    [self updateCartCommodityname];
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleNone;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
}

// 添加子视图
- (void)createSubViews {
    self.cartIdList = [NSMutableArray array];
    self.commodityPayTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.commodityPayTable registerClass:[CommodityPayTableViewCell class] forCellReuseIdentifier:cellIdifier];
    self.commodityPayTable.delegate = self;
    self.commodityPayTable.dataSource = self;
    self.commodityPayTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commodityPayTable.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.commodityPayTable.layer.borderWidth = 1.0;
    [self.view addSubview:self.commodityPayTable];
    
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bottomView];
    
    self.allSelectionText = [[UILabel alloc]initWithFrame:CGRectZero];
    self.allSelectionText.text = @"全选";
    self.allSelectionText.font = [UIFont systemFontOfSize:12];
    [self.bottomView addSubview:self.allSelectionText];
    //单选按钮--选择后
    self.allSelection = [[UIView alloc]initWithFrame:CGRectZero];
    self.allSelection.backgroundColor = UIColor.blueColor;
    self.allSelection.userInteractionEnabled = YES;
    self.allSelection.alpha = 0.0;
    //遮罩路径
    UIBezierPath *radioButtonPath = [UIBezierPath bezierPath];
    [radioButtonPath addArcWithCenter:CGPointMake(10, 25) radius:8 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //加一个遮罩
    CAShapeLayer *radioButtonMask = [CAShapeLayer layer];
    radioButtonMask.frame = self.allSelection.bounds;
    radioButtonMask.path = radioButtonPath.CGPath;
    radioButtonMask.strokeColor = UIColor.blackColor.CGColor;
    radioButtonMask.lineWidth = 1.0;
    self.allSelection.layer.mask = radioButtonMask;
    [self.bottomView addSubview:self.allSelection];
    //画小白点
    self.whiteDot = [[UIView alloc]initWithFrame:CGRectZero];
    self.whiteDot.backgroundColor = UIColor.whiteColor;
    self.whiteDot.layer.cornerRadius = 3;
    [self.allSelection addSubview:self.whiteDot];
    //单选按钮--选择前
    self.nonSelection = [[UIView alloc]initWithFrame:CGRectZero];
    self.nonSelection.backgroundColor = UIColor.clearColor;
    self.nonSelection.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.nonSelection.layer.borderWidth = 1.0;
    self.nonSelection.layer.cornerRadius = 10.0;
    self.nonSelection.alpha = 1.0;
    [self.bottomView addSubview:self.nonSelection];
    
    self.commodityPriceText = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityPriceText.text = @"商品总价:";
    self.commodityPriceText.textAlignment = NSTextAlignmentLeft;
    self.commodityPriceText.font = [UIFont systemFontOfSize:12];
    self.commodityPriceText.layer.borderColor = UIColor.blackColor.CGColor;
    [self.bottomView addSubview:self.commodityPriceText];
    
    self.commodityPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d" ,@"¥" ,self.allCommodityPrice];
    self.commodityPrice.textColor = UIColor.redColor;
    self.commodityPrice.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.commodityPrice];
    
    self.confirmOrderButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.confirmOrderButton setTitle:@"去结算" forState:UIControlStateNormal];
    self.confirmOrderButton.backgroundColor = UIColor.flatMintColor;
    self.confirmOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.confirmOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmOrderButton addTarget:self action:@selector(jumpConfirmOrderView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.confirmOrderButton];
    
    self.leftBottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftBottomLine.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.leftBottomLine];
    
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.bottomLine];
    
    self.shoppingCartImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.shoppingCartImage.image = [UIImage imageNamed:@"emptyShoppingCart_shoppingCartViewController_shoppingCartStatus_enable"];
    self.shoppingCartImage.contentMode = UIViewContentModeCenter;
    self.shoppingCartImage.alpha = 0.0;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpHome)];
    self.shoppingCartImage.userInteractionEnabled = YES;
    [self.shoppingCartImage addGestureRecognizer:gesture];
    [self.view addSubview:self.shoppingCartImage];
    
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self.view addSubview:self.toast];
    
    self.urlRequest = [URLRequest new];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.shoppingCartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(30);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-50);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(3);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-3);
    }];
    [self.commodityPayTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        
    }];
    [self.confirmOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    [self.allSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@20);
    }];
    [self.whiteDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.allSelection);
        make.height.equalTo(@6);
        make.width.equalTo(@6);
    }];
    [self.nonSelection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
        make.bottom.equalTo(self.bottomView.mas_bottom).mas_offset(-15);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    [self.allSelectionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).mas_offset(35);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@30);
    }];
    [self.commodityPriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).mas_offset(100);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@68);
    }];
    [self.commodityPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commodityPriceText.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@70);
    }];
    [self.leftBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.top.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView);
        make.width.equalTo(@1);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}
//添加手势
- (void) addGesture {
    self.selected = NO;
    UITapGestureRecognizer *allSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelect)];
    [self.nonSelection addGestureRecognizer:allSelectGesture];
    UITapGestureRecognizer *nonSelectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allSelect)];
    [self.allSelection addGestureRecognizer:nonSelectGesture];
}
//更新约束
- (void) updateCartCommodityname {
    CGFloat nameWidth = [self.allSelectionText sizeThatFits:CGSizeZero].width;
    [self.allSelectionText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).mas_offset(35);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.width.equalTo(@(nameWidth));
        make.height.equalTo(@50);
    }];
    CGFloat allCommodityPrice = [self.commodityPrice sizeThatFits:CGSizeZero].width;
    [self.commodityPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commodityPriceText.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
        make.width.equalTo(@(allCommodityPrice));
    }];
}
//从远端获取数据
- (void) createCellData {
    __weak ShoppingCartViewController *weakself = self;
    NSMutableArray <CommodityCellData *> *mutableArrayData = [NSMutableArray array];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        if ([content[@"code"] intValue] != 1) {
            [UIView animateWithDuration:1.0 animations:^{
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = [NSString stringWithFormat:@"%@", content[@"msg"]];
                weakself.toast.duration = 1.0;
                [weakself.toast show:^{}];
            } completion:^(BOOL finished) {}];
        } else {
            if ([content[@"content"] isKindOfClass:[NSNull class]]) {
                [weakself createTransitionAnimated];
            } else {
                if ([content[@"content"] isKindOfClass:[NSString class]]) {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = [NSString stringWithFormat:@"%@", content[@"content"]];
                    weakself.toast.duration = 1.0;
                    [weakself.toast show:^{}];
                } else {
                    for (NSDictionary *dictData in content[@"content"]) {
                        CommodityCellData *commodityCellData = [CommodityCellData new];
                        commodityCellData.commodityName = dictData[@"gdsName"];
                        commodityCellData.commodityImageName = dictData[@"picUrl"];
                        commodityCellData.commodityPrice = [dictData[@"discountPrice"] intValue];
                        commodityCellData.commodityNumber = [dictData[@"goodsNum"] intValue];
                        commodityCellData.primePrice = [dictData[@"salePrice"] intValue];
                        commodityCellData.commodityType = dictData[@"property"];
                        commodityCellData.commodityId = dictData[@"goodsId"];
                        commodityCellData.propertyId = dictData[@"goodsPropertyId"];
                        commodityCellData.cartGoodsId = dictData[@"cartGoodsId"];
                        [mutableArrayData addObject:commodityCellData];
                    }
                }
                weakself.commodityPayCellData = mutableArrayData;
                [weakself.commodityPayTable reloadData];
            }
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/getMemberCartGoodsAdapter"];
}
//全选效果实现
- (void) selectAllCommodity {
//    CommodityCellData *data = self.commodityPayCellData[indexPath.row];
//    if (![self.cartIdList containsObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]]) {
//        [self.cartIdList addObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]];
//    }
    self.totalPrice = 0;
    self.primeTotalPrice = 0;
    for (int i = 0; i< self.commodityPayCellData.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.commodityPayTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        if (![self.mutipleSelectContent containsObject:self.commodityPayCellData[indexPath.row]]) {
            [self.mutipleSelectContent addObject:self.commodityPayCellData[indexPath.row]];
        }
        CommodityCellData *data = self.commodityPayCellData[indexPath.row];
        if (![self.cartIdList containsObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]]) {
            [self.cartIdList addObject:[NSString stringWithFormat:@"%@", data.cartGoodsId]];
        }
    }
    for (CommodityCellData * data in self.mutipleSelectContent) {
        self.totalPrice += data.commodityPrice * data.commodityNumber;
        self.primeTotalPrice += data.primePrice * data.commodityNumber;
    }
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,self.totalPrice];
    [self updateCartCommodityname];
}
//取消全选
- (void) deselectAllCommodity {
    self.totalPrice = 0;
    self.primeTotalPrice = 0;
    [self.cartIdList removeAllObjects];
    for (int i = 0; i< self.commodityPayCellData.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.commodityPayTable deselectRowAtIndexPath:indexPath animated:NO];
        if ([self.mutipleSelectContent containsObject:self.commodityPayCellData[indexPath.row]]) {
            [self.mutipleSelectContent removeObject:self.commodityPayCellData[indexPath.row]];
        }
    }
    for (CommodityCellData * data in self.mutipleSelectContent) {
        self.totalPrice += data.commodityPrice * data.commodityNumber;
        self.primeTotalPrice += data.primePrice * data.commodityNumber;
    }
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" , self.totalPrice];
    [self updateCartCommodityname];
}

- (NSMutableDictionary *) createOrderMessage {
    NSMutableDictionary *orderMessageArray = [[NSMutableDictionary alloc]init];
    [orderMessageArray setValue:[NSString stringWithFormat:@"%lu", self.mutipleSelectContent.count] forKey:@"commodityNumber"];
    [orderMessageArray setValue:self.mutipleSelectContent forKey:@"commodity"];
    [orderMessageArray setObject:self.cartIdList forKey:@"cartGoodsList"];
    [orderMessageArray setValue:[NSString stringWithFormat:@"%d", self.totalPrice] forKey:@"totalPrice"];
    [orderMessageArray setValue:[NSString stringWithFormat:@"%d", self.primeTotalPrice] forKey:@"primeTotalPrice"];
    return orderMessageArray;
}

- (UITableView *) commodityPayTable {
    if (!_commodityPayTable) {
        _commodityPayTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commodityPayTable.delegate = self;
        _commodityPayTable.dataSource = self;
    }
    return _commodityPayTable;
}

#pragma mark - Getters and Setters

@end
