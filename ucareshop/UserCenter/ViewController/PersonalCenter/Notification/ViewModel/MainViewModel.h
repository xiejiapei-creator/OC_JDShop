//
//  MainViewModel.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import <Foundation/Foundation.h>

@class MainTableModel;

NS_ASSUME_NONNULL_BEGIN

@interface MainViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<MainTableModel *> *arrayTableDatas;
@property (nonatomic, strong) NSMutableArray *listArray;//单元格数目

- (void)loadTableDatas;

@end

NS_ASSUME_NONNULL_END
