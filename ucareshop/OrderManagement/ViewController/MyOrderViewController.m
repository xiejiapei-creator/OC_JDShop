//
//  MyOrderViewController.m
//  ucareshop
//
//  Created by liushuting on 2019/9/3.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "MyOrderViewController.h"
#import "HomeViewController.h"
#import "PaymentOrderViewController.h"
#import "OrderDetailViewController.h"
#import "CommodityCellData.h"
#import "AllOrderView.h"
#import "StarView.h"
#import "NotPaymentView.h"
#import "NotReciveView.h"
#import "AccomplishView.h"
#import "CancelOrderView.h"
#import "URLRequest.h"
#import "ToastView.h"
#import "AppDelegate.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

typedef NS_ENUM(NSInteger, orderStatus) {
    
    AllOrderViewNumber = 0,
    NotPaymentViewNumber = 1,
    NotReciveViewNumber = 2,
    AccomplishViewNumber = 3,
    CancelOrderViewNumber = 4,
};
@interface MyOrderViewController ()<UIScrollViewDelegate, UITextViewDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UIView *buttonGroup;
@property (nonatomic, strong, readwrite) NSArray <NSString *> *orderStyle;
@property (nonatomic, strong, readwrite) UIScrollView *orderScrollView;
@property (nonatomic, strong, readwrite) AllOrderView *allOrder;
@property (nonatomic, strong, readwrite) NotPaymentView *notPaymentOrder;
@property (nonatomic, strong, readwrite) NotReciveView *notReciveOrder;
@property (nonatomic, strong, readwrite) AccomplishView *accomplishOrder;
@property (nonatomic, strong, readwrite) CancelOrderView *cancelOrder;

@property (nonatomic, strong, readwrite) UIView *commentView;
@property (nonatomic, strong, readwrite) UIView *commentMask;
@property (nonatomic, strong, readwrite) UILabel *tapComment;
@property (nonatomic, strong, readwrite) StarView *star;
@property (nonatomic, assign, readwrite) int tapStarNumber;
@property (nonatomic, strong, readwrite) UITextView *commentContent;
@property (nonatomic, strong, readwrite) UIButton *confirmComment;
@property (nonatomic, strong, readwrite) UIButton *cancelComment;
@property (nonatomic, assign, readwrite) CGFloat starViewHeight;
@property (nonatomic, assign, readwrite) CGFloat starViewWidth;

@property (nonatomic, strong, readwrite) NSString *orderStatus;
@property (nonatomic, strong, readwrite) NSString *orderNumber;
@property (nonatomic, strong, readwrite) NSDictionary *orderMessage;
@property (nonatomic, strong, readwrite) ToastView *toast;
@property (nonatomic, strong, readwrite) ToastView *commentToast;

@property (nonatomic, strong, readwrite) NSString *goodsId;
@property (nonatomic, strong, readwrite) NSString *propertyId;
@property (nonatomic, strong, readwrite) NSString *commentId;

@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *cancelOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *reciveOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *commentOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *commentStatusOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *paymentOrderRequest;
@property (nonatomic, strong, readwrite) URLRequest *deleteOrderRequest;

@end

@implementation MyOrderViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationbar];
    [self createSegmentTitle];
    [self createSubViews];
    [self createSubViewsConstraints];
    [self addGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.allOrder createData];
    [self.notPaymentOrder createData];
    [self.notReciveOrder createData];
    [self.accomplishOrder createData];
    [self.cancelOrder createData];
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

- (void) highlightStatus : (id)sender {
    NSArray <UIButton *> *subviews = self.buttonGroup.subviews;
    subviews[[sender tag]].backgroundColor = [UIColor colorWithHexString:@"#009fff"];
}

