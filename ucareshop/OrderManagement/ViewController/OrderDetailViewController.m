//
//  OrderDetailViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/9/11.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "OrderDetailViewController.h"
#import "CommodityOrderTableViewCell.h"
#import "CommodityDetailViewController.h"
#import "PaymentOrderViewController.h"
#import "MyOrderViewController.h"
#import "AllOrderView.h"
#import "NotPaymentView.h"
#import "NotReciveView.h"
#import "AccomplishView.h"
#import "CancelOrderView.h"
#import "URLRequest.h"
#import "OrderModel.h"
#import "AppDelegate.h"
#import "ToastView.h"
#import <UIImageView+WebCache.h>
#import <ChameleonFramework/Chameleon.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *cellIndifier = @"commodityMessage";

#pragma mark - 枚举

@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIView *timerView;
@property (nonatomic, strong, readwrite) UILabel *orderStatus;
@property (nonatomic, strong, readwrite) UILabel *timerNumber;
@property (nonatomic, strong, readwrite) UILabel *hourValue;
@property (nonatomic, strong, readwrite) UILabel *minuteValue;
@property (nonatomic, strong, readwrite) UILabel *secondValue;

@property (nonatomic, strong, readwrite) UITableView *commodityMessageTable;
@property (nonatomic, strong, readwrite) UIView *headerView;
@property (nonatomic, strong, readwrite) UIView *footerView;
@property (nonatomic, strong, readwrite) UIView *addressView;
@property (nonatomic, strong, readwrite) UIView *orderMessage;
@property (nonatomic, strong, readwrite) UIView *commodityPrice;

@property (nonatomic, strong, readwrite) UILabel *userName;
@property (nonatomic, strong, readwrite) UILabel *telNumber;
@property (nonatomic, strong, readwrite) UILabel *userAddress;
@property (nonatomic, strong, readwrite) UILabel *statusTag;
@property (nonatomic, assign, readwrite) CGFloat height;

@property (nonatomic, strong, readwrite) UILabel *totalMoneyTitle;
@property (nonatomic, strong, readwrite) UILabel *totalMoney;
@property (nonatomic, strong, readwrite) UILabel *saleTotalMoneyTitle;
@property (nonatomic, strong, readwrite) UILabel *saleTotalMoney;
@property (nonatomic, strong, readwrite) UILabel *orderMessgeTitle;
@property (nonatomic, strong, readwrite) UILabel *orderNumberTitle;
@property (nonatomic, strong, readwrite) UILabel *orderNumber;
@property (nonatomic, strong, readwrite) UILabel *paymentTimeTitle;
@property (nonatomic, strong, readwrite) UILabel *paymentTime;
@property (nonatomic, strong, readwrite) NSTimer *timer;

@property (nonatomic, strong, readwrite) UIView *bottomView;
@property (nonatomic, strong, readwrite) UIButton *paymentButton;
@property (nonatomic, strong, readwrite) UIButton *cancelButton;
@property (nonatomic, strong, readwrite) UIButton *reciveButton;
@property (nonatomic, assign, readwrite) NSInteger timeValue;
@property (nonatomic, strong, readwrite) NSString *orderStatusString;
@property (nonatomic, strong, readwrite) NSDictionary *orderMessageData;
@property (nonatomic, strong, readwrite) URLRequest *dataUrl;
@property (nonatomic, strong, readwrite) URLRequest *cancelOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *reciveOrderRequest;
@property (nonatomic, strong,readwrite) ToastView *toast;

@end

@implementation OrderDetailViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *colorArray = @[UIColor.orangeColor, UIColor.redColor];
    CGSize viewSize = self.view.bounds.size;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, viewSize.width, 44) andColors:colorArray];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = UIColor.whiteColor;
    [self.timer invalidate];
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

