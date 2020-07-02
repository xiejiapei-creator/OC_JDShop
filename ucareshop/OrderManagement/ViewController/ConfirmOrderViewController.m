//
//  ConfirmOrderViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/8/24.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "ConfirmOrderViewController.h"
#import "PaymentOrderViewController.h"
#import "CommodityOrderTableViewCell.h"
#import "PaymentOrderViewController.h"
#import "CommodityDetailViewController.h"
#import "CommodityCellData.h"
#import "CommodityMessageModel.h"
#import "AddressManagementTableViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import <UIImageView+WebCache.h>
#import "URLRequest.h"
#import "Masonry.h"
#import "CartNum.h"
#import "ToastView.h"

#pragma mark - @class

#pragma mark - 常量

static NSString *cellIndifier = @"commodityMessage";

#pragma mark - 枚举

typedef NS_ENUM(NSInteger, orderStatus) {
    unfindCommodity = -1,
    notEnoughStock = 0,
    orderSuccess = 1,
    netError = 2,
};

@interface ConfirmOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UITableView *commodityMessageTable;
@property (nonatomic, strong, readwrite) UIView *addressView;
@property (nonatomic, strong, readwrite) UIButton *addressModifyButton;
@property (nonatomic, strong, readwrite) UIButton *commitOrderButton;
@property (nonatomic, strong, readwrite) UILabel *payCommodityMoney;
@property (nonatomic, strong, readwrite) UILabel *commodityMoney;
@property (nonatomic, strong, readwrite) UIView *commentMask;
@property (nonatomic, strong, readwrite) UITextField *remark;
@property (nonatomic, strong, readwrite) UIView *bottomView;
@property (nonatomic, strong, readwrite) UILabel *shouldPayment;
@property (nonatomic, strong, readwrite) UILabel *paymentMoney;
@property (nonatomic, strong, readwrite) UIView *leftBorder;
@property (nonatomic, strong, readwrite) UILabel *userName;
@property (nonatomic, strong, readwrite) UILabel *telNumber;
@property (nonatomic, strong, readwrite) UILabel *userAddress;
@property (nonatomic, strong, readwrite) UILabel *statusTag;
@property (nonatomic, assign, readwrite) CGFloat height;
@property (nonatomic, strong, readwrite) UIView *toast;
@property (nonatomic, strong, readwrite) UILabel *toastLabel;
@property (nonatomic, assign, readwrite) int orderStatus;
@property (nonatomic, strong, readwrite) NSString *orderNumber;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *commitRequest;
@property (nonatomic, strong, readwrite) ToastView *orderToast;
@property (nonatomic, assign, readwrite) BOOL addressStatus;

@end

@implementation ConfirmOrderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSubViews];
    [self createSubViewsConstraints];
    [self createAddressMessage];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createAddressMessage];
    self.commentMask.hidden = YES;
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

//根据商品状态，跳转到不同的地方
- (void) jumpPaymentOrderView {
    __weak ConfirmOrderViewController *weakself = self;
    if ([self.userAddress.text isEqualToString:@"请选择地址"] || [self.userAddress.text isEqualToString:@""]) {
        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakself.toast.alpha = 1.0;
            weakself.toastLabel.text = @"请选择地址";
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                weakself.toast.alpha = 0.0;
            }];
        }];
    } else {
        if (self.orderStatus == unfindCommodity) {
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.toast.alpha = 1.0;
                weakself.toastLabel.text = @"商品已下架";
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 animations:^{
                    weakself.toast.alpha = 0.0;
                }];
            }];
        } else if (self.orderStatus == notEnoughStock){
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.toast.alpha = 1.0;
                weakself.toastLabel.text = @"库存不足";
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 animations:^{
                    weakself.toast.alpha = 0.0;
                }];
            }];
        } else if (self.orderStatus == orderSuccess) {
            PaymentOrderViewController *paymentOrderView = [PaymentOrderViewController new];
            //将订单编号传送到下一页
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.orderMessage];
            if (self.orderNumber == nil) {
                self.orderToast.toastType = @"false";
                self.orderToast.toastLabel.text = @"商品已下架或者订单错误";
                [self.orderToast show:^{}];
            } else {
                [dict setObject:self.orderNumber forKey:@"orderNumber"];
                [dict setObject:self.userName.text forKey:@"userName"];
                [dict setObject:self.userAddress.text forKey:@"userAddress"];
                [dict setObject:self.telNumber.text forKey:@"userTelephone"];
                self.orderMessage = dict;
                UINavigationController *obj = self.navigationController;
                paymentOrderView.orderMessage = self.orderMessage;
                paymentOrderView.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController popViewControllerAnimated:NO];
                [obj pushViewController:paymentOrderView animated:YES];
            }
        } else if (self.orderStatus == netError) {
            [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                weakself.toast.alpha = 1.0;
                weakself.toastLabel.text = @"网络错误";
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 animations:^{
                    weakself.toast.alpha = 0.0;
                }];
            }];
        }
    }
}

