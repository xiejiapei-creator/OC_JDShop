//
//  AppDelegate.m
//  ucareshop
//
//  Created by liushuting on 2019/8/20.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CommodityDetailViewController.h"
#import "ClassifyViewController.h"
#import "ShoppingCartViewController.h"
#import "URLRequest.h"
#import "LoginViewController.h"
#import "UserCenterViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    
    //创建首页标签
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeNavigationController.tabBarItem.title = @"首页";
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"home_homeViewController_tabBarButton_home"];
    
    //创建分类标签
    ClassifyViewController *classificationViewController = [[ClassifyViewController alloc] init];
    UINavigationController *classificationNavigationController = [[UINavigationController alloc] initWithRootViewController:classificationViewController];
    classificationNavigationController.tabBarItem.title = @"分类";
    classificationNavigationController.tabBarItem.image = [UIImage imageNamed:@"home_classificationViewController_tabBarButton_class"];
    
    //创建购物车标签
    ShoppingCartViewController *shoppingCartViewController = [[ShoppingCartViewController alloc] init];
    self.shoppingCartNavigationController = [[UINavigationController alloc] initWithRootViewController:shoppingCartViewController];
    self.shoppingCartNavigationController.tabBarItem.title = @"购物车";
    self.shoppingCartNavigationController.tabBarItem.image = [UIImage imageNamed:@"home_userCenterViewController_tabBarButton_cart"];

    
    //创建用户中心标签
    UserCenterViewController *userCenterViewController = [[UserCenterViewController alloc] init];
    UINavigationController *userCenterNavigationController = [[UINavigationController alloc] initWithRootViewController:userCenterViewController];
    userCenterNavigationController.tabBarItem.title = @"用户中心";
    userCenterNavigationController.tabBarItem.image = [UIImage imageNamed:@"home_homeViewController_tabBarButton_user"];
    tabBarController.viewControllers = @[homeNavigationController, classificationNavigationController, self.shoppingCartNavigationController, userCenterNavigationController];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:73/255.0 green:157/255.0 blue:224/255.0 alpha:1], NSForegroundColorAttributeName,[UIFont fontWithName:@"FZSXSLKJW--GB1-0" size:12.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    //初始化设置用户中心那为未登录状态，否则会记录下上次的登录状态
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"uid.plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [plistDict setObject:@(0) forKey:@"statusCode"];
    [plistDict writeToFile:filePath atomically:YES];
    
    
    
    
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
