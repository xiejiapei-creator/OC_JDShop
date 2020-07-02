//
//  PaymentOrderViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/24.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "PaymentOrderViewController.h"
#import "OrderDetailViewController.h"
#import "ShoppingCartViewController.h"
#import "UserMessageTableViewCell.h"
#import "RechargeViewController.h"
#import "CommodityCellData.h"
#import "CommodityOrderTableViewCell.h"
#import <ChameleonFramework/Chameleon.h>
#import "UserMessageCellData.h"
#import <UIImageView+WebCache.h>
#import "URLRequest.h"
#import "Masonry.h"
#import "MyOrderViewController.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *userMessageIdentifier = @"userMessageCell";
static NSString *commodityOrderIdentifer = @"commodityOrderCell";

#pragma mark - 枚举

typedef NS_ENUM(NSInteger, orderStatus) {
    
    notEnoughBalance = 0,
    orderSuccess = 1,
    
};

@interface PaymentOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UITableView *orderPaymenttable;
@property (nonatomic, strong, readwrite) NSArray <NSArray *> *cellData;

@property (nonatomic, strong, readwrite) UIButton *paymentOrderButton;
@property (nonatomic, strong, readwrite) UILabel *payCommodityMoney;
@property (nonatomic, strong, readwrite) UILabel *commodityMoney;
@property (nonatomic, strong, readwrite) UIView *leftBorder;
@property (nonatomic, strong, readwrite) UIView *bottomView;

@property (nonatomic, strong, readwrite) UIView *headerView;

@property (nonatomic, strong, readwrite) UIView *toast;
@property (nonatomic, strong, readwrite) UILabel *toastLabel;

@property (nonatomic, strong, readwrite) UIView *succeedToast;
@property (nonatomic, strong, readwrite) UIView *circle;
@property (nonatomic, strong, readwrite) UILabel *succeedToastLabel;

@property (nonatomic, assign, readwrite) int paymentStatus;
@property (nonatomic, strong, readwrite) UIView *alert;

@property (nonatomic, strong, readwrite) UIView *bottomLine;
@property (nonatomic, assign, readwrite) BOOL isSelected;

@property (nonatomic, assign, readwrite) NSInteger remainingSum;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *remainingMoneyUrlRequest;
@property (nonatomic, strong, readwrite) URLRequest *cancelRequest;
@property (nonatomic, strong, readwrite) URLRequest *reciveRequest;
@property (nonatomic, strong, readwrite) URLRequest *saveCommentRequest;

@end

@implementation PaymentOrderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createRemainingMoney];
    [self createCellData];
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

- (void) tellPaymentStatus {
    if (self.isSelected != 1) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.toast.alpha = 1.0;
            self.toastLabel.text = @"请选择支付方式";
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:^{
                self.toast.alpha = 0.0;
            } completion:^(BOOL finished) {}];
        }];
    } else if ([self.orderMessage[@"totalPrice"] integerValue] <= self.remainingSum) {
        [self paymentOrderMessage];
    } else {
        self.paymentStatus = notEnoughBalance;
        [self paymentOrder];
    }
}

- (void) paymentOrder {
    __weak PaymentOrderViewController *weakself = self;
    switch (self.paymentStatus) {
        case notEnoughBalance: {
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.toast.alpha = 1.0;
                weakself.toastLabel.text = @"余额不足";
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0 animations:^{
                    weakself.toast.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [weakself showAlert];
                }];
            }];
            break;
        }
        case orderSuccess: {
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.succeedToast.alpha = 1.0;
                weakself.succeedToast.alpha = 1.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0 animations:^{
                    weakself.succeedToast.alpha = 0.0;
                    weakself.succeedToast.alpha = 0.0;
                } completion:^(BOOL finished) {
                    UINavigationController *obj = self.navigationController;
                    MyOrderViewController *myOrder = [MyOrderViewController new];
                    myOrder.hidesBottomBarWhenPushed = YES;
                    [weakself.navigationController popViewControllerAnimated:NO];
                    [obj pushViewController:myOrder animated:YES];
                }];
            }];
            break;
        }
        default:
            break;
    }
}

