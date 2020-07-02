//
//  UCARInnerLoadingView.h
//  UCARUIKit
//
//  Created by 谢佳培 on 2019/9/4.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT const CGFloat UCARInnerLoadingSize;

//局部loading
@interface UCARInnerLoadingView : UIView

- (void)startAnimation;
- (void)stopAnimation;

@end
