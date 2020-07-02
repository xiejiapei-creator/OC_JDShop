//
//  MainViewModel.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.

#import "MainViewModel.h"

#import "MainTableModel.h"

@implementation MainViewModel

- (void)loadTableDatas {
    
//    for (id object in self.listArray) {
    for (int i=0; i< 5; i++) {
        MainTableModel *headModel = [[MainTableModel alloc] init];
        MainTableModel *contentModel = [[MainTableModel alloc] init];
        headModel.tableHeight = 70;
        headModel.tableContent = @[contentModel];
        [self.arrayTableDatas addObjectsFromArray:@[headModel]];
    }
/*
    MainTableModel *tableModel0 = [[MainTableModel alloc] init];
    tableModel0.tableHeight = 70;
    //单元格数目
    MainTableModel *tableModel0_1 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel0_2 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel0_3 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel0_4 = [[MainTableModel alloc] init];
//    tableModel0.tableContent = @[tableModel0_1, tableModel0_2, tableModel0_3, tableModel0_4];
    tableModel0.tableContent = @[tableModel0_1];
    
    MainTableModel *tableModel1 = [[MainTableModel alloc] init];
    tableModel1.tableHeight = 70;
    
    MainTableModel *tableModel1_1 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel1_2 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel1_3 = [[MainTableModel alloc] init];
//    MainTableModel *tableModel1_4 = [[MainTableModel alloc] init];
//    tableModel1.tableContent = @[tableModel1_1, tableModel1_2, tableModel1_3, tableModel1_4];
    tableModel1.tableContent = @[tableModel1_1];
    
    [self.arrayTableDatas addObjectsFromArray:@[tableModel0, tableModel1]];
*/
}

#pragma mark - Setter & Getter
- (NSMutableArray<MainTableModel *> *)arrayTableDatas {
    if (!_arrayTableDatas) {
        _arrayTableDatas = [NSMutableArray array];
    }
    
    return _arrayTableDatas;
}

@end