- (void) showAlert {
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"去充值？？？" preferredStyle:UIAlertControllerStyleAlert];
    __weak PaymentOrderViewController *weakself = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RechargeViewController *recharge = [RechargeViewController new];
        [weakself.navigationController pushViewController:recharge animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回订单" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MyOrderViewController *myorder = [MyOrderViewController new];
        myorder.hidesBottomBarWhenPushed = YES;
        [weakself.navigationController pushViewController:myorder animated:YES];
    }];
    [toast addAction:confirmAction];
    [toast addAction:cancelAction];
    //这个block是在alert显示的同时执行的
    [self presentViewController:toast animated:YES completion:^{}];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
      return self.cellData[section].count;
    } else if (section == 1) {
       return 3;
    } else if (section == 2){
       return 1;
    } else {
        return self.cellData[section].count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CommodityOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commodityOrderIdentifer forIndexPath:indexPath];
        CommodityCellData *data = [self.orderMessage objectForKey:@"commodity"][indexPath.row];
        cell.commodityName.text = data.commodityName;
        cell.commodityNumber.text = [NSString stringWithFormat:@"%d", data.commodityNumber];
        
        NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
        [cell.commodityImage sd_setImageWithURL:arr[0]];
        
        cell.price.text = [NSString stringWithFormat:@"%@%d",@"¥" , data.commodityPrice];
        cell.primePrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"¥" , data.primePrice] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
        cell.priceTitle.text = data.commodityType;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellConstrain];
        return cell;
    } else if (indexPath.section == 2) {
        UserMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userMessageIdentifier forIndexPath:indexPath];
        UserMessageCellData *userData = self.cellData[indexPath.section][indexPath.row];
        cell.title.text = userData.title;
        cell.content.text = [NSString stringWithFormat:@"%@%ld", @"¥", self.remainingSum];
        cell.nonSelection.hidden = NO;
        __weak PaymentOrderViewController *weakself = self;
        cell.status = ^(BOOL status) {
            weakself.isSelected = status;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellConstraints];
        return cell;
    } else {
        UserMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userMessageIdentifier forIndexPath:indexPath];
        UserMessageCellData *userData = self.cellData[indexPath.section][indexPath.row];
        cell.title.text = userData.title;
        cell.content.text = userData.content;
        cell.nonSelection.hidden = YES;
        [cell updateTitleConstrain];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 2);
}

#pragma mark - UITableViewDelegate
//当UITableView为group时设置header样式
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGSize size = self.view.bounds.size;
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 80, 10)];
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 18, size.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [view addSubview:bottomLine];
        return view;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 40.0f;
    } else if (section == 0) {
        return 20.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 15, 80, 10)];
        view.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        view.layer.borderWidth = 1.0;
        UILabel *headerTextThird = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 80, 10)];
        headerTextThird.font = [UIFont systemFontOfSize:15];
        headerTextThird.text = @"支付方式";
        [view addSubview:headerTextThird];
        return view;
    } else if (section == 0) {
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 80, 10)];
        UILabel *headerTextThird = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 80, 10)];
        headerTextThird.font = [UIFont systemFontOfSize:15];
        headerTextThird.text = @"商品信息";
        [tableView.tableHeaderView addSubview:headerTextThird];
        return tableView.tableHeaderView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.0f;
    }
        return 18.0f;
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"支付订单";
    self.view.backgroundColor = UIColor.whiteColor;
}

