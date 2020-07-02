//
//  URLRequest.m
//  ucareshop
//
//  Created by 谢佳培 on 2019/9/4.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

// import分组次序：Frameworks、Services、UI
#import "URLRequest.h"
#import "LoginViewController.h"
#import "ShowAlertInfoTool.h"
#import "AppDelegate.h"

#pragma mark - @class 

#pragma mark - 常量

#pragma mark - 枚举

@interface URLRequest ()

#pragma mark - 私有属性

@property (nullable, readonly) const char *UTF8String NS_RETURNS_INNER_POINTER;
typedef uint32_t CC_LONG;       /* 32 bit unsigned integer */
extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md);
#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */

@end

@implementation URLRequest

//方法列表使用pragma分组，并遵守如下次序, 且# pragma mark - 与上下各添加一个空行
#pragma mark - Life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Custom Delegates

#pragma mark - Public Methods

#pragma mark - Private Methods

- (NSString *)requestForProfileImage:(NSDictionary *_Nullable)parameters pathUrl:(NSString *)pathUrl {
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     
     dict[@"cid"] = @"000001";//可以写死，但是要带入计算部分
     //uid用户标识
     NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
     NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
     NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
     dict[@"uid"] = plistDict[@"uid"];
     
     //请求参数
     if (parameters.count > 0) {
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
         NSString *qValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
         //将请求参数编入url中
         dict[@"q"] = qValue;
     }
     
     //计算签名
     NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:dict.count];
     for (NSString *key in dict.allKeys) {
         NSString *string = [NSString stringWithFormat:@"%@=%@", key, dict[key]];
         [dictArray addObject:string];
     }
     NSArray *array = [dictArray sortedArrayUsingSelector:@selector(compare:)];
     NSString *signStr = [array componentsJoinedByString:@";"];
     signStr = [NSString stringWithFormat:@"%@%@", signStr, @"mUwmfk6viCFCWydSogtH"];//密钥可以写在这
     dict[@"sign"] = [self doMD5String:signStr];
     
     //拼接URL
     NSString *parametersURL = @"cid=000001";//cid 只拼接了一次，上次是用于计算
     if (dict[@"q"]) {//q非空，进行url筛选
         parametersURL = [parametersURL stringByAppendingFormat:@"&q=%@",[dict[@"q"]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];//q
     }
     if (dict[@"uid"]) {
         parametersURL = [parametersURL stringByAppendingFormat:@"&uid=%@",dict[@"uid"]];
     }
     parametersURL = [parametersURL stringByAppendingFormat:@"&sign=%@", dict[@"sign"]];//sign
     NSString *strURL = [NSString stringWithFormat:@"https://apiproxytest.ucarinc.com/ucarincapiproxy/action/th/api%@?%@",pathUrl,parametersURL];
    
    return strURL;
}

- (void)startRequest:(NSDictionary *_Nullable)parameters pathUrl:(NSString *)pathUrl {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    
    dict[@"cid"] = @"000001";//可以写死，但是要带入计算部分
    //uid用户标识
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    dict[@"uid"] = plistDict[@"uid"];
    
    
    //请求参数
    if (parameters.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
        NSString *qValue = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //将请求参数编入url中
        dict[@"q"] = qValue;
    }
    
    //计算签名
    if (dict[@"uid"] && ![dict[@"uid"]  isEqual: @""]) {
        NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:dict.count];
        for (NSString *key in dict.allKeys) {
            NSString *string = [NSString stringWithFormat:@"%@=%@", key, dict[key]];
            [dictArray addObject:string];
        }
        NSArray *array = [dictArray sortedArrayUsingSelector:@selector(compare:)];
        NSString *signStr = [array componentsJoinedByString:@";"];
        signStr = [NSString stringWithFormat:@"%@%@", signStr, @"mUwmfk6viCFCWydSogtH"];//密钥可以写在这
        dict[@"sign"] = [self doMD5String:signStr];
    } else {
        [dict removeObjectForKey:@"uid"];
        NSMutableArray *dictArray = [NSMutableArray arrayWithCapacity:dict.count];
         for (NSString *key in dict.allKeys) {
             NSString *string = [NSString stringWithFormat:@"%@=%@", key, dict[key]];
             [dictArray addObject:string];
         }
        NSArray *array = [dictArray sortedArrayUsingSelector:@selector(compare:)];
        NSString *signStr = [array componentsJoinedByString:@";"];
        signStr = [NSString stringWithFormat:@"%@%@", signStr, @"mUwmfk6viCFCWydSogtH"];//密钥可以写在这
        dict[@"sign"] = [self doMD5String:signStr];
    }
    //拼接URL
    NSString *parametersURL = @"cid=000001";//cid 只拼接了一次，上次是用于计算
    if (dict[@"q"]) {//q非空，进行url筛选
        parametersURL = [parametersURL stringByAppendingFormat:@"&q=%@",[dict[@"q"]  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];//q
    }
    if (dict[@"uid"] && ![dict[@"uid"]  isEqual: @""]) {
        parametersURL = [parametersURL stringByAppendingFormat:@"&uid=%@",dict[@"uid"]];
    }
    parametersURL = [parametersURL stringByAppendingFormat:@"&sign=%@", dict[@"sign"]];//sign

    
//后端没提供接口时，前端用于测试
//    NSArray *tempArray = [parametersURL componentsSeparatedByString:@"/"];
//    NSString *joinString = [tempArray componentsJoinedByString:@""];
//    NSString *strURL = [NSString stringWithFormat:@"10.101.44.191:9090/servertest/%@/?",joinString];
    NSString *strURL = [NSString stringWithFormat:@"https://apiproxytest.ucarinc.com/ucarincapiproxy/action/th/api%@?%@",pathUrl,parametersURL];
    NSLog(@"%@",strURL);
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *resDict;
        NSLog(@"请求完成...");
        
        if (!error) {
            resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"response:%@", resDict);
            NSInteger code = [resDict[@"code"] integerValue];
            if (code == 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.transDataBlock(resDict);
                });
            }
            if (code == 5) {//对登录失败状态（如登录时效已过）进行网络拦截
                //设为未登录状态
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
                [dict setObject:@(0) forKey:@"statusCode"];
                [dict writeToFile:filePath atomically:YES];
                //跳转到首页
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UITabBarController *tab = (UITabBarController *)delegate.window.rootViewController;
                UINavigationController *vc = tab.viewControllers[tab.selectedIndex];
                //提示登录
                [ShowAlertInfoTool alertLoginFailedInfo:vc];
            }
        } else {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
    [task resume];
}
- (NSString *)doMD5String:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    int first = abs([self bytesToInt:result offset:0]);
    int second = abs([self bytesToInt:result offset:4]);
    int third = abs([self bytesToInt:result offset:8]);
    int fourth = abs([self bytesToInt:result offset:12]);
    
    NSString *stirng = [NSString stringWithFormat:@"%d%d%d%d", first, second, third, fourth];
    return stirng;
}
- (int)bytesToInt:(Byte[])src offset:(int)offset {
    int value;
    value = (int)(((src[offset] & 0xFF) << 24) | ((src[offset + 1] & 0xFF) << 16) | ((src[offset + 2] & 0xFF) << 8) |
                  (src[offset + 3] & 0xFF));
    return value;
}

#pragma mark - Getters and Setters


@end