- (void) showAlert {
    __weak OrderDetailViewController *weakself = self;
    if ([self.orderStatusString isEqualToString:@"paymentOrder"]) {
        UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确认取消吗？？？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself createCancelOrder:self.orderMessageData[@"orderNumber"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [toast addAction:cancelAction];
        [toast addAction:confirmAction];
        //这个block是在alert显示的同时执行的
        [self presentViewController:toast animated:YES completion:^{}];
    } else if ([self.orderStatusString isEqualToString:@"reciveOrder"]) {
        UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确定收货吗？？？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself createReciveOrder:self.orderMessageData[@"orderNumber"]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [toast addAction:cancelAction];
        [toast addAction:confirmAction];
        //这个block是在alert显示的同时执行的
        [self presentViewController:toast animated:YES completion:^{}];
    }
}

- (void) startTimer {
    [self timing];
    self.timerNumber.hidden = NO;
     FLWeakProxy *target = [FLWeakProxy weakProxyForObject:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:target selector:@selector(timing) userInfo:nil repeats:YES];
}

- (void) timing {
    if (self.timeValue >= 0) {
        self.timerNumber.text = [NSString stringWithFormat:@"%ld时%ld分%ld秒后过期", self.timeValue/3600, self.timeValue/60, self.timeValue%60];
        -- self.timeValue;
    } else {
        self.orderStatus.text = @"已取消";
        self.timerNumber.hidden = YES;
        self.cancelButton.hidden = YES;
        self.paymentButton.hidden = YES;
        [self.timer invalidate];
        [self createCancelOrder:self.orderMessageData[@"orderNumber"]];
    }
}

- (void) tellStatus {
    if ([self.orderStatusString isEqualToString:@"reciveOrder"] || [self.orderStatusString isEqualToString:@"待收货"]) {
        self.bottomView.hidden = YES;
        if ([self.orderStatusString isEqualToString:@"paymentOrder"]) {
            self.reciveButton.hidden = YES;
        } else {
            self.cancelButton.hidden = YES;
            self.paymentTime.hidden = YES;
        }
    } else {
        self.bottomView.hidden = NO;
    }
}

- (void) cancelOrder {
    self.orderStatusString = @"paymentOrder";
    [self showAlert];
}

- (void) paymentOrder {
    [self jumpPaymentOrder];
}

- (void) reciveOrder {
    self.orderStatusString = @"reciveOrder";
    [self showAlert];
}

- (void) jumpPaymentOrder {
    PaymentOrderViewController *paymentOrder = [PaymentOrderViewController new];
    paymentOrder.orderMessage = self.orderMessageData;
    UINavigationController *obj = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    [obj pushViewController:paymentOrder animated:YES];
}

- (void) jumpMyorder {
    MyOrderViewController *myOrder = [MyOrderViewController new];
    UINavigationController *obj = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    [obj pushViewController:myOrder animated:YES];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *commodityData = self.orderMessageData[@"commodity"];
    return commodityData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndifier forIndexPath:indexPath];
    OrderModel *data = self.orderMessageData[@"commodity"][indexPath.row];
    cell.commodityName.text = data.commodityName;
    cell.commodityId = data.commodityId;
    cell.priceTitle.text = data.commodityType;
    cell.propertyId = data.propertyId;
    NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
    [cell.commodityImage sd_setImageWithURL:arr[0]];
    cell.commodityNumber.text = [NSString stringWithFormat:@"%d", data.commodityNumber];
    cell.price.text = [NSString stringWithFormat:@"%@%d", @"¥", data.commodityPrice];
    cell.primePrice.text = [NSString stringWithFormat:@"%@%d", @"¥", data.primePrice];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellConstrain];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityDetailViewController *commodityDetial = [CommodityDetailViewController new];
    OrderModel *arr = self.orderMessageData[@"commodity"][indexPath.row];;
    commodityDetial.commodityID = arr.commodityId;
    UINavigationController *obj = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    [obj pushViewController:commodityDetial animated:YES];
}

