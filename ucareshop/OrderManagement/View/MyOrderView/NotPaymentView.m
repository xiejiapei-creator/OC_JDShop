//
//  NotPaymentView.m
//  ucareshop
//
//  Created by liushuting on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "NotPaymentView.h"
#import "CommodityOrderTableViewCell.h"
#import "CommodityCellData.h"
#import <ChameleonFramework/Chameleon.h>
#import "URLRequest.h"
#import "RefreshView.h"
#import <UIImageView+WebCache.h>
#import "ToastView.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *cellIdentifer = @"orderCell";

#pragma mark - 枚举

//订单状态：待付款-1，待发货-2，待收货-3，已完成-4，已取消-5
typedef NS_ENUM(NSUInteger, orderType) {
    NotPaymentOrder = 1,//待付款
    NotSentOrder = 2,//待发货
    NotReciveOrder = 3,//待收货
    AccomplishOrder = 4,//已完成
    CancelOrder = 5,//已取消
};

typedef NS_ENUM(NSUInteger, RefreshState) {
    RefreshStateNormal,//正常
    RefreshStatePulling,//释放即可刷新
    RefreshStateLoading,//加载中
};

@interface NotPaymentView ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UITableView *notPaymentOrderTable;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) NSArray *orderMessage;
@property (nonatomic, strong, readwrite) ToastView *toast;
@property (nonatomic, assign, readwrite) NSInteger index;
@property (nonatomic, strong, readwrite) RefreshView *refreshView;
@property (nonatomic, assign, readwrite) RefreshState refreshState;
@property (nonatomic, assign, readwrite) NSInteger dataStatus;
@end

@implementation NotPaymentView


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

- (void) payment : (id) sender {
    self.orderMessageValue(self.orderMessage[[sender tag]]);
}

- (void) cancelOrder : (id)sender{
    self.cancelOrder(self.orderMessage[[sender tag]][@"orderNumber"]);
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderMessage.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *commodityData = self.orderMessage[section][@"commodity"];
    return commodityData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *dataArray = self.orderMessage[indexPath.section][@"commodity"];
    OrderModel *data = dataArray[indexPath.row];
    cell.commodityName.text = data.commodityName;
    cell.propertyId = data.propertyId;
    if (data.commodityNumber) {
        cell.commodityNumber.text = [NSString stringWithFormat:@"%d", data.commodityNumber];
    } else {
        cell.commodityNumber.text = [NSString stringWithFormat:@"%d", 0];
    }
    cell.commodityId = data.commodityId;
    cell.price.text = [NSString stringWithFormat:@"%@%d",@"¥" , data.commodityPrice];
    cell.primePrice.text = [NSString stringWithFormat:@"%@%d",@"¥" , data.primePrice];
    cell.priceTitle.text =[NSString stringWithFormat:@"%@", data.commodityType];
    NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
    [cell.commodityImage sd_setImageWithURL:arr[0]];
    [cell updateCellConstrain];
    return cell;
}

