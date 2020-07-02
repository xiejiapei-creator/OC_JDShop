//
//  CommodityPayTableViewCell.m
//  ucareshop
//
//  Created by liushuting on 2019/8/21.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommodityPayTableViewCell.h"
#import "CommodityCellData.h"
#import "ToastView.h"
#import "URLRequest.h"
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommodityPayTableViewCell ()<UITextFieldDelegate>

#pragma mark - 私有属性
    
@property (nonatomic, strong, readwrite) UIImageView *commodityImage;
@property (nonatomic, strong, readwrite) UILabel *commodityName;
@property (nonatomic, strong, readwrite) UILabel *priceTitle;
@property (nonatomic, strong, readwrite) UILabel *price;
@property (nonatomic, strong, readwrite) UILabel *primePrice;
@property (nonatomic, strong, readwrite) UITextField *commodityNumber;
@property (nonatomic, strong, readwrite) UIButton *increaseNumbers;
@property (nonatomic, strong, readwrite) UIButton *reduceNumbers;
@property (nonatomic, strong, readwrite) UIButton *deleteCommodity;
@property (nonatomic, strong, readwrite) UIView *cellContentView;
@property (nonatomic, strong, readwrite) UIView *line;
@property (nonatomic, assign, readwrite) int totalPrice;
@property (nonatomic, strong, readwrite) URLRequest *urlRequest;
@property (nonatomic, strong, readwrite) URLRequest *reduceRequest;
@property (nonatomic, strong, readwrite) ToastView *toast;
@property (nonatomic, strong, readwrite) NSString *actionType;
@property (nonatomic, strong, readwrite) NSString *textContent;

@end

@implementation CommodityPayTableViewCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self createSubViewsConstraints];
        [self registerForKeyboardNotifications];
        [self updateCommodityname];
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

- (void)reduce {
    self.reduceNumbers.enabled = NO;
    self.increaseNumbers.enabled = NO;
    _actionType = @"reduce";
    int temp = [self.commodityNumber.text intValue];
    [self changeCommodityNumber:[self.cartGoodsId intValue] :[NSString stringWithFormat:@"%d", temp - 1] :self.propertyId];
}

- (void)increase {
//    点击按钮后f更新布局
    self.increaseNumbers.enabled = NO;
    self.reduceNumbers.enabled = NO;
    _actionType = @"increase";
    int temp = [self.commodityNumber.text intValue];
    [self changeCommodityNumber:[self.cartGoodsId intValue] :[NSString stringWithFormat:@"%d", temp + 1] :self.propertyId];
}

- (void)deleteCell {
    self.commodityIndex([self.cartGoodsId integerValue], self.index);
    [self changeCommodityNumber:[self.cartGoodsId intValue] :@"1" :self.propertyId];
}

- (void)updateCellConstrain {
    [self updateCommodityname];
}

- (void) commodityNumberEdit {
    [self setNeedsUpdateConstraints];
}

//注册通知
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    
}

- (void) keyboardWillShow: (NSNotification *)aNotification {
    self.textContent = self.commodityNumber.text;
    NSLog(@"%@", self.textContent);
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
}

#pragma mark - UIOtherComponentDelegate

#pragma mark - UITextFieldDelegate

//当textField不是第一响应者时调用这个方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //取消焦点
    [self.commodityNumber resignFirstResponder];
    self.actionType = @"text";
    [self changeCommodityNumber:[self.cartGoodsId intValue] :self.commodityNumber.text :self.propertyId];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.commodityNumber){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) {
                return NO;// 48 unichar for 0
            } else if (character == 48 && [self.commodityNumber.text intValue] == 0) {
                return NO;
            }
            if (character > 57) {
                return NO;
            } // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 6) {
            return NO;//限制长度
        }
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 6) {
            return NO;//限制长度
        }
        return YES;
    }
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

