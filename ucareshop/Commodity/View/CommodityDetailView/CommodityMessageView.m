//
//  CommodityMessageView.m
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "CommodityMessageView.h"
#import <ChameleonFramework/Chameleon.h>
#import "Masonry.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

@interface CommodityMessageView ()<UITextFieldDelegate>

#pragma mark - 私有属性

@property (nonatomic, strong, readwrite) UILabel *commodityIntroduce;

@property (nonatomic, strong, readwrite) UIView *separator;
@property (nonatomic, strong, readwrite) UILabel *discountPriceTitle;
@property (nonatomic, strong, readwrite) UILabel *discountPrice;
@property (nonatomic, strong, readwrite) UILabel *commodityStyle;
@property (nonatomic, strong, readwrite) UIView *radioGroup;
@property (nonatomic, strong, readwrite) NSMutableArray *selected;
@property (nonatomic, strong, readwrite) UILabel *stockNumberTitle;
@property (nonatomic, strong, readwrite) UILabel *stockNumber;
@property (nonatomic, strong, readwrite) UILabel *saleVolumeTitle;
@property (nonatomic, strong, readwrite) UILabel *saleVolume;
@property (nonatomic, strong, readwrite) UIButton *increaseNumbers;
@property (nonatomic, strong, readwrite) UILabel *commodityNumber;
@property (nonatomic, strong, readwrite) UIButton *reduceNumbers;
@property (nonatomic, strong, readwrite) UIButton *addShoppingCart;
@property (nonatomic, strong, readwrite) UITextField *writeCommodityNumber;

@end

@implementation CommodityMessageView


#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setRadioValue];
        [self createSubViews];
        [self createSubViewsConstraints];
        [self registerForKeyboardNotifications];
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

- (void) changeStatus : (id)sender {
    self.selected[[sender tag]] = @(NO);
    NSArray <UIView *> *subViews = self.radioGroup.subviews;
    for (UIView *radio in subViews) {
        if ([radio isMemberOfClass:UIButton.class]){
            radio.backgroundColor = UIColor.clearColor;
        }
    }
    NSInteger index = [sender tag] *2 + 1;
    if ([sender tag] == 0) {
        index = 0;
        subViews[1].backgroundColor = [UIColor colorWithHexString:@"#189bd5"];
    } else {
        subViews[index].backgroundColor = [UIColor colorWithHexString:@"#189bd5"];
    }
    self.radioIndex = [sender tag];
    //下标
    self.typeNumber([sender tag]);
    
}

- (void)reduce {
    int temp = self.commodityNumber.text.intValue - 1;
    if(temp <= 0) {
        temp = 1;
    }
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,temp * self.priceNumber];
    self.commodityNumber.text = [NSString stringWithFormat:@"%d", temp];
    self.totalPriceNumber(temp * self.priceNumber);
    self.confirmOrderCommodityNumber(temp);
    [self setNeedsUpdateConstraints];
}

- (void)increase {
    //    点击按钮后f更新布局
    int temp = self.commodityNumber.text.intValue + 1;
    if (temp < [self.stockNumber.text intValue]) {
        self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,temp * self.priceNumber];
        self.commodityNumber.text = [NSString stringWithFormat:@"%d", temp];
    } else {
        temp = temp - 1;
        self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,[self.stockNumber.text intValue] * self.priceNumber];
        self.commodityNumber.text = [NSString stringWithFormat:@"%d", [self.stockNumber.text intValue]];
    }
    self.totalPriceNumber(temp * self.priceNumber);
    self.confirmOrderCommodityNumber(temp);
    [self setNeedsUpdateConstraints];
}

- (void) commodityNumberEdit {
    [self setNeedsUpdateConstraints];
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,self.commodityNumber.text.intValue * self.priceNumber];
}
//键盘出现和隐藏

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void) keyboardWillShow: (NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    //获取结束时的Frame值
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //获取动画时间
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self.writeCommodityNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-(kbSize.height - 124));
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self layoutIfNeeded];
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    if ([self.writeCommodityNumber.text intValue] <= 0) {
        self.writeCommodityNumber.text = [NSString stringWithFormat:@"%d",1];
    } else if ([self.writeCommodityNumber.text intValue] > [self.stockNumber.text intValue]){
        self.writeCommodityNumber.text = self.stockNumber.text;
    }
    self.commodityNumber.text = self.writeCommodityNumber.text;
    self.commodityPrice.text = [NSString stringWithFormat:@"%@%d",@"¥" ,self.commodityNumber.text.intValue * self.priceNumber];
    [self.writeCommodityNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.writeCommodityNumber.alpha = 0.0;
        [self layoutIfNeeded];
    }];
    self.totalPriceNumber(self.commodityNumber.text.intValue * self.priceNumber);
    self.confirmOrderCommodityNumber([self.commodityNumber.text intValue]);
    [self setNeedsUpdateConstraints];
}

