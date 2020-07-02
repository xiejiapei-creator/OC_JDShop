//
//  CommodityDetailViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommodityDetailViewController.h"
#import "HomeViewController.h"
#import "CommodityMessageView.h"
#import "CommodityDetailView.h"
#import "HomeViewController.h"
#import "CommodityMessageModel.h"
#import "CommodityCellData.h"

#import "ShoppingCartViewController.h"
#import "ConfirmOrderViewController.h"
#import "AutoScrollView.h"
#import "CommentView.h"
#import <ChameleonFramework/Chameleon.h>
#import "URLRequest.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import "LoginStatus.h"
#import "ToastView.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommodityDetailViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

//集合视图
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *events;
//翻页视图
@property (nonatomic, strong, readwrite) AutoScrollView *topScrollView;

@property (nonatomic, strong, readwrite) UIScrollView *bottomScrollView;
@property (nonatomic, strong, readwrite) UISegmentedControl *segment;
@property (nonatomic, strong, readwrite) CommodityMessageView *messageView;
@property (nonatomic, strong, readwrite) CommodityDetailView *detailView;
@property (nonatomic, strong, readwrite) CommentView *commentView;
@property (nonatomic, strong, readwrite) NSArray *segmentTitle;
@property (nonatomic, strong, readwrite) UIView *slider;

@property (nonatomic, strong, readwrite) UITextField *writeComment;

@property (nonatomic, assign, readwrite) int starNumber;
@property (nonatomic, strong, readwrite) CommodityMessageModel *commodityMessage;

@property (nonatomic, assign, readwrite) NSInteger totalPrice;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *typeUrlRequest;
@property (nonatomic, strong, readwrite) URLRequest *addCommodityUrl;
@property (nonatomic, strong, readwrite) URLRequest *confirmUrl;
@property (nonatomic, strong, readwrite) URLRequest *commentUrl;
@property (nonatomic, strong, readwrite) URLRequest *scoreUrl;
@property (nonatomic, assign, readwrite) int commodityNumber;
@property (nonatomic, assign, readwrite) NSInteger cartCommodityNumber;
@property (nonatomic, assign, readwrite) NSInteger cartStockNumber;
@property (nonatomic, strong, readwrite) ToastView *toast;

@property (nonatomic, strong, readwrite) NSString *commodityName;
@property (nonatomic, strong, readwrite) NSString *typeId;
@property (nonatomic, strong, readwrite) NSString *typeName;

@property (nonatomic, strong, readwrite) UIView *bottomView;
@property (nonatomic, strong, readwrite) UILabel *commodityPriceTitle;
@property (nonatomic, strong, readwrite) UILabel *commodityPrice;
@property (nonatomic, strong, readwrite) UIButton *gotoShoppingCart;
@property (nonatomic, strong, readwrite) UIButton *settleAccount;
@property (nonatomic, strong, readwrite) UILabel *brandView;
@property (nonatomic, assign, readwrite) NSInteger brandNumber;
@property (nonatomic, strong, readwrite) NSString *commodityNumberValue;

@end

@implementation CommodityDetailViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSegmentTitle];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.segment.selectedSegmentIndex = 0;
    [self createCommodityMessageById];
    [self createAdImg];
    [self createScoreMessage];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.topScrollView.timer invalidate];
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