// 添加子视图
- (void)createSubViews {
    
    self.cellContentView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.cellContentView];
    
    //commodity图片
    self.commodityImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.commodityImage.contentMode = UIViewContentModeScaleToFill;
    self.commodityImage.image = [UIImage imageNamed:@"shoppingCart_shoppingCartViewController_commodityImage_enable"];
    self.commodityImage.layer.borderColor = UIColor.lightGrayColor.CGColor;
    self.commodityImage.layer.borderWidth = 2.0;
    [self.cellContentView addSubview:self.commodityImage];
    //commodity名字
    self.commodityName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityName.textColor = UIColor.blackColor;
    self.commodityName.textAlignment = NSTextAlignmentCenter;
    self.commodityName.adjustsFontSizeToFitWidth = YES;
    [self.cellContentView addSubview:self.commodityName];
    //commodityPrice-title
    self.priceTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.priceTitle.text = @"规格/样式";
    self.priceTitle.textColor = UIColor.blackColor;
    self.priceTitle.textAlignment = NSTextAlignmentLeft;
    self.priceTitle.font = [UIFont systemFontOfSize:16];
    [self.cellContentView addSubview:self.priceTitle];
    //commodityPrice
    self.price = [[UILabel alloc]initWithFrame:CGRectZero];
    self.price.textColor = UIColor.redColor;
    self.price.font = [UIFont systemFontOfSize:16];
    self.price.textAlignment = NSTextAlignmentCenter;
    self.price.adjustsFontSizeToFitWidth = YES;
    [self.cellContentView addSubview:self.price];
    //comodityPrimePrice
    self.primePrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.primePrice.textColor = UIColor.lightGrayColor;
    self.primePrice.textAlignment = NSTextAlignmentCenter;
    self.primePrice.adjustsFontSizeToFitWidth = YES;
    
    self.primePrice.attributedText = [[NSAttributedString alloc] initWithString:@"10000" attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle), NSStrikethroughColorAttributeName: [UIColor redColor]}];
    
    self.primePrice.font = [UIFont systemFontOfSize:14];
    [self.cellContentView addSubview:self.primePrice];
    //commodityNumber
    self.commodityNumber = [[UITextField alloc]initWithFrame:CGRectZero];
    self.commodityNumber.textColor = UIColor.lightGrayColor;
    self.commodityNumber.textAlignment = NSTextAlignmentCenter;
    self.commodityNumber.delegate = self;
    [self.commodityNumber addTarget:self action:@selector(commodityNumberEdit) forControlEvents:UIControlEventEditingChanged];
    [self.cellContentView addSubview:self.commodityNumber];
    //increaseNumbers
    self.increaseNumbers = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.increaseNumbers setImage:[UIImage imageNamed:@"shoppingCart_shoppingCartViewController_increaseNumber_enable"] forState:UIControlStateNormal];
    [self.increaseNumbers addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
    [self.cellContentView addSubview:self.increaseNumbers];
    //reduceNumbers
    self.reduceNumbers = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.reduceNumbers setImage:[UIImage imageNamed:@"shoppingCart_shoppingCartViewController_reduceNumber_enable"] forState:UIControlStateNormal];
    [self.reduceNumbers addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self.cellContentView addSubview:self.reduceNumbers];
    //deleteCommodity
    self.deleteCommodity = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.deleteCommodity addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteCommodity setImage:[UIImage imageNamed:@"shoppingCart_shoppingCartViewController_deleteCommodity_enable"] forState:UIControlStateNormal];
    [self.cellContentView addSubview:self.deleteCommodity];
    
    self.toast = [[ToastView alloc]initWithFrame:CGRectZero];
    self.toast.backgroundColor = UIColor.clearColor;
    self.toast.userInteractionEnabled = NO;
    [self addSubview:self.toast];
    
    self.urlRequest = [URLRequest new];
}

