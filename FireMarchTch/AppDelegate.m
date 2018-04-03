//
//  AppDelegate.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/3/12.
//  Copyright © 2018年 Joe.Pen. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //-------------------1.设置状态栏隐藏，因为有广告------------------
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [USER_DEFAULT setValue:@"1234" forKey:kFMTAccessCode];
    
    //------------------2.设置URL缓存机制----------------
//    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:40 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
//    [NSURLCache setSharedURLCache:URLCache];
    
    //--------------------4.初始化定位-------------------
    [[CCLocationManager shareLocation]getCity:^(NSString *addressString) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLastLatitude],[USER_DEFAULT doubleForKey:CCLastLongitude]);
//        [CZJBaseDataInstance setCurLocation:location];
//        [CZJBaseDataInstance setCurCityName:addressString];
    }];
    
    //-----------------6.设置主页并判断是否启动广告页面--------------
#ifdef DEBUG//离线日志打印
    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif

    UIViewController *rootViewController = [FMUtils getViewControllerFromStoryboard:@"RegLogin" andVCName:@"LoginNavi"];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    //-------------------8.字典描述分类替换----------------
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    //--------------------9.开启帧数显示------------------
//    [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    
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
    UIViewController* unloackView = [FMUtils getViewControllerFromStoryboard:@"Main" andVCName:@"unlockView"];
    [self.window.rootViewController presentViewController:unloackView animated:YES
                                               completion:nil];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