- (void) toWriteComment {
    self.writeCommodityNumber.alpha = 1.0;
    [self.writeCommodityNumber becomeFirstResponder];
}

- (void) addCommodity {
    self.addShoppingCart.enabled = NO;
    self.cartCommodityNumber(self.commodityNumber.text.intValue, [self.stockNumber.text intValue]);
}
#pragma mark - UIOtherComponentDelegate

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //取消焦点
    [self.writeCommodityNumber resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.writeCommodityNumber){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) {
                return NO;// 48 unichar for 0
            } else if (character == 48 && [self.writeCommodityNumber.text intValue] == 0) {
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
    if (self.priceNumber == 0) {
        self.priceNumber =90;
    }
    
    self.commodityIntroduce = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityIntroduce.textAlignment = NSTextAlignmentLeft;
    self.commodityIntroduce.font = [UIFont systemFontOfSize:16];
    self.commodityIntroduce.numberOfLines = 0;
    [self addSubview:_commodityIntroduce];
    
    self.separator = [[UIView alloc]initWithFrame:CGRectZero];
    self.separator.backgroundColor = UIColor.lightGrayColor;
    [self addSubview:_separator];
    
    self.discountPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.discountPrice.textAlignment = NSTextAlignmentLeft;
    self.discountPrice.textColor = UIColor.redColor;
    self.discountPrice.font = [UIFont systemFontOfSize:14];
    self.discountPrice.text = [NSString stringWithFormat:@"%@%d", @"¥", self.priceNumber];
    [self addSubview:_discountPrice];
    
    self.discountPriceTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.discountPriceTitle.textAlignment = NSTextAlignmentCenter;
    self.discountPriceTitle.font = [UIFont systemFontOfSize:14];
    self.discountPriceTitle.text = @"优惠价:";
    [self addSubview:_discountPriceTitle];
    
    self.commodityStyle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityStyle.font = [UIFont systemFontOfSize:14];
    self.commodityStyle.textAlignment = NSTextAlignmentLeft;
    self.commodityStyle.text = @"规格/型号:";
    [self addSubview:self.commodityStyle];
    
    self.radioGroup = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_radioGroup];
    
    self.stockNumberTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.stockNumberTitle.textAlignment = NSTextAlignmentLeft;
    self.stockNumberTitle.text = @"库存:";
    self.stockNumberTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_stockNumberTitle];
    
    self.stockNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.stockNumber.textAlignment = NSTextAlignmentLeft;
    self.stockNumber.font = [UIFont systemFontOfSize:14];
    self.stockNumber.text = @"0";
    [self addSubview:_stockNumber];
    
    self.saleVolumeTitle = [[UILabel alloc]initWithFrame:CGRectZero];
    self.saleVolumeTitle.textAlignment = NSTextAlignmentLeft;
    self.saleVolumeTitle.text = @"销量:";
    self.saleVolumeTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_saleVolumeTitle];
    
    self.saleVolume = [[UILabel alloc]initWithFrame:CGRectZero];
    self.saleVolume.textAlignment = NSTextAlignmentLeft;
    self.saleVolume.text = @"100000";
    self.saleVolume.font = [UIFont systemFontOfSize:14];
    [self addSubview:_saleVolume];
    
    self.increaseNumbers = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.increaseNumbers setImage:[UIImage imageNamed:@"shoppingCart_shoppingCartViewController_increaseNumber_enable"] forState:UIControlStateNormal];
    [self.increaseNumbers addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.increaseNumbers];
    
    self.commodityNumber = [[UILabel alloc]initWithFrame:CGRectZero];
    self.commodityNumber.textAlignment = NSTextAlignmentCenter;
    self.commodityNumber.font = [UIFont systemFontOfSize:14];
    self.commodityNumber.text = @"1";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toWriteComment)];
    self.commodityNumber.userInteractionEnabled = YES;
    [self.commodityNumber addGestureRecognizer:gesture];
    [self addSubview:self.commodityNumber];
    //reduceNumbers
    self.reduceNumbers = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.reduceNumbers setImage:[UIImage imageNamed:@"shoppingCart_shoppingCartViewController_reduceNumber_enable"] forState:UIControlStateNormal];
    [self.reduceNumbers addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceNumbers];
    
    self.addShoppingCart = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addShoppingCart.titleLabel.font = [UIFont systemFontOfSize:14];
    self.addShoppingCart.backgroundColor = UIColor.redColor;
    [self.addShoppingCart addTarget:self action:@selector(addCommodity) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addShoppingCart];
    
    CGSize viewSize = self.bounds.size;
    self.writeCommodityNumber = [[UITextField alloc]initWithFrame:CGRectMake(0, viewSize.height - 110, viewSize.width, 40)];
    self.writeCommodityNumber.delegate = self;
    self.writeCommodityNumber.borderStyle = UITextBorderStyleRoundedRect;
    self.writeCommodityNumber.alpha = 0.0;
    [self addSubview:self.writeCommodityNumber];
    self.typeMessage = [NSArray array];
}

