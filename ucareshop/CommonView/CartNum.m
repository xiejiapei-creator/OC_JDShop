//
//  CartNum.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/25.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "AppDelegate.h"
#import "URLRequest.h"
#import "CartNum.h"

@implementation CartNum

+ (void)getCartNum {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    URLRequest *urlRequestForOrderNumber = [[URLRequest alloc] init];
    urlRequestForOrderNumber.transDataBlock = ^(NSDictionary * _Nonnull content) {
        NSInteger errorStatusCode = [content[@"code"] integerValue];
        if (errorStatusCode == 1) {
            NSInteger count = [content[@"content"] integerValue];
            NSString *num  = [NSString stringWithFormat:@"%ld",(long)count];
            delegate.shoppingCartNavigationController.tabBarItem.badgeValue = num;
        } else {
            NSLog(@"%@",content[@"msg"]);
        }
    };
    [urlRequestForOrderNumber startRequest:nil pathUrl:@"/order/getCartGoodsNum"];
}

@end
