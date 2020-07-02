//
//  UITextField+LXDValidate.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/7.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "UITextField+LXDValidate.h"

@implementation UITextField (LXDValidate)

- (BOOL)isEmpty
{
    return self.text.length == 0;
}

- (BOOL)validateTextCount 
{
    //[A-Za-z0-9]
    return [self validateWithRegExp:
            @"^.{1,8}$"];
}

- (BOOL)validateEmail
{
    return [self validateWithRegExp: @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)validateAuthen
{
    return [self validateWithRegExp: @"^\\d{6}$"];
}

- (BOOL)validateMoney
{
    return [self validateWithRegExp: @"^\\d{1,}$"];
}

- (BOOL)validatePassword
{
    NSString * length = @"^\\w{6,20}$";    //长度
    NSString * number = @"^\\w*\\d+\\w*$";   //数字
    NSString * lower = @"^\\w*[a-z]+\\w*$";   //小写字母
    NSString * upper = @"^\\w*[A-Z]+\\w*$";  //大写字母
    return [self validateWithRegExp: length] && [self validateWithRegExp: number] && [self validateWithRegExp: lower] && [self validateWithRegExp: upper];
}

- (BOOL)validatePhoneNumber
{
    NSString * reg = @"^\\d{11}$";
    return [self validateWithRegExp: reg];
}

- (BOOL)validatePostCode
{
    NSString * reg = @"^\\d{6}$";
    return [self validateWithRegExp: reg];
}

- (BOOL)validateWithRegExp: (NSString *)regExp
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject: self.text];
}
//昵称
- (BOOL) validateNickname:(NSString *)nickname{
  NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{1,8}$";
  NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
  return [passWordPredicate evaluateWithObject:nickname];
}


@end