- (void) jumpAddressManagementView {
    AddressManagementTableViewController *addressManagementView = [AddressManagementTableViewController new];
    [self.navigationController pushViewController:addressManagementView animated:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
}

- (void) keyboardWillShow: (NSNotification *)aNotification {
    [self.view bringSubviewToFront:self.commentMask];
    [self.view bringSubviewToFront:self.remark];
    NSDictionary* info = [aNotification userInfo];
    //获取结束时的Frame值
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //获取动画时间
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.commentMask.hidden = NO;
    [self.remark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-(kbSize.height));
        make.height.equalTo(@44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    NSLog(@"%@", self.remark);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [self.remark mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
    //当键盘消失的时候向后台发送数据,然后重新刷新table
    NSLog(@"%@", self.remark.text);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //取消焦点
    [self.remark resignFirstResponder];
    self.commentMask.hidden = YES;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.remark){
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 15) {
            return NO;//限制长度
        }
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 15) {
            return NO;//限制长度
        }
        return YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderMessage[@"commodityNumber"] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndifier forIndexPath:indexPath];
    CommodityCellData *data = [self.orderMessage objectForKey:@"commodity"][indexPath.row];
    cell.commodityName.text = data.commodityName;
    cell.commodityId = data.commodityId;
    cell.commodityNumber.text = [NSString stringWithFormat:@"%d", data.commodityNumber];
    NSArray *arr = [data.commodityImageName componentsSeparatedByString:@";"];
    [cell.commodityImage sd_setImageWithURL:arr[0]];
    cell.price.text = [NSString stringWithFormat:@"%@%d",@"¥", data.commodityPrice];
    cell.priceTitle.text = data.commodityType;
    cell.primePrice.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%d",@"¥", data.primePrice] attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellConstrain];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"商品信息";
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    view.tintColor = UIColor.whiteColor;
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    header.textLabel.font = [UIFont systemFontOfSize:16];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityDetailViewController *commodityDetial = [CommodityDetailViewController new];
    CommodityCellData *data = [self.orderMessage objectForKey:@"commodity"][indexPath.row];
    commodityDetial.commodityID = data.commodityId;
    [self.navigationController pushViewController:commodityDetial animated:YES];
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"确认订单";
    self.view.backgroundColor = UIColor.whiteColor;
}

