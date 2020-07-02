//
//  BaseTableViewCell.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)cellWithTableNibView:(UITableView *)tableView;
- (void)setupCell;
- (void)setupSubViews;
- (void)setViewWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
