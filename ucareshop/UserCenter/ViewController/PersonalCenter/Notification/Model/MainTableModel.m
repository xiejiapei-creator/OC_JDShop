//
//  MainTableModel.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/8/27.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "MainTableModel.h"

@implementation MainTableModel

- (instancetype)initWithTableType:(MainTableModelType)tableType {
    return [self initWithTableType:tableType tableTitle:nil];
}

- (instancetype)initWithTableType:(MainTableModelType)tableType tableTitle:(NSString *)tableTitle {
    self = [super init];
    if (self) {
        _tableType = tableType;
        _tableTitle = tableTitle;
        _tableHeight = 0;
    }
    
    return self;
}

@end
