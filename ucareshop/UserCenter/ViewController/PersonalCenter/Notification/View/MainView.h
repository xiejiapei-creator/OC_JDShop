//
//  MainView.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import <UIKit/UIKit.h>

@class MainViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol MainViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView checkCell:(NSInteger)index;

@end

@interface MainView : UIView

@property (nonatomic, weak) id<MainViewDelegate> delegate;

@property (nonatomic, strong) MainViewModel *mainViewModel;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

- (instancetype)initWithDelegate:(id)delegate viewModel:(MainViewModel *)viewModel;
- (void)getDataList;
@end

NS_ASSUME_NONNULL_END
