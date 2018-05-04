//
//  AppDelegate.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/3/12.
//  Copyright © 2018年 Joe.Pen. All rights reserved.
//

#import "AppDelegate.h"
#import "YYFPSLabel.h"
extern CFAbsoluteTime StartTime;

@interface AppDelegate ()

@property (strong, nonatomic) __block UIView* notifyView;
@end

@implementation AppDelegate

- (void)initNotifyView
{
    _notifyView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, PJ_SCREEN_WIDTH, 64)];
    _notifyView.backgroundColor = FSYellow;
    _notifyView.alpha = 0.9;
    UISwipeGestureRecognizer* downGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipToHideNotifyView:)];
    [downGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [_notifyView addGestureRecognizer:downGesture];
    UILabel* notifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 27, PJ_SCREEN_WIDTH - 30, 35)];
    notifyLabel.tag = 1001;
    notifyLabel.textColor = WHITECOLOR;
    notifyLabel.textAlignment = NSTextAlignmentLeft;
    notifyLabel.font = SYSTEMFONT(15);
    notifyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    notifyLabel.numberOfLines = 2;
    [_notifyView addSubview:notifyLabel];
    [notifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_notifyView).offset(0);
        make.centerY.equalTo(_notifyView).offset(10);
    }];
    [self.window addSubview:_notifyView];
}

- (void)initUserDefaultDatas
{
    [USER_DEFAULT setValue:@"" forKey:kUserDefaultTimeDay];
    [USER_DEFAULT setValue:@"" forKey:kUserDefaultTimeMin];
    [USER_DEFAULT setValue:@"" forKey:kUserDefaultRandomCode];
    [USER_DEFAULT setValue:@"" forKey:kUserDefaultInviteCodeCheck];
    
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedCarModelType];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedCarModelID];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultChoosedBrandID];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPrice];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultEndPrice];
//    [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultStockFlag];
//    [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultPromotionFlag];
//    [USER_DEFAULT setValue:@"false" forKey:kUSerDefaultRecommendFlag];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultServicePlace];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultDetailStoreItemPid];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultDetailItemCode];
    [USER_DEFAULT setValue:@"" forKey:kUserDefaultAccessCode];
    
//    [USER_DEFAULT setObject:@"" forKey:kUSerDefaultSexual];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageUrl];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageImagePath];
//    [USER_DEFAULT setValue:@"" forKey:kUserDefaultStartPageForm];
//    [USER_DEFAULT setObject:@"0" forKey:kUserDefaultShoppingCartCount];
//    [USER_DEFAULT setObject:@"0" forKey:kCZJDefaultCityID];
//    [USER_DEFAULT setObject:@"" forKey:kCZJDefaultyCityName];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        iLog(@"Lauched in %f seconds.", (CFAbsoluteTimeGetCurrent() - StartTime));
    });
    
    //-------------------1.设置状态栏隐藏，因为有广告------------------
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [USER_DEFAULT setValue:@"1234" forKey:kFMTAccessCode];
    
    //------------------2.设置URL缓存机制----------------
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:40 * 1024 * 1024 diskCapacity:40 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    //--------------------4.初始化定位-------------------
    [[CCLocationManager shareLocation]getCity:^(NSString *addressString) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([USER_DEFAULT doubleForKey:CCLastLatitude],[USER_DEFAULT doubleForKey:CCLastLongitude]);
//        [CZJBaseDataInstance setCurLocation:location];
//        [CZJBaseDataInstance setCurCityName:addressString];
    }];
    
    //-----------------6.设置主页并判断是否启动广告页面--------------
#ifdef DEBUG//离线日志打印
    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //--------------------9.开启帧数显示------------------
    YYFPSLabel *label = [[YYFPSLabel alloc] initWithSize:CGSizeMake(60, 20)];
    label.textColor = FSYellow;
    [self.window addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.window).offset(-50);
        make.top.mas_equalTo(self.window).offset(3);
    }];
    
#else
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    
    NSString *storyboardName = @"RegLogin";
    NSString *vcName = @"LoginNavi";
    [USER_DEFAULT setValue:@"0" forKey:kUserDefaultIsLogin];
    if ([[USER_DEFAULT valueForKey:kUserDefaultIsLogin] isEqualToString:@"1"]) {
        storyboardName = @"Main";
        vcName = @"MainNavi";
    }

    UINavigationController *rootViewController = (UINavigationController *)[FMUtils getViewControllerFromStoryboard:storyboardName andVCName:vcName];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    [self.window bringSubviewToFront:label];
    
    //-------------------8.字典描述分类替换----------------
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    
    //-------------------12.接收远程通知本地显示---------------
    [self initNotifyView];
    
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
    if ([USER_DEFAULT valueForKey:kUserDefaultAccessCode]) {
        UIViewController* unloackView = [FMUtils getViewControllerFromStoryboard:@"Main" andVCName:@"unlockView"];
        [self.window.rootViewController presentViewController:unloackView animated:YES
                                                   completion:nil];
    }
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    ((UILabel*)VIEWWITHTAG(_notifyView, 1001)).text = notification.alertBody;
    [self showNotifyView];
}

#pragma mark- LocalNotification
//显示通知条
- (void)showNotifyView
{
    [UIView animateWithDuration:0.3 animations:^{
        _notifyView.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, 64);
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self performSelector:@selector(hideNotifyView) withObject:nil afterDelay:1];
        }
    }];
}

- (void)swipToHideNotifyView:(UIGestureRecognizer*)gestture
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotifyView) object:nil];
    [self hideNotifyView];
}

- (void)hideNotifyView
{
    [UIView animateWithDuration:0.3 animations:^{
        _notifyView.frame = CGRectMake(0, -64, PJ_SCREEN_WIDTH, 64);
    }];
}
@end
