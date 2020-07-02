//
//  LoginStatus.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/18.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "LoginStatus.h"

@implementation LoginStatus


+ (BOOL)isLogin {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSInteger statusCode = [plistDict[@"statusCode"] integerValue];
    if (statusCode == 1) {
        return YES;
    } else {
        return NO;
    }
}


@end
