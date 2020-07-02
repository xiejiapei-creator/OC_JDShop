//
//  CollectionTableViewCell.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/26.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import <UIKit/UIKit.h>
#import "UITextField+LXDValidate.h"
#import "ShowAlertInfoTool.h"
#import "URLRequest.h"

#pragma mark - @class

#pragma mark - 常量

#pragma mark - 枚举

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionTableViewCellDelegate <NSObject>

- (void)itemDidSelected:(NSInteger)index;



@end

/**
 * <#类注释，说明类的功能#>
 * @note <#额外说明的注意项，说明一些需要注意的地方，没有可取消此项。#>
 */
@interface CollectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
@property (copy) void (^blockProperty)(NSInteger row, NSString *goodsId);

@property (nonatomic, weak) id<CollectionTableViewCellDelegate> delegate;

@property (nonatomic, strong) URLRequest *urlRequest;
@property (strong, nonatomic) NSMutableArray *events;

@property (nonatomic) NSString *goodsId;

@property (nonatomic, assign) BOOL canContentScroll;
@property (nonatomic, assign) BOOL fingerIsTouch;


@end

NS_ASSUME_NONNULL_END