- (void) drawRadio {
    for (int i = 0; i < self.typeMessage.count; i++) {
        UIButton *subRadioView = [[UIButton alloc]initWithFrame:CGRectMake(0 + 100*(i%3), (i/3) * 50, 20, 50)];
        subRadioView.backgroundColor = UIColor.redColor;
        subRadioView.layer.borderColor = UIColor.blackColor.CGColor;
        subRadioView.layer.borderWidth = 1.0;
        UILabel *radioText = [[UILabel alloc]initWithFrame:CGRectMake(20 + 100*(i%3), (i/3) * 50, 50, 50)];
        radioText.text = [NSString stringWithFormat:@"%@",self.typeMessage[i][@"propertyName"]];
        radioText.font = [UIFont systemFontOfSize:12];
        [self.radioGroup addSubview:radioText];
        //单选按钮--选择后
        UIView *radioButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
        radioButton.userInteractionEnabled = NO;
        radioButton.backgroundColor = UIColor.clearColor;
        //遮罩路径
        UIBezierPath *radioButtonPath = [UIBezierPath bezierPath];
        [radioButtonPath addArcWithCenter:CGPointMake(10, 25) radius:8 startAngle:0 endAngle:2*M_PI clockwise:YES];
        //加一个遮罩
        CAShapeLayer *radioButtonMask = [CAShapeLayer layer];
        radioButtonMask.frame = radioButton.bounds;
        radioButtonMask.path = radioButtonPath.CGPath;
        radioButtonMask.strokeColor = UIColor.blackColor.CGColor;
        radioButtonMask.lineWidth = 1.0;
        subRadioView.layer.mask = radioButtonMask;
        [subRadioView addSubview:radioButton];
        //画小白点
        UIView *whiteDot = [[UIView alloc]initWithFrame:CGRectMake(7, 22, 6, 6)];
        whiteDot.backgroundColor = UIColor.whiteColor;
        whiteDot.layer.cornerRadius = 3;
        [radioButton addSubview:whiteDot];
        //单选按钮--选择前
        UIView *nonRadioButton = [[UIView alloc]initWithFrame:CGRectMake(1.5, 16.5, 17, 17)];
        nonRadioButton.backgroundColor = UIColor.clearColor;
        nonRadioButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
        nonRadioButton.layer.borderWidth = 1.0;
        nonRadioButton.layer.cornerRadius = 8.0;
        nonRadioButton.userInteractionEnabled = NO;
        [subRadioView addSubview:nonRadioButton];
        
        if ([self.selected[i] boolValue] == YES) {
            subRadioView.backgroundColor = [UIColor colorWithHexString:@"#189bd5"];
        } else {
            subRadioView.backgroundColor = UIColor.clearColor;
        }
        subRadioView.tag = i;
        [subRadioView addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.radioGroup addSubview:subRadioView];
    }
}