//当UITableView为group时设置header样式
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *data = self.orderMessage[section];
    CGSize cellSize = self.bounds.size;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellSize.width, 40)];
    UILabel *orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, cellSize.width - 110, 30)];
    orderNumber.textAlignment = NSTextAlignmentLeft;
    orderNumber.font = [UIFont systemFontOfSize:15];
    orderNumber.text = [NSString stringWithFormat:@"%@%@",@"订单编号:",data[@"orderNumber"]];
    [headerView addSubview:orderNumber];
    UILabel *orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(cellSize.width - 95, 5, 80, 30)];
    orderStatus.layer.borderWidth = 2.0;
    orderStatus.layer.borderColor = [UIColor colorWithHexString:@"#ffae4b"].CGColor;
    orderStatus.textColor = [UIColor colorWithHexString:@"#ffae4b"];
    orderStatus.font = [UIFont systemFontOfSize:15];
    orderStatus.textAlignment = NSTextAlignmentCenter;
    orderStatus.layer.cornerRadius = 5.0;
    orderStatus.text = @"待付款";
    [headerView addSubview:orderStatus];
    UIView *topBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 1, cellSize.width, 1)];
    topBorder.backgroundColor = [UIColor colorWithHexString:@"#b7b7b7"];
    if (section !=0) {
        [headerView addSubview:topBorder];
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *data = self.orderMessage[section];
    CGSize cellSize = self.bounds.size;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellSize.width, 40)];
    UILabel *paymentNumber = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
    paymentNumber.textAlignment = NSTextAlignmentLeft;
    paymentNumber.font = [UIFont systemFontOfSize:15];
    paymentNumber.text = @"应付金额:";
    [footerView addSubview:paymentNumber];
    UILabel *commodityPrice = [[UILabel alloc]initWithFrame:CGRectMake(95, 5, 80, 30)];
    commodityPrice.textColor = [UIColor colorWithHexString:@"#ff2627"];
    commodityPrice.textAlignment = NSTextAlignmentLeft;
    commodityPrice.font = [UIFont systemFontOfSize:15];
    commodityPrice.text = [NSString stringWithFormat:@"%@%@", @"¥", data[@"totalPrice"]];
    [footerView addSubview:commodityPrice];
    
    UIButton *paymentButton = [[UIButton alloc]initWithFrame:CGRectMake(cellSize.width - 95, 5, 80, 30)];
    paymentButton.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
    paymentButton.layer.borderWidth = 1.0;
    paymentButton.layer.cornerRadius = 5.0;
    [paymentButton setTitle:@"去支付" forState:UIControlStateNormal];
    [paymentButton setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
    [paymentButton addTarget:self action:@selector(payment:) forControlEvents:UIControlEventTouchUpInside];
    
    paymentButton.tag = section;
    
    paymentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:paymentButton];
    
    UIButton *cancelOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(cellSize.width - 185, 5, 80, 30)];
    cancelOrderButton.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
    cancelOrderButton.layer.borderWidth = 1.0;
    cancelOrderButton.layer.cornerRadius = 5.0;
    [cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelOrderButton setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
    [cancelOrderButton addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    cancelOrderButton.tag = section;
    cancelOrderButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:cancelOrderButton];
    
    UIView *bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 39, cellSize.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [footerView addSubview:bottomBorder];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.jumpAction(self.orderMessage[indexPath.section][@"orderNumber"]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -64){
        if(self.refreshState == RefreshStateNormal){//小于临界值（在触发点以下），如果状态是正常就转为下拉刷新，如果正在刷新或者已经是下拉刷新则不变
            self.refreshState = RefreshStatePulling;
        }
    }else{//大于临界值（在触发点以上，包括触发点）
        if(scrollView.isDragging){//手指没有离开屏幕
            if(self.refreshState == RefreshStatePulling){//原来是下拉的话变成正常，原来是刷新或者正常的话不变
                self.refreshState = RefreshStateNormal;
            }
        }else{//手指离开屏幕
            if(self.refreshState == RefreshStatePulling){//原来是下拉的话变成加载中，原来是加载中或者正常的话不变
                [self startRefresh];
            }
        }
    }
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    self.urlRequest = [URLRequest new];
    self.notPaymentOrderTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.notPaymentOrderTable.layer.borderWidth = 1.0;
    self.notPaymentOrderTable.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.notPaymentOrderTable.delegate = self;
    self.notPaymentOrderTable.dataSource = self;
    self.notPaymentOrderTable.backgroundColor = UIColor.whiteColor;
    self.notPaymentOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.notPaymentOrderTable registerClass:[CommodityOrderTableViewCell class] forCellReuseIdentifier:cellIdentifer];
    self.refreshView = [[RefreshView alloc]initWithFrame:CGRectMake(200, -54, 30, 30)];
    [self.notPaymentOrderTable addSubview:self.refreshView];
    [self addSubview:self.notPaymentOrderTable];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self addSubview:self.toast];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.notPaymentOrderTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

// 下拉刷新
- (void)setupRefresh {
    __weak NotPaymentView *weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [weakself createData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [weakself.notPaymentOrderTable reloadData];
            
        });
    });
}

- (void) startRefresh {
    self.notPaymentOrderTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//改变contentInset的值就可以取消回弹效果停留在当前位置了
    self.refreshState = RefreshStateLoading;
}

- (void)endRefresh{
    if(self.refreshState == RefreshStateLoading){
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.notPaymentOrderTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.refreshState = RefreshStateNormal;
            [self.refreshView loadingFinished];
        }];
    }
}