//当UITableView为group时设置header样式
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize viewSize = self.view.bounds.size;
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 150)];
    
    self.addressView = [[UIView alloc]initWithFrame:CGRectZero];
    self.addressView.backgroundColor = [UIColor colorWithHexString:@"#ffecf4" withAlpha:1];
    [self.headerView addSubview:self.addressView];
    
    self.timerView = [[UIView alloc]initWithFrame:CGRectZero];
    NSArray *colorArray = @[UIColor.orangeColor, UIColor.redColor];
    self.timerView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, viewSize.width, 80) andColors:colorArray];
    [self.headerView addSubview:self.timerView];
    
    self.orderStatus = [[UILabel alloc]initWithFrame:CGRectZero];
    self.orderStatus.textAlignment = NSTextAlignmentLeft;
    self.orderStatus.textColor = UIColor.whiteColor;
    self.orderStatus.text = [self tellOrderStatus:self.orderMessageData[@"orderStatus"]];
    self.orderStatus.font = [UIFont systemFontOfSize:15];
    [self.timerView addSubview:self.orderStatus];
    
    self.timerNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.timerNumber.textColor = UIColor.whiteColor;
    if ([[self tellOrderStatus:self.orderMessageData[@"orderStatus"]] isEqualToString: @"待付款"]) {
        self.timerNumber.hidden = NO;
    } else {
        self.timerNumber.hidden = YES;
    }
    self.timerNumber.textAlignment = NSTextAlignmentLeft;
    self.timerNumber.text = [NSString stringWithFormat:@"%ld时%ld分%ld秒后过期", self.timeValue/3600, self.timeValue/60, self.timeValue%60];
    self.timerNumber.font = [UIFont systemFontOfSize:15];
    [self.timerView addSubview:self.timerNumber];
    
    self.userAddress = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userAddress.text = self.orderMessageData[@"userAddress"];
    self.userAddress.numberOfLines = 0;
    self.userAddress.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.userAddress];
    //需要先把控件加入，然后计算高度
    self.height = [self calculateHeightOfText:self.userAddress].height;
    self.userName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userName.text = self.orderMessageData[@"userName"];
    self.userName.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.userName];

    self.telNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.telNumber.text = self.orderMessageData[@"userTel"];
    self.telNumber.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.telNumber];

    self.statusTag = [[UILabel alloc]initWithFrame:CGRectZero];
    self.statusTag.textColor = UIColor.flatYellowColorDark;
    self.statusTag.text = @"默认";
    self.statusTag.textAlignment = NSTextAlignmentCenter;
    self.statusTag.layer.borderColor = UIColor.flatYellowColorDark.CGColor;
    self.statusTag.layer.borderWidth = 1.0;
    self.statusTag.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.statusTag];
    [self updateAddressConstrains];
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGSize viewSize = self.view.bounds.size;
    self.footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 80.0)];
    self.footerView.backgroundColor = UIColor.clearColor;
    
    self.commodityPrice = [[UIView alloc]initWithFrame:CGRectZero];
    self.commodityPrice.backgroundColor = UIColor.whiteColor;
    [self.footerView addSubview:self.commodityPrice];
    
    self.orderMessage = [[UIView alloc]initWithFrame:CGRectZero];
    self.orderMessage.backgroundColor = UIColor.whiteColor;
    [self.footerView addSubview:self.orderMessage];
    
    self.totalMoneyTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.totalMoneyTitle.textColor = UIColor.lightGrayColor;
    self.totalMoneyTitle.text = @"订单总金额:";
    self.totalMoneyTitle.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyTitle.font = [UIFont systemFontOfSize:14];
    [self.commodityPrice addSubview:self.totalMoneyTitle];
    
    self.totalMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    self.totalMoney.textColor = UIColor.lightGrayColor;
    self.totalMoney.textAlignment = NSTextAlignmentCenter;
    self.totalMoney.text = [NSString stringWithFormat:@"%@%@", @"¥", self.orderMessageData[@"primeTotalPrice"]];
    self.totalMoney.font = [UIFont systemFontOfSize:14];
    [self.commodityPrice addSubview:self.totalMoney];
    
    self.saleTotalMoneyTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.saleTotalMoneyTitle.textColor = UIColor.lightGrayColor;
    self.saleTotalMoneyTitle.text = @"实付总金额:";
    self.saleTotalMoneyTitle.textAlignment = NSTextAlignmentCenter;
    self.saleTotalMoneyTitle.font = [UIFont systemFontOfSize:14];
    [self.commodityPrice addSubview:self.saleTotalMoneyTitle];
    
    self.saleTotalMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    self.saleTotalMoney.textColor = UIColor.lightGrayColor;
    self.saleTotalMoney.textAlignment = NSTextAlignmentCenter;
    self.saleTotalMoney.font = [UIFont systemFontOfSize:14];
    self.saleTotalMoney.text = [NSString stringWithFormat:@"%@%@",@"¥" , self.orderMessageData[@"totalPrice"]];
    [self.commodityPrice addSubview:self.saleTotalMoney];
    
    self.orderMessgeTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.orderMessgeTitle.textColor = UIColor.blackColor;
    self.orderMessgeTitle.text = @"订单信息:";
    self.orderMessgeTitle.textAlignment = NSTextAlignmentLeft;
    self.orderMessgeTitle.font = [UIFont systemFontOfSize:16];
    [self.orderMessage addSubview:self.orderMessgeTitle];
    
    self.orderNumberTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.orderNumberTitle.textColor = UIColor.lightGrayColor;
    self.orderNumberTitle.text = @"订单编号:";
    self.orderNumberTitle.textAlignment = NSTextAlignmentLeft;
    self.orderNumberTitle.font = [UIFont systemFontOfSize:14];
    [self.orderMessage addSubview:self.orderNumberTitle];
    
    self.orderNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.orderNumber.textColor = UIColor.lightGrayColor;
    self.orderNumber.text = self.orderMessageData[@"orderNumber"];
    self.orderNumber.textAlignment = NSTextAlignmentCenter;
    self.orderNumber.font = [UIFont systemFontOfSize:14];
    [self.orderMessage addSubview:self.orderNumber];
    
    self.paymentTimeTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.paymentTimeTitle.textColor = UIColor.lightGrayColor;
    self.paymentTimeTitle.text = @"订单创建时间:";
    self.paymentTimeTitle.textAlignment = NSTextAlignmentLeft;
    self.paymentTimeTitle.font = [UIFont systemFontOfSize:14];
    [self.orderMessage addSubview:self.paymentTimeTitle];
    
    self.paymentTime = [[UILabel alloc]initWithFrame:CGRectZero];
    self.paymentTime.textColor = UIColor.lightGrayColor;
    self.paymentTime.text = [NSString stringWithFormat:@"%@", self.orderMessageData[@"orderTime"]];
    self.paymentTime.textAlignment = NSTextAlignmentCenter;
    self.paymentTime.font = [UIFont systemFontOfSize:14];
    [self.orderMessage addSubview:self.paymentTime];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColor.whiteColor;
    [self.footerView addSubview:self.bottomView];

    if ([[self tellOrderStatus:self.orderMessageData[@"orderStatus"]] isEqualToString: @"待付款"]) {
        self.cancelButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
        self.cancelButton.layer.borderWidth = 1.0;
        self.cancelButton.layer.cornerRadius = 5.0;
        [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.bottomView addSubview:self.cancelButton];

        self.paymentButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.paymentButton.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
        self.paymentButton.layer.borderWidth = 1.0;
        self.paymentButton.layer.cornerRadius = 5.0;
        [self.paymentButton setTitle:@"去支付" forState:UIControlStateNormal];
        [self.paymentButton setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
        [self.paymentButton addTarget:self action:@selector(paymentOrder) forControlEvents:UIControlEventTouchUpInside];
        self.paymentButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.bottomView addSubview:self.paymentButton];
    } else if ([[self tellOrderStatus:self.orderMessageData[@"orderStatus"]] isEqualToString: @"待收货"]) {
        self.reciveButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.reciveButton.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
        self.reciveButton.layer.borderWidth = 1.0;
        self.reciveButton.layer.cornerRadius = 5.0;
        [self.reciveButton setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.reciveButton setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
        [self.reciveButton addTarget:self action:@selector(reciveOrder) forControlEvents:UIControlEventTouchUpInside];
        self.reciveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.reciveButton.hidden = NO;
        [self.bottomView addSubview:self.reciveButton];
    } else {
        self.cancelButton.hidden = YES;
        self.paymentButton.hidden = YES;
        self.reciveButton.hidden = YES;
    }
    [self createBottomContrains];
    
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 400.0f;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"订单详情";
    
    self.view.backgroundColor = UIColor.whiteColor;
}