// 添加子视图
- (void)createSubViews {
    
    self.addressStatus = YES;
    self.urlRequest = [URLRequest new];
    self.commitRequest = [URLRequest new];
    self.commentMask = [[UIView alloc]initWithFrame:CGRectZero];
    self.commentMask.backgroundColor = UIColor.darkGrayColor;
    self.commentMask.hidden = YES;
    self.commentMask.alpha = 0.5;
    [self.view addSubview:self.commentMask];
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#ffecf4" withAlpha:1];
    leftView.font = [UIFont systemFontOfSize:14];
    leftView.textAlignment = NSTextAlignmentLeft;
    leftView.text = @"备注:";
    
    self.remark = [[UITextField alloc]initWithFrame:CGRectZero];
    self.remark.textAlignment = NSTextAlignmentLeft;
    self.remark.font = [UIFont systemFontOfSize:14];
    self.remark.placeholder = @"15字以内";
    self.remark.backgroundColor = UIColor.whiteColor;
    self.remark.delegate = self;
    self.remark.leftView = leftView;
    self.remark.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.remark];
    
    self.addressView = [[UIView alloc]initWithFrame:CGRectZero];
    self.addressView.backgroundColor = [UIColor colorWithHexString:@"#ffecf4" withAlpha:1];
    [self.view addSubview:self.addressView];
    
    self.userAddress = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userAddress.numberOfLines = 0;
    self.userAddress.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.userAddress];
    //需要先把控件加入，然后计算高度
    self.height = [self calculateHeightOfText:self.userAddress].height;
    self.addressModifyButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.addressModifyButton setImage:[UIImage imageNamed:@"shoppingCart_ConfirmOrderViewController_addressModifyButton_enable"] forState:UIControlStateNormal];
    [self.addressModifyButton addTarget:self action:@selector(jumpAddressManagementView) forControlEvents:UIControlEventTouchUpInside];
    [self.addressView addSubview:self.addressModifyButton];
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.userName.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.userName];
    
    self.telNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.telNumber.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.telNumber];
    
    self.statusTag = [[UILabel alloc]initWithFrame:CGRectZero];
    self.statusTag.textColor = UIColor.flatYellowColorDark;
    self.statusTag.text = @"默认";
    self.statusTag.hidden = YES;
    self.statusTag.textAlignment = NSTextAlignmentCenter;
    self.statusTag.layer.borderColor = UIColor.flatYellowColorDark.CGColor;
    self.statusTag.layer.borderWidth = 1.0;
    self.statusTag.layer.cornerRadius = 5.0;
    self.statusTag.layer.masksToBounds = YES;
    self.statusTag.font = [UIFont systemFontOfSize:15];
    [self.addressView addSubview:self.statusTag];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    [self.view addSubview:self.bottomView];
    
    self.shouldPayment = [[UILabel alloc]initWithFrame:CGRectZero];
    self.shouldPayment.text = @"应付金额：";
    self.shouldPayment.font = [UIFont systemFontOfSize:14];
    self.shouldPayment.adjustsFontSizeToFitWidth = YES;
    self.shouldPayment.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.shouldPayment];
    
    self.paymentMoney = [[UILabel alloc]initWithFrame:CGRectZero];
    self.paymentMoney.text = [NSString stringWithFormat:@"%@%@", @"¥", self.orderMessage[@"totalPrice"]];
    self.paymentMoney.textColor = UIColor.redColor;
    self.paymentMoney.font = [UIFont systemFontOfSize:14];
    [self.bottomView addSubview:self.paymentMoney];
    
    self.leftBorder = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftBorder.backgroundColor = UIColor.clearColor;
    [self.bottomView addSubview:self.leftBorder];
    
    self.commitOrderButton = [[UIButton alloc]initWithFrame:CGRectZero];
    self.commitOrderButton.backgroundColor = UIColor.flatMintColor;
    [self.commitOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    self.commitOrderButton.backgroundColor = UIColor.flatMintColor;
    self.commitOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.commitOrderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.commitOrderButton addTarget:self action:@selector(commitOrderMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.commitOrderButton];
    
    self.commodityMessageTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.commodityMessageTable.delegate = self;
    self.commodityMessageTable.dataSource = self;
    [self.commodityMessageTable registerClass:[CommodityOrderTableViewCell class] forCellReuseIdentifier:cellIndifier];
    self.commodityMessageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commodityMessageTable.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.commodityMessageTable.layer.borderWidth = 1.0;
    [self.view addSubview:self.commodityMessageTable];
    
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
    
    self.orderToast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.orderToast.backgroundColor = UIColor.clearColor;
    self.orderToast.userInteractionEnabled = NO;
    [self.view addSubview:self.orderToast];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.orderToast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(1);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(1);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-2);
    }];
    
    [self.commodityMessageTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).mas_offset(15);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.remark.mas_top);
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
    
    [self.addressModifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressView);
        make.right.equalTo(self.addressView).mas_offset(-3);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right).mas_offset(-1);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
    }];
    
    [self.leftBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).mas_offset(1);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(@1);
    }];
    
    [self.shouldPayment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBorder.mas_left);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).dividedBy(6);
    }];
    
    [self.paymentMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shouldPayment.mas_right).mas_offset(1);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(self.bottomView);
        make.width.equalTo(self.bottomView).dividedBy(4);
    }];
    
    [self.commitOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
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
    
    [self.commentMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    [self.remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
}

- (CGSize) calculateHeightOfText : (UILabel *) textLabel {
    NSString *content = textLabel.text;
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    return size;
}

- (void) updateAddressConstrains {
    self.height = [self calculateHeightOfText:self.userAddress].height;
    
    CGFloat addressViewHeight = self.height +60;
    NSLog(@"addressViewHeight%f", addressViewHeight);
    [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(1);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(1);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-1);
        make.height.equalTo(@(addressViewHeight));
    }];
    [self.userAddress mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).mas_offset(10);
        make.left.equalTo(self.addressView.mas_left).mas_offset(20);
        make.width.equalTo(self.addressView);
        make.height.equalTo(@(self.height));
    }];
    CAShapeLayer *addressViewBorder = [CAShapeLayer layer];
    CGSize size = self.view.frame.size;
    addressViewBorder.frame = CGRectMake(0, 0, size.width, self.height + 60);
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width-2, self.height + 60)];
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