// 添加子视图
- (void)createSubViews {
    self.urlRequest = [URLRequest new];
    self.remainingMoneyUrlRequest = [URLRequest new];
    self.cancelRequest = [URLRequest new];
    self.saveCommentRequest = [URLRequest new];
    self.reciveRequest = [URLRequest new];
    self.orderPaymenttable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.orderPaymenttable.layer.borderWidth = 1.0;
    self.orderPaymenttable.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.orderPaymenttable.delegate = self;
    self.orderPaymenttable.dataSource = self;
    self.orderPaymenttable.backgroundColor = UIColor.whiteColor;
    self.orderPaymenttable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderPaymenttable registerClass:[UserMessageTableViewCell class] forCellReuseIdentifier:userMessageIdentifier];
    [self.orderPaymenttable registerClass:[CommodityOrderTableViewCell class] forCellReuseIdentifier:commodityOrderIdentifer];
    [self.view addSubview:self.orderPaymenttable];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.layer.borderWidth = 0.0;
    self.bottomView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    [self.view addSubview:self.bottomView];
    
    self.paymentOrderButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.paymentOrderButton.backgroundColor = UIColor.flatMintColor;
    [self.paymentOrderButton setTitle:@"确认支付" forState:UIControlStateNormal];
    self.paymentOrderButton.backgroundColor = UIColor.flatMintColor;
    self.paymentOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.paymentOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.paymentOrderButton addTarget:self action:@selector(tellPaymentStatus) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.paymentOrderButton];
    
    self.payCommodityMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    self.payCommodityMoney.text = @"应付金额：";
    self.payCommodityMoney.font = [UIFont systemFontOfSize:12];
    self.payCommodityMoney.adjustsFontSizeToFitWidth = YES;
    self.payCommodityMoney.textAlignment = NSTextAlignmentLeft;
    [self. bottomView addSubview:self.payCommodityMoney];
    
    self.leftBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftBorder.backgroundColor = UIColor.lightGrayColor;
    [self.bottomView addSubview:self.leftBorder];
    
    self.commodityMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityMoney.text = [NSString stringWithFormat:@"%@%@", @"¥", self.orderMessage[@"totalPrice"]];
    self.commodityMoney.textColor = UIColor.redColor;
    self.commodityMoney.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:self.commodityMoney];
    
    self.toast = [[UIView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = [UIColor colorWithHexString:@"#3d3d3d"];
    self.toast.layer.cornerRadius = 10.0;
    self.toast.alpha = 0.0;
    [self.view addSubview:self.toast];
    self.toastLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.toastLabel.textAlignment = NSTextAlignmentCenter;
    self.toastLabel.font = [UIFont systemFontOfSize:16];
    self.toastLabel.textColor = UIColor.whiteColor;
    self.toastLabel.text = @"货存不足";
    [self.toast addSubview:self.toastLabel];
    
    self.succeedToast = [[UIView alloc]initWithFrame:CGRectZero];
    self.succeedToast.backgroundColor = [UIColor colorWithHexString:@"#3d3d3d"];
    self.succeedToast.layer.cornerRadius = 10.0;
    self.succeedToast.alpha = 0.0;
    [self.view addSubview:self.succeedToast];
    
    self.succeedToastLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.succeedToastLabel.textAlignment = NSTextAlignmentCenter;
    self.succeedToastLabel.font = [UIFont boldSystemFontOfSize:18];
    self.succeedToastLabel.textColor = UIColor.whiteColor;
    self.succeedToastLabel.text = @"支付成功";
    [self.succeedToast addSubview:self.succeedToastLabel];
    
    CAShapeLayer *binggo = [CAShapeLayer layer];
    UIBezierPath *binggoPath = [UIBezierPath bezierPath];
    [binggoPath moveToPoint:CGPointMake(63, 33)];
    [binggoPath addLineToPoint:CGPointMake(63 + 15*sin(M_PI/4), 33 + 15*cos(M_PI/4))];
    [binggoPath addLineToPoint:CGPointMake(63 + 15*sin(M_PI/4)+20*sin(M_PI/4), 33 + 15*sin(M_PI/4)-20*sin(M_PI/4))];
    binggo.path = binggoPath.CGPath;
    binggo.lineWidth = 2.0;
    binggo.strokeColor = UIColor.whiteColor.CGColor;
    binggo.fillColor = [UIColor colorWithHexString:@"#3d3d3d"].CGColor;
    [self.succeedToast.layer addSublayer:binggo];
    
    _circle = [[UIView alloc]initWithFrame:CGRectZero];
    _circle.layer.borderColor = UIColor.whiteColor.CGColor;
    _circle.layer.borderWidth = 2.0;
    _circle.layer.cornerRadius = 20;
    [self.succeedToast addSubview:_circle];
    
    self.bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomLine.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.bottomLine];
}

