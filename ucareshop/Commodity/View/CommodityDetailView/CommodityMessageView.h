//
//  CommodityMessageView.h
//  ucareshop
//
//  Created by liushuting on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

#pragma mark - 块

typedef void (^jumpAction)(void);
typedef void (^passCommodityNumber)(NSInteger commodityNumber);
typedef void (^addCommodityNumber)(NSInteger commodityNumber, NSInteger stockNumber);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CommodityMessageView : UIView

@property (nonatomic, strong, readonly) UILabel *commodityIntroduce;
@property (nonatomic, assign, readwrite) int priceNumber;
@property (nonatomic, strong, readonly) UILabel *discountPrice;
@property (nonatomic, strong, readonly) UILabel *commodityStyle;
@property (nonatomic, strong, readonly) UIView *radioGroup;
@property (nonatomic, assign, readonly) int radioNumber;
@property (nonatomic, strong, readonly) UILabel *stockNumber;
@property (nonatomic, strong, readonly) UILabel *saleVolume;
@property (nonatomic, strong, readonly) UILabel *commodityPrice;
@property (nonatomic, strong, readonly) UIButton *gotoShoppingCart;
@property (nonatomic, strong, readonly) UIButton *addShoppingCart;
@property (nonatomic, strong, readonly) UIButton *settleAccount;
@property (nonatomic, assign, readwrite) NSInteger radioIndex;
@property (nonatomic, strong, readonly) UILabel *brandView;
@property (nonatomic, strong, readwrite) NSArray <NSDictionary *> *typeMessage;

@property (nonatomic, copy, readwrite) addCommodityNumber cartCommodityNumber;
@property (nonatomic, copy, readwrite) passCommodityNumber confirmOrderCommodityNumber;
@property (nonatomic, copy, readwrite) passCommodityNumber typeNumber;
@property (nonatomic, copy, readwrite) passCommodityNumber totalPriceNumber;
@property (nonatomic, copy, readwrite) passCommodityNumber commodityNumberBlock;

- (void) setRadioValue;
- (void)updateConstraints;

@end

NS_ASSUME_NONNULL_END
