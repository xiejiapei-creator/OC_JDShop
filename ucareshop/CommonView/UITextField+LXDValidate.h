//
//  UITextField+LXDValidate.h
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/7.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface  UITextField (LXDValidate)

// 判断文本框是否为空（非正则表达式）
- (BOOL)isEmpty;

// 判断文本框字数是否符合规范
- (BOOL)validateTextCount;

// 判断邮箱是否正确
- (BOOL)validateEmail;

// 判断验证码是否正确
- (BOOL)validateAuthen;

// 判断密码格式是否正确
- (BOOL)validatePassword;

// 判断手机号码是否正确
- (BOOL)validatePhoneNumber;

// 判断输入金额是否正确
- (BOOL)validateMoney;

// 判断邮编地址是否正确
- (BOOL)validatePostCode;

// 昵称
- (BOOL) validateNickname:(NSString *)nickname;

// 自己写正则传入进行判断
- (BOOL)validateWithRegExp: (NSString *)regExp;

@end

NS_ASSUME_NONNULL_END