// 添加约束
- (void)createSubViewsConstraints {
    
    [self.orderPaymenttable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
    }];
    
    [self.paymentOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    [self.payCommodityMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBorder.mas_left).mas_offset(10);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).dividedBy(6);
    }];
    
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(1);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(@1);
    }];
    
    [self.commodityMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payCommodityMoney.mas_right).mas_offset(1);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).dividedBy(4);
    }];
    
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    [self.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    [self.succeedToast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(@100);
        make.width.equalTo(@150);
    }];
    [self.succeedToastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.succeedToast);
        make.bottom.equalTo(self.succeedToast.mas_bottom).mas_offset(-20);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
    }];
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.succeedToast);
        make.top.equalTo(self.succeedToast.mas_top).mas_offset(15);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
}

- (void) createCellData {
    NSMutableArray *allCellData = [NSMutableArray array];
    
    NSMutableArray *commodityMessagecell = self.orderMessage[@"commodity"];
    
    NSMutableArray *messageCelldata = [NSMutableArray array];
    UserMessageCellData *userNameCell = [UserMessageCellData new];
    userNameCell.title = @"收货人";
    userNameCell.content = self.orderMessage[@"userName"];
    UserMessageCellData *userAddressCell = [UserMessageCellData new];
    userAddressCell.title = @"联系方式";
    userAddressCell.content = self.orderMessage[@"userTelephone"];
    UserMessageCellData *userConnectionCell = [UserMessageCellData new];
    userConnectionCell.title = @"收货地址";
    userConnectionCell.content = self.orderMessage[@"userAddress"];
    [messageCelldata addObject:userNameCell];
    [messageCelldata addObject:userConnectionCell];
    [messageCelldata addObject:userAddressCell];
    
    UserMessageCellData *payStyle = [UserMessageCellData new];
    payStyle.title = @"余额";
    payStyle.content = [NSString stringWithFormat:@"%@%ld", @"¥", self.remainingSum];
    NSArray *payStyleCell = [NSArray arrayWithObjects:payStyle, nil];
    
    [allCellData addObject:commodityMessagecell];
    [allCellData addObject:messageCelldata];
    [allCellData addObject:payStyleCell];
    
    self.cellData = allCellData;
    
}
//点击支付，如果支付成功，提交到后台
- (void) paymentOrderMessage {
    __weak PaymentOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:self.orderMessage[@"orderNumber"] forKey:@"orderNum"];
    [tempDict setObject:[NSString stringWithFormat:@"%@", self.orderMessage[@"totalPrice"]] forKey:@"payPrice"];
    NSLog(@"%@%@", self.orderMessage[@"orderNumber"], self.orderMessage[@"totalPrice"]);
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        if ([content[@"content"] isEqualToString:@"success"]) {
            weakself.paymentStatus = orderSuccess;
            [weakself paymentOrder];
        } else {
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.toast.alpha = 1.0;
                weakself.toastLabel.text = content[@"content"];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0 animations:^{
                    weakself.toast.alpha = 0.0;
                } completion:^(BOOL finished) {}];
            }];
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/order/payOrder"];
}

//余额
- (void) createRemainingMoney {
    __weak PaymentOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:@"15659285108" forKey:@"telephone"];
    self.remainingMoneyUrlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        NSLog(@"%@", content[@"content"][@"re"]);
        if ([str isEqualToString:@"1"]) {
            if ([content[@"content"][@"re"] isKindOfClass:[NSNull class]]) {
                weakself.remainingSum = 0;
            } else {
                weakself.remainingSum = [content[@"content"][@"re"] integerValue];
                [weakself.orderPaymenttable reloadData];
            }
        }
    };
    [self.remainingMoneyUrlRequest startRequest:tempDict pathUrl:@"/member/getMoneyByTelephone"];
}

#pragma mark - Getters and Setters

@end