- (void) selectStatus : (id)sender {
    CGFloat offsetX = self.view.bounds.size.width * [sender tag];
    NSArray <UIButton *> *subviews = self.buttonGroup.subviews;
    for (UIButton *btn in subviews) {
        [btn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    }
    subviews[[sender tag]].backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [subviews[[sender tag]] setTitleColor:[UIColor colorWithHexString:@"#009fff"] forState:UIControlStateNormal];
    NSInteger orderNumber = offsetX/self.orderScrollView.bounds.size.width;
    [self.orderScrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    [self refreshTable:orderNumber];
}

- (void) showAlert : (NSString *) orderNumber{
    __weak MyOrderViewController *weakself = self;
    if ([self.orderStatus isEqualToString:@"cancelOrder"]) {
        UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确认取消吗？？？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //向后台请求数据，然后重新刷新table
            [weakself createCancelOrder:orderNumber];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [toast addAction:cancelAction];
        [toast addAction:confirmAction];
        //这个block是在alert显示的同时执行的
        [self presentViewController:toast animated:YES completion:^{}];
    } else if ([self.orderStatus isEqualToString:@"confirmOrder"]) {
        UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确定收货吗？？？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //向后台请求数据，然后重新刷新table
            [weakself createReciveOrder:orderNumber];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [toast addAction:cancelAction];
        [toast addAction:confirmAction];
        //这个block是在alert显示的同时执行的
        [self presentViewController:toast animated:YES completion:^{}];
    } else {
        UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除吗？？？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //向后台请求数据，然后重新刷新table
            [weakself createDeleteOrder:orderNumber];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [toast addAction:cancelAction];
        [toast addAction:confirmAction];
        //这个block是在alert显示的同时执行的
        [self presentViewController:toast animated:YES completion:^{}];
    }
}

- (void) addGesture {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(drawStar:)];
    self.star.userInteractionEnabled = YES;
    [self.star addGestureRecognizer:gesture];
}
- (void) drawStar :(UITapGestureRecognizer*)ges {
    CGPoint location = [ges locationInView:self.star];
    self.tapStarNumber = ceil(5*location.x/self.starViewWidth);
    self.star.starWithColorNumber = self.tapStarNumber;
    [_star updateLayout];
}

- (void) confirm {
    //确认评论
    if (self.tapStarNumber == 0) {
        self.commentToast.toastType = @"false";
        self.commentToast.toastLabel.text = @"请选择评分";
        [self.commentToast show:^{}];
    } else if (self.tapStarNumber > 0){
        self.commentView.hidden = YES;
        self.commentMask.hidden = YES;
        [self.commentContent resignFirstResponder];
        self.accomplishOrder.isHidden = NO;
        self.star.starWithColorNumber = 0;
        [self.star updateLayout];
        [self createCommentMessage:self.goodsId :self.propertyId];
    }
}

- (void) cancel {
    //取消评论
    __weak MyOrderViewController *weakself = self;
    self.commentView.hidden = YES;
    self.commentMask.hidden = YES;
    [self.commentContent resignFirstResponder];
    self.accomplishOrder.isHidden = NO;
    [_star updateLayout];
    self.toast.toastType = @"false";
    self.toast.toastLabel.text = @"已取消评论";
    [self.toast show:^{
        weakself.star.starWithColorNumber = 0;
        [weakself.star updateLayout];
    }];
}

- (void) jumpOrderDetail : (NSString *) orderNum{
    OrderDetailViewController *orderDetail = [OrderDetailViewController new];
    orderDetail.orderNumberString = orderNum;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

- (void) jumpUserCenter {
    [self.navigationController popViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
    tab.selectedIndex = 3;
}

- (void) refreshTable : (NSInteger) orderNumber{
    switch (orderNumber) {
        case AllOrderViewNumber: {
            [self.allOrder startRefresh];
            break;
        }
        case NotPaymentViewNumber: {
            [self.notPaymentOrder startRefresh];
            break;
        }
        case NotReciveViewNumber: {
            [self.notReciveOrder startRefresh];
            break;
        }
        case AccomplishViewNumber: {
            [self.accomplishOrder startRefresh];
            break;
        }
        case CancelOrderViewNumber: {
            [self.cancelOrder startRefresh];
            break;
        }
        default: {
            NSLog(@"%ld", orderNumber);
            break;
        }
    }
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIOtherComponentDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    NSArray <UIButton *> *subviews = self.buttonGroup.subviews;
    for (int i = 0; i < subviews.count; i++) {
        if (i == index) {
            subviews[index].backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
            [subviews[index] setTitleColor:[UIColor colorWithHexString:@"#009fff"] forState:UIControlStateNormal];
        } else {
            [subviews[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [self refreshTable:index];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / scrollView.frame.size.width;
    return scrollView.subviews[index];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods
// 配置导航栏
- (void)configureNavigationbar {
    self.title = @"我的订单";
    self.view.backgroundColor = UIColor.whiteColor;
    UIImage *back = [UIImage imageNamed:@"shoppingCart_ConfirmOrderViewController_tabBarLeftButton_enable"];
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStylePlain target:self action:@selector(jumpUserCenter)];
}

// 添加子视图
- (void)createSubViews {
    self.tapStarNumber = 0;
    self.urlRequest = [URLRequest new];
    self.cancelOrderRequest = [URLRequest new];
    self.reciveOrderRequest = [URLRequest new];
    self.paymentOrderRequest = [URLRequest new];
    self.commentOrderRequest = [URLRequest new];
    self.commentStatusOrderRequest = [URLRequest new];
    self.deleteOrderRequest = [URLRequest new];
    __weak MyOrderViewController *weakself = self;
    self.buttonGroup = [[UIView alloc]initWithFrame:CGRectZero];
    CGSize size = self.view.bounds.size;
    for (int i = 0; i < 5; i++) {
        UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(0 + i*size.width/5, 0, size.width/5, 40)];
        itemButton.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        [itemButton setTitle:self.orderStyle[i] forState:UIControlStateNormal];
        itemButton.titleLabel.font = [UIFont systemFontOfSize:16];
        if (i == 0) {
            [itemButton setTitleColor:[UIColor colorWithHexString:@"#009fff"] forState:UIControlStateNormal];
            [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        } else {
            [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }
        
        itemButton.tag = i;
        [itemButton addTarget:self action:@selector(highlightStatus:) forControlEvents:UIControlEventTouchDown];
        [itemButton addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonGroup addSubview:itemButton];
    }
    [self.view addSubview:self.buttonGroup];
    self.orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.orderScrollView.pagingEnabled = YES;
    self.orderScrollView.scrollEnabled = YES;
    self.orderScrollView.showsHorizontalScrollIndicator = YES;
    self.orderScrollView.showsVerticalScrollIndicator = NO;
    self.orderScrollView.minimumZoomScale = 1.0;
    self.orderScrollView.maximumZoomScale = 1.0;
    self.orderScrollView.delegate = self;
    self.orderScrollView.userInteractionEnabled = YES;
    self.orderScrollView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.orderScrollView];
    CGSize viewSize = self.view.bounds.size;
    self.orderScrollView.contentSize = CGSizeMake(viewSize.width*5, 0);
    //添加子视图
    self.allOrder = [[AllOrderView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - 160)];
    self.allOrder.backgroundColor = UIColor.whiteColor;
    //支付
    self.allOrder.orderMessageValue = ^(NSDictionary * _Nonnull orderMessage) {
        PaymentOrderViewController *paymentOrderView = [PaymentOrderViewController new];
        paymentOrderView.orderMessage = orderMessage;
        [weakself.navigationController pushViewController:paymentOrderView animated:YES];
    };
    //取消
    self.allOrder.cancelOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"cancelOrder";
        [weakself showAlert:orderNumber];
    };
    //收货
    self.allOrder.confirmOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"confirmOrder";
        [weakself showAlert:orderNumber];
    };
    //详情
    self.allOrder.jumpAction = ^(NSString * _Nonnull orderNumber) {
        [weakself jumpOrderDetail : orderNumber];
    };
    //删除
    self.allOrder.deleteOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"deleteOrder";
        [weakself showAlert:orderNumber];
    };
    self.allOrder.writeComment = ^(BOOL maskStatus, NSString * _Nonnull commodityId, NSString * _Nonnull propertyId, NSString *_Nonnull commentId) {
        weakself.goodsId = commodityId;
        weakself.propertyId = propertyId;
        weakself.commentId = commentId;
        weakself.commentContent.text = @"";
        weakself.commentView.hidden = NO;
        weakself.commentMask.hidden = NO;
    };
    [self.orderScrollView addSubview:self.allOrder];
    
    self.notPaymentOrder = [[NotPaymentView alloc]initWithFrame:CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height - 160)];
    self.notPaymentOrder.backgroundColor = UIColor.whiteColor;
    self.notPaymentOrder.orderMessageValue = ^(NSDictionary * _Nonnull orderMessage) {
        PaymentOrderViewController *paymentOrderView = [PaymentOrderViewController new];
        paymentOrderView.orderMessage = orderMessage;
        [weakself.navigationController pushViewController:paymentOrderView animated:YES];
    };
    self.notPaymentOrder.cancelOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"cancelOrder";
        [weakself showAlert:orderNumber];
    };
    self.notPaymentOrder.jumpAction = ^(NSString * _Nonnull orderNumber) {
        [weakself jumpOrderDetail : orderNumber];

    };
    [self.orderScrollView addSubview:self.notPaymentOrder];
    
    self.notReciveOrder = [[NotReciveView alloc]initWithFrame:CGRectMake(2*viewSize.width, 0, viewSize.width, viewSize.height - 160)];
    self.notReciveOrder.backgroundColor = UIColor.whiteColor;
    self.notReciveOrder.confirmOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"confirmOrder";
        [weakself showAlert:orderNumber];
    };
    self.notReciveOrder.jumpAction = ^(NSString * _Nonnull orderNumber) {
        [weakself jumpOrderDetail : orderNumber];
    };
    [self.orderScrollView addSubview:self.notReciveOrder];
    
    self.accomplishOrder = [[AccomplishView alloc]initWithFrame:CGRectMake(3*viewSize.width, 0, viewSize.width, viewSize.height - 160)];
    self.accomplishOrder.backgroundColor = UIColor.whiteColor;
    self.accomplishOrder.orderNumber = ^(NSString * _Nonnull orderNumber) {
        weakself.orderNumber = orderNumber;
        [weakself jumpOrderDetail : orderNumber];
    };
    //删除
    self.accomplishOrder.deleteOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"deleteOrder";
        [weakself showAlert:orderNumber];
    };
    self.accomplishOrder.writeComment = ^(BOOL maskStatus, NSString * _Nonnull commodityId, NSString * _Nonnull propertyId, NSString *_Nonnull commentId) {
        weakself.goodsId = commodityId;
        weakself.propertyId = propertyId;
        weakself.commentId = commentId;
        weakself.commentContent.text = @"";
        weakself.commentView.hidden = NO;
        weakself.commentMask.hidden = NO;
    };
    [self.orderScrollView addSubview:self.accomplishOrder];
    
    self.cancelOrder = [[CancelOrderView alloc]initWithFrame:CGRectMake(4*viewSize.width, 0, viewSize.width, viewSize.height - 160)];
    self.cancelOrder.backgroundColor = UIColor.whiteColor;
    self.cancelOrder.jumpAction = ^(NSString * _Nonnull orderNumber) {
        [weakself jumpOrderDetail : orderNumber];
    };
    //删除
    self.cancelOrder.deleteOrder = ^(NSString * _Nonnull orderNumber) {
        weakself.orderStatus = @"deleteOrder";
        [weakself showAlert:orderNumber];
    };
    [self.orderScrollView addSubview:self.cancelOrder];
    
    self.commentMask = [[UIView alloc]initWithFrame:CGRectZero];
    self.commentMask.backgroundColor = UIColor.darkGrayColor;
    self.commentMask.hidden = YES;
    self.commentMask.alpha = 0.7;
    [self.view addSubview:self.commentMask];
    
    //评论模块
    self.commentView = [[UIView alloc]initWithFrame:CGRectZero];
    self.commentView.backgroundColor = UIColor.whiteColor;
    self.commentView.layer.cornerRadius = 10;
    self.commentView.hidden = YES;
    
    self.tapComment = [[UILabel alloc]initWithFrame:CGRectZero];
    self.tapComment.text = @"轻点评分:";
    self.tapComment.textColor = [UIColor colorWithHexString:@"#6f6f6f"];
    self.tapComment.textAlignment = NSTextAlignmentCenter;
    self.tapComment.font = [UIFont systemFontOfSize:18];
    [self.commentView addSubview:self.tapComment];
    
    int starRadius = 10;//外接圆半径
    int defaultNumber = 5;//默认画五个星
    self.star = [[StarView alloc]initWithFrame:CGRectZero];
    self.starViewHeight = starRadius+starRadius*cos(M_PI/10);
    self.starViewWidth = 2*defaultNumber*starRadius*cos(M_PI/10);
    self.star.starColor = [UIColor colorWithHexString:@"#666666"];
    self.star.starWithColorNumber = 0;
    _star.starRadius = starRadius;
    _star.defaultNumber = defaultNumber;
    [_star updateLayout];
    [self.commentView addSubview:_star];
    
    self.commentContent = [[UITextView alloc]initWithFrame:CGRectZero];
    self.commentContent.delegate = self;
    self.commentContent.layer.borderWidth = 1.0;
    self.commentContent.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.commentContent.alpha = 1.0;
    self.commentContent.font = [UIFont systemFontOfSize:16];
    self.commentContent.layer.cornerRadius = 10.0;
    [self.commentView addSubview:self.commentContent];
    
    self.confirmComment = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.confirmComment setTitle:@"取消" forState:UIControlStateNormal];
    [self.confirmComment setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
    [self.confirmComment addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.confirmComment.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
    self.confirmComment.layer.borderWidth = 1.0;
    self.confirmComment.layer.cornerRadius = 5.0;
    [self.commentView addSubview:self.confirmComment];
    
    self.cancelComment = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.cancelComment setTitle:@"确定" forState:UIControlStateNormal];
    [self.cancelComment setTitleColor:[UIColor colorWithHexString:@"#00bc94"] forState:UIControlStateNormal];
    [self.cancelComment addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    self.cancelComment.layer.borderColor = [UIColor colorWithHexString:@"#00bc94"].CGColor;
    self.cancelComment.layer.borderWidth = 1.0;
    self.cancelComment.layer.cornerRadius = 5.0;
    [self.commentView addSubview:self.cancelComment];
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.userInteractionEnabled = NO;
    self.toast.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.toast];
    
    self.commentToast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.commentToast.userInteractionEnabled = NO;
    self.commentToast.backgroundColor = UIColor.clearColor;
    [self.commentView addSubview:self.commentToast];
    
    [self.view addSubview:self.commentMask];
    [self.view addSubview:self.commentView];
    
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.buttonGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.equalTo(@40);
    }];
    [self.orderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonGroup.mas_bottom);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).mas_offset(-30);
        make.width.height.equalTo(@(self.view.bounds.size.width));
    }];
    [self.tapComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentView.mas_top).mas_offset(40);
        make.left.equalTo(self.commentView.mas_left).mas_offset(30);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
    }];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentView.mas_top).mas_offset(50);
        make.right.equalTo(self.commentView.mas_right).mas_offset(-30);
        make.height.equalTo(@(self.starViewHeight));
        make.width.equalTo(@(self.starViewWidth));
    }];
    [self.commentMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.star.mas_bottom).mas_offset(40);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(20);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-20);
        make.height.equalTo(@150);
    }];
    [self.confirmComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentContent.mas_bottom).mas_offset(10);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(20);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    [self.cancelComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentContent.mas_bottom).mas_offset(10);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-20);
        make.width.equalTo(@80);
        make.height.equalTo(@35);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    [self.commentToast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.commentView);
    }];
}

