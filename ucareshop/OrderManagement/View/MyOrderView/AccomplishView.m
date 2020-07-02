//
//  AccomplishView.m
//  ucareshop
//
//  Created by liushuting on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "AccomplishView.h"
#import "CommodityOrderTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "URLRequest.h"
#import "RefreshView.h"
#import <UIImageView+WebCache.h>
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

@interface AccomplishView ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UITableView *accomplishOrderTable;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) NSArray *orderMessage;
@property (nonatomic, strong, readwrite) RefreshView *refreshView;
@property (nonatomic, assign, readwrite) RefreshState refreshState;
@property (nonatomic, assign, readwrite) NSInteger dataStatus;
@end

@implementation AccomplishView


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

- (void)gotoComment : (UIButton *) sender{
    UIView *v = [sender superview];//获取父类view
    UIView *v1 = [v superview];
    UITableViewCell *cell = (UITableViewCell *)[v1 superview];//获取cell
    NSIndexPath *indexPathAll = [self.accomplishOrderTable indexPathForCell:cell];//获取cell对应的section
    NSArray *dataArray = self.orderMessage[indexPathAll.section][@"commodity"];
    OrderModel *data = dataArray[indexPathAll.row];
    self.writeComment(self.isHidden, data.commodityId, data.propertyId, data.commentId);
}

- (void) deleteOrder : (id) sender {
    self.deleteOrder(self.orderMessage[[sender tag]][@"orderNumber"]);
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
    if ([[NSString stringWithFormat:@"%@", data.commentStatus] isEqualToString:@"1"]) {
        cell.commentButton.hidden = NO;
        cell.commentButton.tag = indexPath.section;
        [cell.commentButton addTarget:self action:@selector(gotoComment:) forControlEvents:UIControlEventTouchUpInside];
        cell.accomplishComment.hidden = YES;
    } else {
        cell.commentButton.hidden = YES;
        cell.accomplishComment.hidden = NO;
    }
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
    orderStatus.text = @"已完成";
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
    
    UIButton *deleteOrder = [[UIButton alloc]initWithFrame:CGRectMake(cellSize.width - 95, 5, 80, 30)];
    deleteOrder.layer.borderColor = [UIColor colorWithHexString:@"#ff0000"].CGColor;
    deleteOrder.layer.borderWidth = 1.0;
    deleteOrder.layer.cornerRadius = 5.0;
    deleteOrder.hidden =  NO;
    deleteOrder.tag = section;
    [deleteOrder setTitle:@"删除订单" forState:UIControlStateNormal];
    [deleteOrder addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
    [deleteOrder setTitleColor:[UIColor colorWithHexString:@"#ff0000"] forState:UIControlStateNormal];
    deleteOrder.titleLabel.font = [UIFont systemFontOfSize:15];
    [footerView addSubview:deleteOrder];
    
    UIView *bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, 39, cellSize.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [footerView addSubview:bottomBorder];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderNumber(self.orderMessage[indexPath.section][@"orderNumber"]);
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
    self.orderNumber = ^(NSString * _Nonnull orderNumber) {};
    self.accomplishOrderTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.accomplishOrderTable.layer.borderWidth = 1.0;
    self.accomplishOrderTable.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.accomplishOrderTable.delegate = self;
    self.accomplishOrderTable.dataSource = self;
    self.accomplishOrderTable.backgroundColor = UIColor.whiteColor;
    self.accomplishOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.accomplishOrderTable registerClass:[CommodityOrderTableViewCell class] forCellReuseIdentifier:cellIdentifer];
    self.refreshView = [[RefreshView alloc]initWithFrame:CGRectMake(200, -54, 30, 30)];
    [self.accomplishOrderTable addSubview:self.refreshView];
    [self addSubview:self.accomplishOrderTable];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.accomplishOrderTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
}

// 下拉刷新

- (void) startRefresh {
    self.accomplishOrderTable.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);//改变contentInset的值就可以取消回弹效果停留在当前位置了
    self.refreshState = RefreshStateLoading;
}

- (void)setupRefresh {
    __weak AccomplishView *weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [weakself createData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [weakself.accomplishOrderTable reloadData];
            
        });
    });
}

- (void)endRefresh{
    if(self.refreshState == RefreshStateLoading){
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.accomplishOrderTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            self.refreshState = RefreshStateNormal;
            [self.refreshView loadingFinished];
        }];
    }
}

- (void)setRefreshState:(RefreshState)refreshState{
    __weak AccomplishView *weakself = self;
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
    __weak AccomplishView *weakself = self;
    self.dataStatus = 0;
    NSMutableArray *remoteOrderMessage = [NSMutableArray array];
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    [temp setObject:@"4" forKey:@"status"];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
         NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.dataStatus = 1;
            for (NSDictionary *dict in content[@"content"][@"orderDtoList"]) {
                NSMutableArray <OrderModel *> *mutableCommodityData = [NSMutableArray array];
                NSMutableDictionary *mutableOrderData = [NSMutableDictionary dictionary];
                    for (NSDictionary *commodityList in dict[@"orderGoodsList"]) {
                        OrderModel *orderModelMessage = [OrderModel new];
                        orderModelMessage.commodityNumber = [commodityList[@"goodsNum"] intValue];
                        orderModelMessage.commodityName = commodityList[@"gdsName"];
                       if ([commodityList[@"payPrice"] isKindOfClass:[NSNull class]]) {
                            orderModelMessage.commodityPrice = 0;
                        } else {
                            orderModelMessage.commodityPrice = [commodityList[@"payPrice"] intValue];
                        }
                        orderModelMessage.primePrice = [commodityList[@"salePrice"] intValue];
                        orderModelMessage.commodityImageName = commodityList[@"picUrl"];
                        orderModelMessage.commentStatus = commodityList[@"commentStatus"];
                        orderModelMessage.commodityType = commodityList[@"property"];
                        orderModelMessage.commodityId = commodityList[@"goodsId"];
                        orderModelMessage.propertyId = commodityList[@"goodsPropertyId"];
                        orderModelMessage.commentId = commodityList[@"id"];
                        [mutableCommodityData addObject:orderModelMessage];
                    }
                    [mutableOrderData setObject:dict[@"orderNum"] forKey:@"orderNumber"];
                    [mutableOrderData setObject:dict[@"orderPrice"] forKey:@"totalPrice"];
                    [mutableOrderData setObject:dict[@"payPrice"] forKey:@"orderPrimePrice"];
                    [mutableOrderData setObject:dict[@"status"] forKey:@"orderStatus"];
                    [mutableOrderData setObject:mutableCommodityData forKey:@"commodity"];
                    [remoteOrderMessage addObject:mutableOrderData];
                }
        }
        weakself.orderMessage = remoteOrderMessage;
        [weakself.accomplishOrderTable reloadData];
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
    NSArray *visibleCellArray = [self.accomplishOrderTable indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleCellArray) {
        CommodityOrderTableViewCell *cell = [self.accomplishOrderTable cellForRowAtIndexPath:indexPath];
        NSArray *dataArray = self.orderMessage[indexPath.section][@"commodity"];
        OrderModel *data = dataArray[indexPath.row];
        NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
        [cell.commodityImage sd_setImageWithURL:arr[0]];
    }
}

#pragma mark - Getters and Setters

@end
