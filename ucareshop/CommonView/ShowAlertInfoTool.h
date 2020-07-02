//
//  AlertInfoViewController.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/7.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Alert)
{
    EmailFormatErrorInfo,
    VerificationCodeErrorInfo,
    PasswordErrorInfo,
    PhoneNumberErrorInfo,
    MoneyErrorInfo,
    PostCodeErrorInfo,
    NickName,
};
typedef NS_ENUM(NSInteger, AlertSpecial)
{
    EmptyInfo,
    NameWordNumberErrorInfo,
    NameUsedErrorInfo,
    EmailUsedErrorInfo,
    PhoneNumberUsedInfo,
    OldPasswordErrorInfo,
    OldAndNewPasswordMismatchedInfo,
    PhoneNumberNotExitErrorInfo,
    CodeErrorInfo,
    ZeroErrorInfo,
    PayPasswordInfo,
    EmptyNumberWarningInfo,
    MismatchWarningInfo,
    VerificationCodeNotMatchInfo,
    PhoneNumerNotExitInfo,
    FailLogin,
    VerificationCode,
    ProtocolNotRead,
    InputErrorInfo,
};
typedef NS_ENUM(NSInteger, AlertSuccessInfo)
{
    RechargeMoneySuccessInfo,
    PasswordChangeSuccessInfo,
};

NS_ASSUME_NONNULL_BEGIN

//封装成工具类的规则 ShowAlertInfoTool + NSObject
//(UIViewController *)vc 可以作为参数传递 这样就可以拿到跳转页面方法了
@interface ShowAlertInfoTool : NSObject

+ (void)alertValidate:(Alert)status viewController:(UIViewController *)vc;
+ (void)alertSpecialInfo:(AlertSpecial)status viewController:(UIViewController *)vc;
+ (void)alertSuccessInfo:(AlertSuccessInfo)status viewController:(UIViewController *)vc;
+ (void)alertLoginFailedInfo:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
