//
//  ScrollTableViewCell.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/10/9.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollTableViewCell : UITableViewCell

@property (nonatomic, strong) AutoScrollView *autoScrollView;

@end

NS_ASSUME_NONNULL_END
