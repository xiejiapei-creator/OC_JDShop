//
//  SearchResultView.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/30.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface SearchResultView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, readwrite) UITextField *searchTextField;
@property (nonatomic, readwrite) UIImageView *clearImage;
@property (nonatomic, readwrite) UIButton *clearButton;

@property (nonatomic) NSString *goodsId;

@property (nonatomic, copy) NSString *text;

@property (nonatomic) NSArray *events;
@property (nonatomic, copy) void(^blockGoodsId)(NSString *goodsID);

- (void)reload;//重新加载

@end

NS_ASSUME_NONNULL_END