- (void)setRefreshState:(RefreshState)refreshState{
    __weak NotPaymentView *weakself = self;
    _refreshState = refreshState;
    switch (refreshState) {
        case RefreshStateNormal:
            break;
        case RefreshStateLoading: {
            [weakself setupRefresh];
            if (weakself.dataStatus == 0) {
                [weakself.refreshView loading];
            } else {
                [weakself endRefresh];
            }
            break;
        }
        case RefreshStatePulling:
            [weakself.refreshView loading];
            break;
        default:
            break;
    }
}

- (void) createData {
    __weak NotPaymentView *weakself = self;
    self.dataStatus = 0;
    NSMutableArray *remoteOrderMessage = [NSMutableArray array];
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [temp setObject:@"1" forKey:@"status"];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.dataStatus = 1;
            for (NSDictionary *dict in content[@"content"][@"orderDtoList"]) {
                NSMutableArray <OrderModel *> *mutableCommodityData = [NSMutableArray array];
                NSMutableDictionary *mutableOrderData = [NSMutableDictionary dictionary];
                    for (NSDictionary *commodity in dict[@"orderGoodsList"]) {
                        OrderModel *orderModelMessage = [OrderModel new];
                        orderModelMessage.commodityNumber = [commodity[@"goodsNum"] intValue];
                        orderModelMessage.commodityName = commodity[@"gdsName"];
                        if ([commodity[@"payPrice"] isKindOfClass:[NSNull class]]) {
                            orderModelMessage.commodityPrice = 0;
                        } else {
                            orderModelMessage.commodityPrice = [commodity[@"payPrice"] intValue];
                        }
                        orderModelMessage.primePrice = [commodity[@"salePrice"] intValue];
                        orderModelMessage.commodityImageName = commodity[@"picUrl"];
                        orderModelMessage.commentStatus = commodity[@"commentStatus"];
                        orderModelMessage.commodityType = commodity[@"property"];
                        orderModelMessage.commodityId = commodity[@"goodsId"];
                        orderModelMessage.propertyId = commodity[@"goodsPropertyId"];
                        orderModelMessage.commentId = commodity[@"id"];
                        [mutableCommodityData addObject:orderModelMessage];
                    }
                    [mutableOrderData setObject:dict[@"orderNum"] forKey:@"orderNumber"];
                    [mutableOrderData setObject:dict[@"payPrice"] forKey:@"totalPrice"];
                    [mutableOrderData setObject:dict[@"orderPrice"] forKey:@"orderPrimePrice"];
                    [mutableOrderData setObject:dict[@"status"] forKey:@"orderStatus"];
                    [mutableOrderData setObject:mutableCommodityData forKey:@"commodity"];
                    [remoteOrderMessage addObject:mutableOrderData];
            };
           weakself.orderMessage = remoteOrderMessage;
            [weakself.notPaymentOrderTable reloadData];
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"msg"];
            [weakself.toast show:^{}];
        }
    };
    [self.urlRequest startRequest:temp pathUrl:@"/queryOrderListByTel"];
    
}
//订单状态：待付款-1，待发货-2，待收货-3，已完成-4，已取消-5
- (NSString *) tellOrderStatus : (NSString *) orderStatus{
    NSString *orderStatusMessage = [NSString string];
    switch ([orderStatus intValue]) {
        case NotPaymentOrder: {
            orderStatusMessage = @"待付款";
            break;
        }
        case NotSentOrder: {
            orderStatusMessage = @"待发货";
            break;
        }
        case NotReciveOrder: {
            orderStatusMessage = @"待收货";
            break;
        }
        case AccomplishOrder: {
            orderStatusMessage = @"已完成";
            break;
        }
        case CancelOrder: {
            orderStatusMessage = @"已取消";
            break;
        }
        default:{
            orderStatusMessage = @"netError";
            break;
        }
    }
    return orderStatusMessage;
}

- (void)showVisibleCellImage {
    NSArray *visibleCellArray = [self.notPaymentOrderTable indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleCellArray) {
        CommodityOrderTableViewCell *cell = [self.notPaymentOrderTable cellForRowAtIndexPath:indexPath];
        NSArray *dataArray = self.orderMessage[indexPath.section][@"commodity"];
        OrderModel *data = dataArray[indexPath.row];
        NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
        [cell.commodityImage sd_setImageWithURL:arr[0]];
    }
}

#pragma mark - Getters and Setters

@end