- (void)change {
    CGFloat offsetX = self.view.bounds.size.width * self.segment.selectedSegmentIndex;
    [self.bottomScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    [self updateSliderConstrain:self.segment.selectedSegmentIndex];
}

- (CGFloat)widthForSegmentAtIndex:(NSUInteger)segment {
    CGSize size = self.view.bounds.size;
    return size.width/3;
}

- (void) jumpShoppingCartView {
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 2;
}

- (void) jumpPaymentView {
    ConfirmOrderViewController *confirmOrder = [ConfirmOrderViewController new];
    confirmOrder.orderMessage = [self createOrderMessage];
    confirmOrder.commodityID = self.commodityID;
    confirmOrder.hidesBottomBarWhenPushed = YES;
    UINavigationController *obj = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    [obj pushViewController:confirmOrder animated:YES];
}

- (void) tapPaymentView {
    if ([LoginStatus isLogin]) {
        [self commitOrderMessage];
    } else {
        self.toast.toastType = @"false";
        self.toast.toastLabel.text = @"未登录";
        [self.toast show:^{}];
    }
}

- (void) addCart {
   if ([LoginStatus isLogin]) {
        NSInteger temp = [self.brandView.text integerValue];
       if (self.cartStockNumber == 0 || temp + _cartCommodityNumber > _cartStockNumber) {
           self.toast.toastType = @"false";
           self.toast.toastLabel.text = @"货存不足";
           [self.toast show:^{}];
       } else {
            if (temp + self.cartCommodityNumber >= self.cartStockNumber) {
              [self addCommodity:self.cartStockNumber - temp];
            } else {
               [self addCommodity:self.cartCommodityNumber];
            }
       }
    } else {
        self.toast.toastType = @"false";
        self.toast.toastLabel.text = @"未登录";
        [self.toast show:^{}];
    }
}

- (void) changeBrand {
    if ([self.brandView.text integerValue] == 0) {
        self.brandView.hidden = YES;
    } else {
        self.brandView.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    self.segment.selectedSegmentIndex = index;
    [self updateSliderConstrain:index];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    return scrollView.subviews[index];
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"商品详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏按钮需要初始化后才能使用
//    UIImage *back = [UIImage imageNamed:@"shoppingCart_ConfirmOrderViewController_tabBarLeftButton_enable"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStylePlain target:self action:@selector(jumpHome)];
}

// 添加子视图
- (void)createSubViews {
    self.commodityNumberValue = [NSString stringWithFormat:@"%d",1];
    self.urlRequest = [URLRequest new];
    self.typeUrlRequest = [URLRequest new];
    self.addCommodityUrl = [URLRequest new];
    self.confirmUrl = [URLRequest new];
    self.commentUrl = [URLRequest new];
    self.scoreUrl = [URLRequest new];
    CGSize viewSize = self.view.bounds.size;
    self.topScrollView = [[AutoScrollView alloc]initWithFrame:CGRectZero];
    self.topScrollView.pageView.currentPageIndicatorTintColor = UIColor.cyanColor;
    [self.view addSubview:self.topScrollView];

    self.segment = [[UISegmentedControl alloc]initWithItems:self.segmentTitle];
    self.segment.backgroundColor = [UIColor whiteColor];
    self.segment.tintColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1];
    self.segment.layer.borderWidth = 0;
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: UIColor.flatGreenColor};
    [self.segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName: UIColor.lightGrayColor};
    [self.segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    self.segment.layer.borderColor = UIColor.whiteColor.CGColor;
    [self.segment addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    self.slider = [[UIView alloc]initWithFrame:CGRectZero];
    self.slider.backgroundColor = UIColor.flatGreenColor;
    [self.view addSubview:self.slider];
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.scrollEnabled = YES;
    self.bottomScrollView.showsHorizontalScrollIndicator = YES;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.minimumZoomScale = 0.5;
    self.bottomScrollView.maximumZoomScale = 2.0;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.userInteractionEnabled = YES;
    self.bottomScrollView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.bottomScrollView];
    self.bottomScrollView.contentSize = CGSizeMake(viewSize.width*3, viewSize.height - 434);
    __weak CommodityDetailViewController *weakself = self;
    //添加子视图
    self.messageView = [[CommodityMessageView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - 336)];
    self.messageView.backgroundColor = UIColor.whiteColor;
    self.messageView.commodityIntroduce.text = self.commodityMessage.commodityName;
    self.messageView.typeNumber = ^(NSInteger commodityNumber) {
        //从view中获取品类ID,此时的commodityNumber是单选按钮的下标
        weakself.typeId = weakself.commodityMessage.commodityTypeList[commodityNumber][@"propertyId"];
        weakself.typeName = weakself.commodityMessage.commodityTypeList[commodityNumber][@"propertyName"];
        [weakself createOrderMessageByType];
    };
    self.messageView.cartCommodityNumber = ^(NSInteger commodityNumber, NSInteger stockNumber) {
        //加入购物车接口
        weakself.cartCommodityNumber = commodityNumber;
        weakself.cartStockNumber = stockNumber;
        [weakself addCart];
    };
    self.messageView.totalPriceNumber = ^(NSInteger commodityNumber) {
        weakself.totalPrice = commodityNumber;
        NSLog(@"%ld", commodityNumber);
        weakself.commodityPrice.text = [NSString stringWithFormat:@"%@%ld",@"¥" , commodityNumber];
    };
    self.messageView.confirmOrderCommodityNumber = ^(NSInteger commodityNumber) {
        weakself.commodityNumberValue = [NSString stringWithFormat:@"%ld", commodityNumber];
    };
    [self.bottomScrollView addSubview:self.messageView];
    
    self.detailView = [[CommodityDetailView alloc]initWithFrame:CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height - 336)];
    self.detailView.backgroundColor = UIColor.whiteColor;
    [self.detailView updateContentConstrain];
    [self.bottomScrollView addSubview:self.detailView];
    
    self.writeComment = [[UITextField alloc]initWithFrame:CGRectMake(0, viewSize.height - 110, viewSize.width, 40)];
    self.writeComment.delegate = self;
    self.writeComment.borderStyle = UITextBorderStyleRoundedRect;
    self.writeComment.alpha = 0.0;
    self.writeComment.placeholder = @"评论";
    [self.view addSubview:self.writeComment];
    
    self.commentView = [[CommentView alloc]initWithFrame:CGRectMake(viewSize.width*2, 0, viewSize.width, viewSize.height - 336)];
    self.commentView.backgroundColor = UIColor.whiteColor;
    
    [self.commentView createCommentContentData:self.commodityID];
    
    self.commentView.starNumber = ^(int starNumber) {
        weakself.starNumber = starNumber;
    };
    [self.bottomScrollView addSubview:self.commentView];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self.view addSubview:self.toast];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.bottomView];
    self.commodityPriceTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityPriceTitle.font = [UIFont systemFontOfSize:14];
    self.commodityPriceTitle.textAlignment = NSTextAlignmentCenter;
    self.commodityPriceTitle.text = @"商品金额";
    [self.bottomView addSubview:self.commodityPriceTitle];
    self.commodityPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityPrice.font = [UIFont systemFontOfSize:14];
    self.commodityPrice.textColor = UIColor.redColor;
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", self.commodityMessage.commodityPrice];
    self.commodityPrice.textAlignment = NSTextAlignmentLeft;
    self.commodityPrice.numberOfLines = 0;
    [self.bottomView addSubview:self.commodityPrice];
    
    self.gotoShoppingCart = [[UIButton alloc]initWithFrame:CGRectZero];
    self.gotoShoppingCart.backgroundColor = UIColor.lightGrayColor;
    [self.gotoShoppingCart setTitle:@"购物车" forState:UIControlStateNormal];
    self.gotoShoppingCart.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.gotoShoppingCart addTarget:self action:@selector(jumpShoppingCartView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.gotoShoppingCart];
    
    self.settleAccount = [[UIButton alloc]initWithFrame:CGRectZero];
    self.settleAccount.backgroundColor = UIColor.redColor;
    self.settleAccount.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.settleAccount setTitle:@"去结算" forState:UIControlStateNormal];
    [self.settleAccount addTarget:self action:@selector(tapPaymentView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.settleAccount];
    
    self.brandView = [[UILabel alloc]initWithFrame:CGRectZero];
    self.brandView.backgroundColor = UIColor.redColor;
    self.brandView.layer.borderColor = UIColor.redColor.CGColor;
    self.brandView.layer.borderWidth = 1.0;
    self.brandView.layer.cornerRadius = 10;
    self.brandView.layer.masksToBounds = YES;
    self.brandView.text = @"0";
    self.brandView.font = [UIFont systemFontOfSize:12];
    self.brandView.adjustsFontSizeToFitWidth = YES;
    self.brandView.textColor = UIColor.whiteColor;
    self.brandView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.brandView];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self.view addSubview:self.toast];
    [self changeBrand];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@170);
    }];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(@2);
    }];
    
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom).mas_offset(2);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@50);
    }];
    [self.commodityPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
    }];
    [self.commodityPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.left.equalTo(self.commodityPriceTitle.mas_right).mas_offset(5);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
    }];
    [self.settleAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [self.gotoShoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView);
        make.right.equalTo(self.settleAccount.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [self.brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom).mas_offset(-45);
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-100);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (void)createSegmentTitle {
    self.segmentTitle = @[@"商品信息", @"详情", @"评论"];
}

- (void) updateSliderConstrain :(NSInteger) index {
    CGFloat width = self.view.bounds.size.width/3;
    NSInteger left = width*index;
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(@(left));
        make.width.equalTo(self.view).dividedBy(3);
        make.height.equalTo(@2);
    }];
}
//点击去结算，发送到后台的接口啊
- (void) commitOrderMessage {
    __weak CommodityDetailViewController *weakself = self;
    if (self.typeId == NULL) {
        self.typeId = self.commodityMessage.commodityTypeList[0][@"propertyId"];
    }
    if ([self.commodityID isKindOfClass:[NSNull class]] ||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@""]||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@"0"]) {
        
    } else {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[NSString stringWithFormat:@"%@", self.commodityID] forKey:@"goodsId"];
        [tempDict setObject:[NSString stringWithFormat:@"%@", self.commodityNumberValue] forKey:@"goodsNum"];
        [tempDict setObject:[NSString stringWithFormat:@"%@", self.typeId] forKey:@"goodsPropertyId"];
        self.confirmUrl.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSString *code = [NSString stringWithFormat:@"%@", content[@"code"]];
            if ([code isEqualToString:@"1"]) {
                NSString *str = [NSString stringWithFormat:@"%@", content[@"content"][@"status"]];
                if ([str isEqualToString: @"0"]) {
                    [weakself jumpPaymentView];
                } else if ([str isEqualToString: @"1"]){
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = @"商品不存在";
                    [weakself.toast show:^{}];
                } else if ([str isEqualToString: @"2"]) {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = @"商品已下架";
                    [weakself.toast show:^{}];
                } else if ([str isEqualToString: @"3"]) {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = @"库存不足";
                    [weakself.toast show:^{}];
                }
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = content[@"msg"];
                [weakself.toast show:^{}];
            }
        };
        [self.confirmUrl startRequest:tempDict pathUrl:@"/traingoods/goods/pay"];
    }
}
//向confirmOrder页面发送数据
- (NSMutableDictionary *) createOrderMessage {
    if (self.typeId == NULL) {
        self.typeId = self.commodityMessage.commodityTypeList[0][@"propertyId"];
    }
    if (self.typeName == NULL) {
        self.typeName = self.commodityMessage.commodityTypeList[0][@"propertyName"];
    }
    NSMutableArray *mutableArrayData = [NSMutableArray array];
    CommodityCellData *commodityCellData = [CommodityCellData new];
    commodityCellData.commodityName = self.commodityMessage.commodityName;
    commodityCellData.commodityImageName = self.commodityMessage.commodityImageName;
    commodityCellData.commodityPrice = self.commodityMessage.commodityPrice;
    commodityCellData.commodityNumber = [self.commodityNumberValue intValue];
    commodityCellData.primePrice = self.commodityMessage.primePrice;
    commodityCellData.commodityType = self.typeName;
    commodityCellData.propertyId = self.typeId;
    [mutableArrayData addObject:commodityCellData];
    self.totalPrice = self.commodityMessage.commodityPrice * self.commodityNumber;
    NSMutableDictionary *orderMessageArray = [[NSMutableDictionary alloc]init];
    [orderMessageArray setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"commodityNumber"];
    [orderMessageArray setValue:mutableArrayData forKey:@"commodity"];
    [orderMessageArray setValue:[NSString stringWithFormat:@"%d", self.commodityMessage.commodityPrice * [self.commodityNumberValue intValue]] forKey:@"totalPrice"];
    [orderMessageArray setValue:[NSString stringWithFormat:@"%d", self.commodityMessage.primePrice * [self.commodityNumberValue intValue]] forKey:@"primeTotalPrice"];
    return orderMessageArray;
}
//以商品的规格ID取数据
- (void) createOrderMessageByType {
    if (self.typeId == NULL) {
        self.typeId = self.commodityMessage.commodityTypeList[0][@"propertyId"];
    }
    __weak CommodityDetailViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[NSString stringWithFormat:@"%@", self.typeId] forKey:@"id"];
    self.typeUrlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        if ([content[@"code"] intValue] == 1) {
            if ([content[@"content"][@"msg"] isEqualToString:@"查询成功"]) {
                weakself.commodityMessage.commodityName = content[@"content"][@"re"][@"goodsName"];
                weakself.commodityMessage.commodityIntroduce = content[@"content"][@"re"][@"goodsDetail"];
                weakself.commodityMessage.commodityPrice = [content[@"content"][@"re"][@"discountPrice"] intValue];
                weakself.commodityMessage.stockNumber = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"goodsStock"]];
                weakself.commodityMessage.saleNumber = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"goodsSales"]];
                weakself.commodityMessage.commodityId = content[@"content"][@"re"][@"goodsId"];
                weakself.commodityMessage.primePrice = [content[@"content"][@"re"][@"salePrice"] intValue];
                weakself.commodityMessage.commodityImageName = content[@"content"][@"re"][@"picUrl"];
                weakself.messageView.commodityIntroduce.text = weakself.commodityMessage.commodityName;
                weakself.messageView.priceNumber = weakself.commodityMessage.commodityPrice;
                weakself.messageView.discountPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                weakself.messageView.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                weakself.messageView.stockNumber.text = weakself.commodityMessage.stockNumber;
                weakself.messageView.saleVolume.text = weakself.commodityMessage.saleNumber;
                weakself.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                weakself.detailView.detailContent.text = weakself.commodityMessage.commodityIntroduce;
                NSArray *arr = [weakself.commodityMessage.commodityImageName componentsSeparatedByString:@";"];
                [weakself.detailView.detailImage sd_setImageWithURL:arr[0]];
                [weakself.detailView updateContentConstrain];
                weakself.brandView.text = @"0";
                [weakself changeBrand];
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = content[@"content"][@"msg"];
                [weakself.toast show:^{
                    
                }];
            }
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"msg"];
            [weakself.toast show:^{}];
        }
    };
    [self.typeUrlRequest startRequest:tempDict pathUrl:@"/getGoodsInfoByPropertyId"];
}
//加入购物车
- (void) addCommodity : (NSInteger) commodityNum {
    __weak CommodityDetailViewController *weakself = self;
    if (self.typeId == NULL) {
        self.typeId = self.commodityMessage.commodityTypeList[0][@"propertyId"];
    }
    if ([self.commodityID isKindOfClass:[NSNull class]] ||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@""]||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@"0"]) {
        
    } else {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:self.commodityID forKey:@"goodsId"];
        [tempDict setObject:self.typeId forKey:@"goodsPropertyId"];
        [tempDict setObject:[NSString stringWithFormat:@"%ld", commodityNum] forKey:@"goodsNumber"];
        self.addCommodityUrl.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
            if ([str isEqualToString:@"1"]) {
                if ([content[@"content"] isKindOfClass:[NSNull class]]) {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = @"服务器错误";
                    weakself.toast.duration = 1.0;
                    [weakself.toast show:^{}];
                } else if ([content[@"content"][@"msg"] isEqualToString:@"加入购物车成功！"]){
                    int temp = [weakself.brandView.text intValue];
                    weakself.brandView.text = [NSString stringWithFormat:@"%ld", temp + commodityNum];
                    [weakself changeBrand];
                    weakself.toast.toastType = @"success";
                    weakself.toast.succeedToastLabel.text = @"加入购物车成功";
                    weakself.toast.duration = 1.0;
                    //修改购物车的brand
                    [weakself.toast show:^{
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        URLRequest *urlRequestForOrderNumber = [[URLRequest alloc] init];
                        urlRequestForOrderNumber.transDataBlock = ^(NSDictionary * _Nonnull content) {
                            NSInteger errorStatusCode = [content[@"code"] integerValue];
                            if (errorStatusCode == 1) {
                                NSInteger count = [content[@"content"] integerValue];
                                NSString *num  = [NSString stringWithFormat:@"%ld",(long)count];
                                delegate.shoppingCartNavigationController.tabBarItem.badgeValue = num;
                            } else {
                                NSLog(@"%@",content[@"msg"]);
                            }
                        };
                        [urlRequestForOrderNumber startRequest:nil pathUrl:@"/order/getCartGoodsNum"];
                        
                    }];
                    //防止连续点击
                    weakself.messageView.addShoppingCart.enabled = YES;
                    [weakself.messageView updateConstraints];
                } else {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = content[@"content"][@"msg"];
                    weakself.toast.duration = 1.0;
                    [weakself.toast show:^{}];
                }
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = content[@"msg"];
                weakself.toast.duration = 1.0;
                [weakself.toast show:^{}];
            }
        };
        [self.addCommodityUrl startRequest:tempDict pathUrl:@"/saveGoodsToCar"];
    }
}
//以商品ID取数据
- (void) createCommodityMessageById {
    __weak CommodityDetailViewController *weakself = self;
    if ([self.commodityID isKindOfClass:[NSNull class]] ||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@""]||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@"0"]) {
        
    } else {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        [temp setObject:[NSString stringWithFormat:@"%@", self.commodityID] forKey:@"id"];
        self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            if ([content[@"code"] intValue] == 1) {
                if ([content[@"content"][@"msg"] isEqualToString:@"查询成功"]) {
                    CommodityMessageModel *commodityMessage = [CommodityMessageModel new];
                    commodityMessage.commodityName = content[@"content"][@"re"][@"goodsInfoDTO"][@"goodsName"];
                    commodityMessage.commodityIntroduce = content[@"content"][@"re"][@"goodsInfoDTO"][@"goodsDetail"];
                    commodityMessage.commodityPrice = [content[@"content"][@"re"][@"goodsInfoDTO"][@"discountPrice"] intValue];
                    commodityMessage.stockNumber = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"goodsInfoDTO"][@"goodsStock"]];
                    commodityMessage.saleNumber = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"goodsInfoDTO"][@"goodsSales"]];
                    commodityMessage.commodityId = content[@"content"][@"re"][@"goodsInfoDTO"][@"goodsId"];
                    commodityMessage.primePrice = [content[@"content"][@"re"][@"goodsInfoDTO"][@"salePrice"] intValue];
                    commodityMessage.commodityImageName = content[@"content"][@"re"][@"goodsInfoDTO"][@"picUrl"];
                    commodityMessage.commodityTypeList = content[@"content"][@"re"][@"goodsPropertyDTOList"];
                    weakself.commodityMessage = commodityMessage;
                    weakself.messageView.commodityIntroduce.text = weakself.commodityMessage.commodityName;
                    weakself.messageView.priceNumber = weakself.commodityMessage.commodityPrice;
                    weakself.messageView.discountPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                    weakself.messageView.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                    weakself.commodityPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", weakself.commodityMessage.commodityPrice];
                    weakself.messageView.stockNumber.text = weakself.commodityMessage.stockNumber;
                    weakself.messageView.saleVolume.text = weakself.commodityMessage.saleNumber;
                    weakself.detailView.detailContent.text = weakself.commodityMessage.commodityIntroduce;
                    NSArray *arr = [weakself.commodityMessage.commodityImageName componentsSeparatedByString:@";"];
                    [weakself.detailView.detailImage sd_setImageWithURL:arr[0]];
                    [weakself.detailView updateContentConstrain];
                    weakself.messageView.typeMessage = weakself.commodityMessage.commodityTypeList;
                    [weakself.messageView setRadioValue];
                    [weakself.messageView updateConstraints];
                } else {
                    weakself.toast.toastType = @"false";
                    weakself.toast.toastLabel.text = content[@"content"][@"msg"];
                    [weakself.toast show:^{
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = @"商品信息获取失败";
                [weakself.toast show:^{}];
            }
        };
        [self.urlRequest startRequest:temp pathUrl:@"/getGoodsInfoById"];
    }
}

