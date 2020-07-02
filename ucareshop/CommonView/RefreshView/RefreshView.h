//
//  RefreshView.h
//  ucareshop
//
//  Created by liushuting on 2019/9/25.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

FOUNDATION_EXPORT const CGFloat UCARPullLoadingViewSize;

//下拉loading
@interface RefreshView : UIView

@property (weak, nonatomic) UIScrollView *scrollView;

//拉多少距离转一周
@property (nonatomic, assign) CGFloat distanceForTurnOneCycle;

- (void)loading;
//when cancel || finish loading, call this
- (void)loadingFinished;

@end
