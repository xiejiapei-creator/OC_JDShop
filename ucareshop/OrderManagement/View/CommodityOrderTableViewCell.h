//
//  CommodityOrderTableViewCell.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CommodityOrderTableViewCell : UITableViewCell
    
@property (nonatomic, strong, readonly) UIImageView *commodityImage;
@property (nonatomic, strong, readonly) UILabel *commodityName;
@property (nonatomic, strong, readonly) UILabel *priceTitle;
@property (nonatomic, strong, readonly) UILabel *price;
@property (nonatomic, strong, readonly) UILabel *primePrice;
@property (nonatomic, strong, readonly) UILabel *commodityNumber;
@property (nonatomic, strong, readonly) UIImageView *multipleImage;
@property (nonatomic, strong, readonly) UIView *cellContentView;
@property (nonatomic, strong, readonly) UIButton *commentButton;
@property (nonatomic, strong, readonly) UIButton *accomplishComment;

@property (nonatomic, strong, readwrite) NSString *commodityId;
@property (nonatomic, strong, readwrite) NSString *propertyId;

- (void) updateCellConstrain;
- (void) updateDeleteOrderButton;
    
@end

NS_ASSUME_NONNULL_END