// 添加子视图
- (void)createSubViews {
    self.dataUrl = [URLRequest new];
    self.cancelOrderRequest = [URLRequest new];
    self.reciveOrderRequest = [URLRequest new];
    self.commodityMessageTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.commodityMessageTable.delegate = self;
    self.commodityMessageTable.scrollEnabled = NO;
    self.commodityMessageTable.dataSource = self;
    [self.commodityMessageTable registerClass:[CommodityOrderTableViewCell class] forCellReuseIdentifier:cellIndifier];
    self.commodityMessageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.commodityMessageTable];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.userInteractionEnabled = NO;
    self.toast.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.toast];
    [self createOrderMessage:self.orderNumberString];
}

// 添加约束
- (void)createSubViewsConstraints {
    
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(1);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(1);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-2);
        make.height.equalTo(@200);
    }];
    
    [self.commodityMessageTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

- (CGSize) calculateHeightOfText : (UILabel *) textLabel{
    NSString *content = textLabel.text;
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    return size;
}

- (void) updateAddressConstrains {
    self.height = [self calculateHeightOfText:self.userAddress].height;
    CGFloat addressViewHeight = self.height +60;
    
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top);
        make.left.equalTo(self.headerView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.headerView.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@80);
    }];
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timerView.mas_top).mas_offset(10);
        make.left.equalTo(self.timerView.mas_left).mas_offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    [self.timerNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderStatus.mas_bottom).mas_offset(5);
        make.left.equalTo(self.timerView.mas_left).mas_offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timerView.mas_bottom).mas_offset(2);
        make.left.equalTo(self.headerView.mas_safeAreaLayoutGuideLeft).mas_offset(1);
        make.right.equalTo(self.headerView.mas_safeAreaLayoutGuideRight).mas_offset(-1);
        make.height.equalTo(@(addressViewHeight));
    }];
    [self.userAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).mas_offset(10);
        make.left.equalTo(self.addressView.mas_left).mas_offset(20);
        make.width.equalTo(self.addressView);
        make.height.equalTo(@(self.height));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_top).mas_offset(15);
        make.left.equalTo(self.addressView.mas_left).mas_offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    [self.userAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).mas_offset(10);
        make.left.equalTo(self.addressView.mas_left).mas_offset(20);
        make.width.equalTo(self.addressView);
        make.height.equalTo(@20);
    }];
    
    [self.telNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_top).mas_offset(15);
        make.left.equalTo(self.userName.mas_right).mas_offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [self.statusTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_top).mas_offset(15);
        make.left.equalTo(self.telNumber.mas_right).mas_offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    CGSize viewSize = self.view.bounds.size;
    CAShapeLayer *addressViewBorder = [CAShapeLayer layer];
    addressViewBorder.frame = CGRectMake(0, 0, viewSize.width, self.height + 60);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, viewSize.width-2, self.height + 60)];
    addressViewBorder.path = borderPath.CGPath;
    addressViewBorder.strokeColor = [UIColor colorWithHexString:@"#f864ad" withAlpha:1].CGColor;
    addressViewBorder.fillColor = nil;
    addressViewBorder.lineWidth = 2.0;
    addressViewBorder.lineDashPattern = @[@10, @3];
    addressViewBorder.lineJoin = kCALineJoinRound;
    addressViewBorder.lineDashPhase = 0;
    addressViewBorder.masksToBounds = YES;
    [self.addressView.layer addSublayer:addressViewBorder];
}
- (void) createBottomContrains {
    [self.commodityPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView.mas_top);
        make.left.equalTo(self.footerView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.footerView.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@100);
    }];
    [self.totalMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityPrice.mas_top).mas_offset(10);
        make.right.equalTo(self.totalMoney.mas_left).mas_offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [self.totalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityPrice.mas_top).mas_offset(10);
        make.width.equalTo(@80);
        make.right.equalTo(self.commodityPrice.mas_right);
        make.height.equalTo(@40);
    }];
    [self.saleTotalMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoneyTitle.mas_bottom);
        make.right.equalTo(self.saleTotalMoney.mas_left).mas_offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    [self.saleTotalMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalMoney.mas_bottom);
        make.width.equalTo(@80);
        make.right.equalTo(self.commodityPrice.mas_right);
        make.height.equalTo(@40);
    }];
    
    [self.orderMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityPrice.mas_bottom).mas_offset(10);
        make.left.equalTo(self.footerView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.footerView.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@100);
    }];
    [self.orderMessgeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderMessage.mas_top).mas_offset(10);
        make.left.equalTo(self.orderMessage.mas_left);
        make.right.equalTo(self.orderMessage.mas_right);
        make.height.equalTo(@30);
    }];
    [self.orderNumberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderMessgeTitle.mas_bottom);
        make.left.equalTo(self.orderMessage.mas_left).mas_offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.orderNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderMessgeTitle.mas_bottom);
        make.left.equalTo(self.orderNumberTitle.mas_right);
        make.right.equalTo(self.orderMessage.mas_right).mas_offset(20);
        make.height.equalTo(@30);
    }];
    [self.paymentTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumberTitle.mas_bottom);
        make.left.equalTo(self.orderMessage.mas_left).mas_offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    [self.paymentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumber.mas_bottom);
        make.left.equalTo(self.paymentTimeTitle.mas_right);
        make.right.equalTo(self.orderMessage.mas_right).mas_offset(20);
        make.height.equalTo(@30);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderMessage.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.footerView);
        make.height.equalTo(@44);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-100);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    [self.paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    [self.reciveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.bottomView.mas_right).mas_offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
}