- (void) createAddressMessage {
    __weak ConfirmOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if ([content[@"content"][@"re"] isKindOfClass:[NSNull class]]) {
                weakself.addressStatus = NO;
                weakself.userName.text = @"";
                weakself.telNumber.text = @"";
                weakself.userAddress.text = @"请选择地址";
                [weakself.commodityMessageTable reloadData];
            } else {
                weakself.telNumber.text = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"telephone"]];
                weakself.userName.text = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"receiver"]];
                weakself.userAddress.text = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"completeAddress"]];
                NSString *str = [NSString stringWithFormat:@"%@", content[@"content"][@"re"][@"isDefault"]];
                if ([str isEqualToString:@"2"]) {
                    weakself.statusTag.hidden = YES;
                } else {
                    weakself.statusTag.hidden = NO;
                }
                [weakself.commodityMessageTable reloadData];
                [weakself updateAddressConstrains];
            }
        }
    };
    [self.urlRequest startRequest:tempDict pathUrl:@"/address/getDefaultAddress"];
}
- (void) commitOrderMessage {
    __weak ConfirmOrderViewController *weakself = self;
    NSMutableArray *commodityList = [NSMutableArray array];
    for (CommodityCellData *data in self.orderMessage[@"commodity"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:data.commodityName forKey:@"gdsName"];
        if (data.commodityId == nil) {
            [dict setObject:weakself.commodityID forKey:@"goodsId"];
        } else {
            [dict setObject:data.commodityId forKey:@"goodsId"];
        }
        [dict setObject:[NSString stringWithFormat:@"%d", data.commodityPrice] forKey:@"discountPrice"];
        [dict setObject:[NSString stringWithFormat:@"%d", data.commodityPrice] forKey:@"payPrice"];
        [dict setObject:[NSString stringWithFormat:@"%d", data.commodityNumber] forKey:@"goodsNum"];
        [dict setObject:data.commodityType forKey:@"property"];
        [dict setObject:data.propertyId forKey:@"goodsPropertyId"];
        [dict setObject:data.commodityImageName forKey:@"picUrl"];
        [dict setObject:[NSString stringWithFormat:@"%d", data.primePrice] forKey:@"salePrice"];
        [commodityList addObject:dict];
    }
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:weakself.userName.text forKey:@"receiptName"];
    [tempDict setValue:weakself.telNumber.text forKey:@"receiptTel"];
    [tempDict setValue:weakself.userAddress.text forKey:@"receiptAddress"];
    [tempDict setValue:self.orderMessage[@"primeTotalPrice"] forKey:@"orderPrice"];//总价
    [tempDict setValue:self.orderMessage[@"totalPrice"] forKey:@"payPrice"];//付款总额
    if (self.orderMessage[@"cartGoodsList"] == NULL) {
        [tempDict setObject:@[] forKey:@"cartGoodsList"];
    } else {
        [tempDict setObject:self.orderMessage[@"cartGoodsList"] forKey:@"cartGoodsList"];
    }
    [tempDict setValue:self.remark.text forKey:@"remark"];
    [tempDict setValue:commodityList forKey:@"orderGoodsList"];//商品列表
    self.commitRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if ([content[@"content"][@"msg"] isEqualToString:@"订单提交成功"]) {
                weakself.orderStatus = orderSuccess;
                weakself.orderNumber = [content[@"content"] objectForKey:@"orderNum"];
                [weakself jumpPaymentOrderView];
                [CartNum getCartNum];
            } else if ([content[@"content"][@"msg"] isEqualToString:@"商品不足"]){
                weakself.orderStatus = notEnoughStock;
                [weakself jumpPaymentOrderView];
                [CartNum getCartNum];
            } else if ([content[@"content"][@"msg"] isEqualToString:@"商品已下架"]) {
                weakself.orderStatus = unfindCommodity;
                [weakself jumpPaymentOrderView];
                [CartNum getCartNum];
            }
        } else {
            weakself.orderStatus = netError;
            [weakself jumpPaymentOrderView];
        }
        NSLog(@"%@", weakself.orderMessage);
        [weakself.commodityMessageTable reloadData];
    };
    [self.commitRequest startRequest:tempDict pathUrl:@"/order/submitOrder"];
}

#pragma mark - Getters and Setters

@end
