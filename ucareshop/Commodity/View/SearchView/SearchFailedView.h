//
//  SearchFailedView.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/16.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchFailedView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, readwrite) UITextField *searchTextField;
@property (nonatomic, readwrite) UIImageView *clearImage;
@property (nonatomic, readwrite) UIButton *clearButton;

@end

NS_ASSUME_NONNULL_END