- (void) createOrderMessage : (NSString *) orderNumber{
    __weak OrderDetailViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:orderNumber forKey:@"orderNum"];
    self.dataUrl.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            NSDictionary *dict = content[@"content"][@"orderDetail"];
            NSMutableArray <OrderModel *> *mutableCommodityData = [NSMutableArray array];
            NSMutableDictionary *mutableOrderData = [NSMutableDictionary dictionary];
            for (NSDictionary *commodity in dict[@"goodsList"]) {
                OrderModel *orderModelMessage = [OrderModel new];
                orderModelMessage.commodityNumber = [commodity[@"goodsNum"] intValue];
                orderModelMessage.commodityName = commodity[@"gdsName"];
                orderModelMessage.commodityPrice = [commodity[@"discountPrice"] intValue];
                if ([commodity[@"payPrice"] isKindOfClass:[NSNull class]]) {
                    orderModelMessage.primePrice = 0;
                } else {
                    orderModelMessage.primePrice = [commodity[@"salePrice"] intValue];
                }
                orderModelMessage.commodityImageName = commodity[@"picUrl"];
                orderModelMessage.commentStatus = commodity[@"commentStatus"];
                orderModelMessage.commodityType = commodity[@"property"];
                orderModelMessage.commodityId = commodity[@"goodsId"];
                orderModelMessage.propertyId = commodity[@"goodsPropertyId"];
                [mutableCommodityData addObject:orderModelMessage];
            }
            [mutableOrderData setObject:dict[@"orderNum"] forKey:@"orderNumber"];
            [mutableOrderData setObject:dict[@"payPrice"] forKey:@"totalPrice"];
            [mutableOrderData setObject:dict[@"orderPrice"] forKey:@"primeTotalPrice"];
            [mutableOrderData setObject:mutableCommodityData forKey:@"commodity"];
            [mutableOrderData setObject:dict[@"orderTime"] forKey:@"orderTime"];
            [mutableOrderData setObject:dict[@"receiptName"] forKey:@"userName"];
            [mutableOrderData setObject:dict[@"receiptTel"] forKey:@"userTel"];
            [mutableOrderData setObject:dict[@"receiptAddress"] forKey:@"userAddress"];
            [mutableOrderData setObject:dict[@"timeRemaining"] forKey:@"timeRemaining"];
            [mutableOrderData setObject:dict[@"status"] forKey:@"orderStatus"];
            [mutableOrderData setObject:dict[@"timeRemaining"] forKey:@"timeRemaining"];
            [mutableOrderData setObject:[NSString stringWithFormat:@"%ld", mutableCommodityData.count] forKey:@"commodityNumber"];
            weakself.orderMessageData = mutableOrderData;
            if ([[weakself tellOrderStatus:weakself.orderMessageData[@"orderStatus"]] isEqualToString: @"待付款"]) {
                if ([dict[@"timeRemaining"] integerValue] <= 0){
                    weakself.timeValue = 0;
                    weakself.orderStatus.text = @"已取消";
                    [weakself startTimer];
                } else {
                    [weakself startTimer];
                    weakself.timeValue =[dict[@"timeRemaining"] intValue];
                }
            }
            [weakself updateAddressConstrains];
            NSLog(@"%@", weakself.orderMessageData[@"commodity"]);
            [weakself.commodityMessageTable reloadData];
        }
    };
    [self.dataUrl startRequest:tempDict pathUrl:@"/order/getOrderDetail"];
}