// 添加约束
- (void)createSubViewsConstraints {
    [self.cellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.contentView.mas_safeAreaLayoutGuideBottom).mas_offset(-20);
        make.left.equalTo(self.contentView.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.contentView.mas_safeAreaLayoutGuideRight);
    }];
    [self.commodityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(15);
        make.left.equalTo(self.cellContentView.mas_left).mas_offset(10);
        make.height.equalTo(@90);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-8);
    }];
    [self.commodityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(15);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    [self.primePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitle.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.primePrice.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@20);
    }];
    [self.deleteCommodity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(5);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.right.equalTo(self.cellContentView).mas_offset(-5);
    }];
    [self.increaseNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-5);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.right.equalTo(self.cellContentView).mas_offset(-35);
    }];
    [self.commodityNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.increaseNumbers.mas_left).mas_offset(-5);
        make.width.equalTo(@10);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-10);
    }];
    [self.reduceNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commodityNumber.mas_left).mas_offset(-5);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-5);
    }];
    [self.toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void)updateConstraints {
    
    //自动计算文字宽度，然后更新布局
    CGFloat numberWidth = [self.commodityNumber sizeThatFits:CGSizeZero].width;
    if (numberWidth >= 80) {
        numberWidth = 80;
    }
    
    [self.commodityNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.increaseNumbers.mas_left).mas_offset(-5);
        make.width.equalTo(@(numberWidth));
        make.height.equalTo(@30);
        make.bottom.equalTo(self.cellContentView.mas_bottom).mas_offset(-10);
    }];
    [super updateConstraints];
}

- (void) updateCommodityname {
    CGFloat nameWidth = [self.commodityName sizeThatFits:CGSizeZero].width;
    [self.commodityName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellContentView.mas_top).mas_offset(15);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(nameWidth));
        make.height.equalTo(@20);
    }];
    
    CGFloat commodityPrice = [self.price sizeThatFits:CGSizeZero].width;
    [self.price mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitle.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(commodityPrice));
        make.height.equalTo(@20);
    }];
    CGFloat primePrice = [self.primePrice sizeThatFits:CGSizeZero].width;
    [self.primePrice mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.price.mas_bottom);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@(primePrice));
        make.height.equalTo(@20);
    }];
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityName.mas_bottom).mas_offset(5);
        make.left.equalTo(self.commodityImage.mas_right).mas_offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
    }];
}

- (void) changeCommodityNumber : (NSInteger) cartGoodsId : (NSString *) commodityNumber : (NSString *) propertyId{
    __weak CommodityPayTableViewCell *weakself = self;
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setValue:[NSString stringWithFormat:@"%ld", cartGoodsId] forKey:@"cartGoodsId"];
    [tempDict setObject:[NSString stringWithFormat:@"%@", commodityNumber] forKey:@"goodsNum"];
    [tempDict setObject:[NSString stringWithFormat:@"%@", propertyId] forKey:@"goodsPropertyId"];
    self.urlRequest.transDataBlock = ^(NSDictionary * _Nonnull content) {
        if([content[@"content"] isEqualToString:@"success"]) {
            if ([weakself.actionType isEqualToString:@"increase"]) {
                int temp = self.commodityNumber.text.intValue + 1;
                weakself.totalPrice = temp * [weakself.price.text intValue];
                weakself.commodityNumber.text = [NSString stringWithFormat:@"%d", temp];
                weakself.commodityNumberValue(weakself.commodityNumber.text);
                [weakself setNeedsUpdateConstraints];
            } else if ([weakself.actionType isEqualToString:@"reduce"]) {
                int temp = weakself.commodityNumber.text.intValue - 1;
                weakself.totalPrice = temp * [weakself.price.text intValue];
                weakself.commodityNumber.text = [NSString stringWithFormat:@"%d", temp];
                weakself.commodityNumberValue(weakself.commodityNumber.text);
                [weakself setNeedsUpdateConstraints];
            } else if ([weakself.actionType isEqualToString:@"text"]) {
                int temp = weakself.commodityNumber.text.intValue;
                weakself.totalPrice = temp * [weakself.price.text intValue];
                weakself.commodityNumber.text = [NSString stringWithFormat:@"%d", temp];
                weakself.commodityNumberValue(weakself.commodityNumber.text);
                [weakself updateCommodityname];
            }
            //防止连点
            weakself.increaseNumbers.enabled = YES;
            weakself.reduceNumbers.enabled = YES;
        } else {
            weakself.toast.toastType = @"false";
            weakself.toast.toastLabel.text = content[@"content"];
            [weakself.toast show:^{
                if ([weakself.actionType isEqualToString:@"text"]) {
                    weakself.commodityNumber.text = weakself.textContent;
                    [weakself updateCommodityname];
                }
            }];
        }
};
    [self.urlRequest startRequest:tempDict pathUrl:@"/order/updateGoodsNum"];
}

#pragma mark - Getters and Setters

@end