- (void)createSegmentTitle {
    self.orderStyle = @[@"全部", @"待付款", @"待收货", @"已完成", @"已取消"];
}
//取消订单
- (void) createCancelOrder : (NSString *) orderNumber {
    __weak MyOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:orderNumber forKey:@"orderNum"];
    self.cancelOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = @"取消订单成功";
            [weakself.toast show:^{
                //跳转到订单详情
                [weakself.allOrder createData];
                [weakself.notPaymentOrder createData];
                [weakself.cancelOrder createData];
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
    __weak MyOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:orderNumber forKey:@"orderNum"];
    self.reciveOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"content"][@"msg"];
            [weakself.toast show:^{
                [weakself.notReciveOrder createData];
                [weakself.accomplishOrder createData];
                [weakself.allOrder createData];
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

//删除订单
- (void) createDeleteOrder : (NSString *) orderNumber {
    __weak MyOrderViewController *weakself = self;
       NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
       [tempDict setValue:[NSString stringWithFormat:@"%@", orderNumber] forKey:@"orderNum"];
       self.deleteOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
           NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
           if ([str isEqualToString:@"1"]) {
               weakself.toast.toastType = @"false";
               weakself.toast.toastLabel.text = content[@"content"][@"msg"];
               [weakself.toast show:^{
                   [weakself.cancelOrder createData];
                   [weakself.accomplishOrder createData];
                   [weakself.allOrder createData];
               }];
           } else {
               weakself.toast.toastType = @"false";
               weakself.toast.toastLabel.text = content[@"msg"];
               [weakself.toast show:^{
               }];
           }
       };
       [self.deleteOrderRequest startRequest:tempDict pathUrl:@"/order/deleteOrder"];
}

- (void) createCommentMessage : (NSString *) goodsId : (NSString *) propertyId {
    __weak MyOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[NSString stringWithFormat:@"%@", weakself.commentContent.text] forKey:@"content"];
    [tempDict setValue:@([goodsId integerValue]) forKey:@"goodsId"];
    [tempDict setObject:@(weakself.tapStarNumber) forKey:@"goodsScore"];
    [tempDict setObject:[NSString stringWithFormat:@"%@", self.propertyId] forKey:@"goodsPropertyId"];
    self.commentOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            [weakself changeCommentStatus];
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = @"评论失败，请稍后再试";
            [weakself.toast show:^{}];
        }
    };
    [self.commentOrderRequest startRequest:tempDict pathUrl:@"/saveComment"];
}

- (void) changeCommentStatus {
    __weak MyOrderViewController *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[NSString stringWithFormat:@"%@", weakself.commentId] forKey:@"id"];
    self.commentStatusOrderRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSString *str = [NSString stringWithFormat:@"%@", content[@"code"]];
        if ([str isEqualToString:@"1"]) {
            if([content[@"content"][@"msg"] isEqualToString:@"修改评论状态成功"]) {
                weakself.toast.toastType = @"success";
                weakself.toast.succeedToastLabel.text = @"评论成功";
                [weakself.toast show:^{
                    weakself.star.starWithColorNumber = 0;
                    weakself.tapStarNumber = 0;
                    [weakself.star updateLayout];
                    [weakself.allOrder createData];
                    [weakself.accomplishOrder createData];
                }];
            }
        }
    };
    [self.commentStatusOrderRequest startRequest:tempDict pathUrl:@"/order/updComStatus"];
}

#pragma mark - Getters and Setters

@end