//取消订单
- (void) createCancelOrder : (NSString *) orderNumber {
    __weak OrderDetailViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:orderNumber forKey:@"orderNum"];
    self.cancelOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = @"取消订单成功";
            [weakself.toast show:^{
                weakself.orderStatus.text = @"已取消";
                weakself.cancelButton.hidden = YES;
                weakself.paymentButton.hidden = YES;
                weakself.timerNumber.hidden = YES;
                [weakself.timer invalidate];
            }];
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"msg"];
            [weakself.toast show:^{
                
            }];
        }
    };
    [self.cancelOrderRequest startRequest:tempDict pathUrl:@"/order/cancelOrder"];
}
//确认收货
- (void) createReciveOrder : (NSString *) orderNumber {
    __weak OrderDetailViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:orderNumber forKey:@"orderNum"];
    self.reciveOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"content"][@"msg"];
            [weakself.toast show:^{
                weakself.orderStatus.text = @"已收货";
                weakself.reciveButton.hidden = YES;
            }];
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"msg"];
            [weakself.toast show:^{
            }];
        }
    };
    [self.reciveOrderRequest startRequest:tempDict pathUrl:@"/order/receivingGoods"];
}

//订单状态：待付款-1，待发货-2，待收货-3，已完成-4，已取消-5
- (NSString *) tellOrderStatus : (NSString *) orderStatus{
    NSString *orderStatusMessage = [NSString string];
    switch ([orderStatus intValue]) {
        case 1: {
            orderStatusMessage = @"待付款";
            break;
        }
        case 2: {
            orderStatusMessage = @"待发货";
            break;
        }
        case 3: {
            orderStatusMessage = @"待收货";
            break;
        }
        case 4: {
            orderStatusMessage = @"已完成";
            break;
        }
        case 5: {
            orderStatusMessage = @"已取消";
            break;
        }
        default:
            break;
    }
    return orderStatusMessage;
}

#pragma mark - Getters and Setters

@end