// 添加约束
- (void)createSubViewsConstraints {
    
    [self.commodityIntroduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(20);
        make.left.equalTo(self).mas_offset(20);
        make.right.equalTo(self).mas_offset(-20);
        make.height.equalTo(@50);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commodityIntroduce.mas_bottom).mas_offset(10);
        make.left.equalTo(self).mas_offset(20);
        make.right.equalTo(self).mas_offset(-20);
        make.height.equalTo(@1);
    }];
    [self.discountPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separator.mas_bottom).mas_offset(10);
        make.left.equalTo(self).mas_offset(20);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    [self.discountPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separator.mas_bottom).mas_offset(10);
        make.left.equalTo(self.discountPriceTitle.mas_right).mas_offset(5);
        make.height.equalTo(@20);
        make.right.equalTo(self).mas_offset(-2);
    }];
    [self.commodityStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.discountPriceTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self).mas_offset(20);
        make.height.equalTo(@50);
        make.width.equalTo(@80);
    }];
    [self.radioGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.discountPriceTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self.commodityStyle.mas_right).mas_offset(10);
        make.height.equalTo(@(floor(self.typeMessage.count/4)*50 + 50));
        make.width.equalTo(@300);
    }];
    [self.stockNumberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.radioGroup.mas_bottom);
        make.left.equalTo(self).mas_offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    [self.stockNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.radioGroup.mas_bottom);
        make.left.equalTo(self.stockNumberTitle.mas_right).mas_offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(self).mas_offset(-2);
    }];
    [self.saleVolumeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stockNumberTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self).mas_offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    [self.saleVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stockNumberTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self.saleVolumeTitle.mas_right).mas_offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(self).mas_offset(-2);
    }];
    [self.reduceNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleVolumeTitle.mas_bottom).mas_offset(17);
        make.left.equalTo(self).mas_offset(40);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [self.commodityNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleVolumeTitle.mas_bottom).mas_offset(17);
        make.left.equalTo(self.reduceNumbers.mas_right).mas_offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    [self.increaseNumbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleVolumeTitle.mas_bottom).mas_offset(17);
        make.left.equalTo(self.commodityNumber.mas_right).mas_offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    [self.addShoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleVolumeTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self.increaseNumbers.mas_right).mas_offset(20);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    [self.writeCommodityNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void) setRadioValue {
    NSLog(@"%@", self.selected);
    NSArray <UIView *> *subViews = self.radioGroup.subviews;
    for (UIView *radio in subViews) {
        if ([radio isMemberOfClass:UIButton.class]){
            radio.backgroundColor = UIColor.clearColor;
        }
    }
    self.selected = [NSMutableArray arrayWithArray:@[]];
    if (self.typeMessage.count == 0) {
        self.typeMessage = @[
                             @{@"typeId":@"1",@"typeName":@"类型1"},
                             @{@"typeId":@"2",@"typeName":@"类型2"},
                             @{@"typeId":@"3",@"typeName":@"类型3"}
                             ];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.typeMessage.count; i++) {
        if(i == 0) {
            [array addObject:@(YES)];
        }
        [array addObject:@(NO)];
    }
    self.selected = array;
    [self drawRadio];
}

- (void)updateConstraints {
    
    //自动计算文字宽度，然后更新布局
    CGFloat numberWidth = [self.commodityNumber sizeThatFits:CGSizeZero].width + 5;
    
    [self.commodityNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleVolumeTitle.mas_bottom).mas_offset(17);
        make.left.equalTo(self.reduceNumbers.mas_right).mas_offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@(numberWidth));
    }];
    unsigned long temp = 0;
    if (self.typeMessage.count%3 == 0) {
       temp  = self.typeMessage.count -1;
    } else {
       temp = self.typeMessage.count;
    }
    [self.radioGroup mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.discountPriceTitle.mas_bottom).mas_offset(10);
        make.left.equalTo(self.commodityStyle.mas_right).mas_offset(10);
        make.height.equalTo(@(temp/3 *50 + 50));
        make.width.equalTo(@300);
    }];
    [super updateConstraints];
}

- (CGSize) calculateHeightOfText : (UILabel *) textLabel{
    NSString *content = textLabel.text;
    CGSize size =[content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    return size;
}

#pragma mark - Getters and Setters

@end
