//
//  CommodityPayTableViewCell.h
//  ucareshop
//
//  Created by liushuting on 2019/8/21.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

#pragma mark - block传值

typedef void (^passOrderNumber)(NSString * _Nonnull commodityNumber);
typedef void (^passIndex)(NSInteger cartGoodsId, NSInteger index);

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CommodityPayTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *commodityImage;
@property (nonatomic, strong, readonly) UILabel *commodityName;
@property (nonatomic, strong, readonly) UILabel *priceTitle;
@property (nonatomic, strong, readonly) UILabel *price;
@property (nonatomic, strong, readonly) UILabel *primePrice;
@property (nonatomic, strong, readonly) UITextField *commodityNumber;
@property (nonatomic, assign, readwrite) NSInteger index;

@property (nonatomic, strong, readwrite) NSString *commodityId;
@property (nonatomic, strong, readwrite) NSString *propertyId;
@property (nonatomic, strong, readwrite) NSString *cartGoodsId;

@property (nonatomic, copy) passOrderNumber commodityNumberValue;
@property (nonatomic, copy) passIndex commodityIndex;

- (void) updateCellConstrain;
@end

NS_ASSUME_NONNULL_END