- (void) createScoreMessage {
    __weak CommodityDetailViewController *weakself = self;
    if ([self.commodityID isKindOfClass:[NSNull class]] ||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@""]||[[NSString stringWithFormat:@"%@", self.commodityID] isEqualToString:@"0"]) {
        
    } else {
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        NSMutableDictionary *starDict = [NSMutableDictionary dictionary];
        [temp setObject:[NSString stringWithFormat:@"%@", self.commodityID] forKey:@"id"];
        self.scoreUrl.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
            if ([str isEqualToString:@"1"]) {
                [starDict setObject:content[@"content"][@"re"][@"fiveStar"] forKey:@"fiveStar"];
                [starDict setObject:content[@"content"][@"re"][@"fourStar"] forKey:@"fourStar"];
                [starDict setObject:content[@"content"][@"re"][@"threeStar"] forKey:@"threeStar"];
                [starDict setObject:content[@"content"][@"re"][@"twoStar"] forKey:@"twoStar"];
                [starDict setObject:content[@"content"][@"re"][@"oneStar"] forKey:@"oneStar"];
                weakself.commentView.starArray = starDict;
                weakself.commentView.scoreNumber = [NSString stringWithFormat:@"%d", [content[@"content"][@"re"][@"operationResult"] intValue]];
                [weakself.commentView drawLine];
                [weakself.commentView.commentContentTable reloadData];
            } else {
                weakself.toast.toastType = @"false";
                weakself.toast.toastLabel.text = @"获取商品评分失败";
                [weakself.toast show:^{}];
            }
        };
        [self.scoreUrl startRequest:temp pathUrl:@"/getCommentScoreByGoodsId"];
    }
}

- (void) createAdImg {
 //广告图片显示接口
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        URLRequest *picURLRequest = [[URLRequest alloc] init];
        __weak CommodityDetailViewController *weakself = self;
        picURLRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
            NSInteger errorStatusCode = [content[@"code"] integerValue];
            if (errorStatusCode == 1) {
                NSArray *listArry = [NSArray arrayWithArray:content[@"content"]];
                if ((listArry.count > 2) && (listArry.count < 11)) {
                    weakself.topScrollView.scrollImage = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in listArry) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"url"]]];
                        UIImage *image = [UIImage imageWithData:data];
                        if (image == nil) {
                            [weakself.topScrollView.scrollImage addObject:@""];
                        } else {
                            [weakself.topScrollView.scrollImage addObject:image];
                        }
                    }
                    weakself.topScrollView.scrollSize = CGSizeMake(self.view.bounds.size.width, 200);
                    weakself.topScrollView.duration = 1.0;
                }
            } else {
                NSLog(@"%@",content[@"msg"]);
            }
        };
        [picURLRequest startRequest:nil pathUrl:@"/advertisement/queryAdvertisementList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
        });
    });
}

#pragma mark - Getters and Setters

@end
