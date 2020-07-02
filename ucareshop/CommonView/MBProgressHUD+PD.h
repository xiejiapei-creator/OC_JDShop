//
//  MBProgressHUD (PD).h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/23.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
// 
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (PD)


+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;



@end
