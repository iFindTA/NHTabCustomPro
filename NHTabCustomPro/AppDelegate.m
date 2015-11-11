//
//  AppDelegate.m
//  NHTabCustomPro
//
//  Created by hu jiaju on 15/11/11.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NHTabBarController.h"

@interface AppDelegate ()<NHTabBarControllerDelegate>

@property (nonatomic, strong)NHTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect mainBounds = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:mainBounds];
    self.window.backgroundColor= [UIColor whiteColor];
    ViewController *viewController = [[ViewController alloc] init];
//    UINavigationController *naviRoot = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    
    UINavigationController *msgNavi = [[UINavigationController alloc] initWithRootViewController:viewController];
    NSDictionary *msgInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"首页",kTabBarItemTitleInfo,
                             @"\U00003432",kTabBarItemIconInfo,
                             @"iconfont",kTabBarItemFontName,nil];
    //message.view.backgroundColor = [UIColor redColor];
    //messageNavi.canDragBack = NO;
    
    UIViewController *mallController = [[UIViewController alloc] init];
    UINavigationController *mallNavi = [[UINavigationController alloc] initWithRootViewController:mallController];
    NSDictionary *mallInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"商城",kTabBarItemTitleInfo,
                              @"\U000f0005",kTabBarItemIconInfo,
                              @"iconfont",kTabBarItemFontName,nil];
    //linLi.view.backgroundColor = [UIColor blueColor];
    //linLiNavi.canDragBack = NO;
    
    _tabBarController = [[NHTabBarController alloc] initWithTabBarHeight:NHTabBarHeight];
    _tabBarController.backgroundImageName = @"sl_tabbar_bg";
    _tabBarController.iconGlossyIsHidden = YES;
    _tabBarController.delegate = self;
    _tabBarController.viewControllers = [[NSMutableArray alloc] initWithObjects:msgNavi,mallNavi, nil];
    _tabBarController.tabItemsInfo = [[NSArray alloc] initWithObjects:msgInfo,mallInfo, nil];
    self.window.rootViewController = _tabBarController;
//    self.window.rootViewController = naviRoot;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)tabBarController:(NHTabBarController *)tabbar didSelectViewController:(UIViewController *)viewController {
    if (tabbar.selectedIndex == 1) {
        [tabbar.tabBar setBadgeValue:19 withIndex:1];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
