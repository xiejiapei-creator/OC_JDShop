//
//  AlertInfoViewController.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/7.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "ShowAlertInfoTool.h"
#import "AppDelegate.h"
#import "UITextField+LXDValidate.h"

@interface ShowAlertInfoTool ()

@end

@implementation ShowAlertInfoTool




// 格式警告
+ (void)alertValidate:(Alert)status viewController:(UIViewController *)vc {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"alert controller cancel");
    }];
    UIAlertController *failController;
    switch (status) {
        case EmailFormatErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱格式不正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case VerificationCodeErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"短信验证码格式不正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PasswordErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码长度需为6-20位,同时包含数字和大小写字母!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PhoneNumberErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号码为11位的数字!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case MoneyErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入正确的金额!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PostCodeErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮政编码为6位数字!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case NickName: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称为4-8位汉字!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        default: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
    }
    [vc presentViewController:failController animated:YES completion:nil];
}
// 特定信息警告
+ (void)alertSpecialInfo:(AlertSpecial)status viewController:(UIViewController *)vc {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertController *failController;
    switch (status) {
        case EmptyInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"有文本框为空，请输入信息!!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case InputErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入信息不正确!!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case FailLogin: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败!!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case VerificationCodeNotMatchInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"短信验证码不正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case NameUsedErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称已被使用!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case NameWordNumberErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认昵称字数在8位以内!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case OldPasswordErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入正确的旧密码!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PhoneNumerNotExitInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该手机号未注册，用户不存在!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case OldAndNewPasswordMismatchedInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认密码与新密码不一致!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PhoneNumberNotExitErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不存在/无效，短信无法发送!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PhoneNumberUsedInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该手机号已注册!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case CodeErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"短信验证码不正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case ZeroErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入大于0的金额!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case PayPasswordInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付密码错误!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
            
        case EmptyNumberWarningInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号码/登录密码!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case ProtocolNotRead: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未勾选已阅读并同意《用户服务协议》!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case VerificationCode: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"短信验证码发送成功!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case EmailUsedErrorInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱已经被使用!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case MismatchWarningInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号或登陆密码错误!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        default: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
    }
    [vc presentViewController:failController animated:YES completion:nil];
}
//操作成功
+ (void)alertSuccessInfo:(AlertSuccessInfo)status viewController:(UIViewController *)vc {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [vc.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertController *failController;
    switch (status) {
        case PasswordChangeSuccessInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改成功!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        case RechargeMoneySuccessInfo: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"充值成功!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
        default: {
            failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入正确!" preferredStyle:UIAlertControllerStyleAlert];
            [failController addAction:okAction];
            break;
        }
    }
    [vc presentViewController:failController animated:YES completion:nil];       
}
//网络拦截-登录失效
+ (void)alertLoginFailedInfo:(UIViewController *)vc {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
        tab.selectedIndex = 0;
    }];
    UIAlertController *failController;
    failController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失效，请重新登录!" preferredStyle:UIAlertControllerStyleAlert];
    [failController addAction:okAction];
    [vc presentViewController:failController animated:YES completion:nil];
}

@end
