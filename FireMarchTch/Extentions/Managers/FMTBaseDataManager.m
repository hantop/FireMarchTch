//
//  FMTBaseDataManager.m
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTBaseDataManager.h"

@interface FMTBaseDataManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation FMTBaseDataManager
singleton_implementation(FMTBaseDataManager)


- (id) init
{
    if (self = [super init])
    {
        [self initPostBaseParameters];
        return self;
    }
    return nil;
}

- (void)initPostBaseParameters
{
    //固定请求参数确定
    NSDictionary* _tmpparams = @{
                                 @"os" : @"ios",
                                 @"suffix" : ((iPhone6Plus || iPhone6) ? @"@3x" : @"@2x")
                                 };
    _params = [_tmpparams mutableCopy];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

- (BOOL)showAlertView:(id)info{
    [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary* dict = [FMUtils dictionaryFromJsonString:info];
    DLog(@"ResponseData:%@", [dict description]);
    if (nil != dict &&
        dict[@"msg"] &&
        ![dict[@"code"] isEqualToString:@"000000"]) {
        [FMUtils tipWithText:dict[@"msg"] onView:[self getCurrentVC].view];
        return NO;
    }
    else if ([dict[@"NSLocalizedDescription"] isEqualToString: @"cancelled"])
    {
        return NO;
    }
    return YES;
}

- (void)generalPostNoTips:(NSDictionary*)postParams
                  success:(FMSuccessBlock)success
                      url:(NSString*)api {
    [self generalPost:postParams success:success fail:nil url:api withTips:NO];
}

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
                url:(NSString*)api
{
    [self generalPost:postParams success:success fail:nil url:api withTips:YES];
}

- (void)generalPostNoTips:(NSDictionary*)postParams
                  success:(FMSuccessBlock)success
                     fail:(FMFailureBlock)fail
                      url:(NSString*)api {
    [self generalPost:postParams success:success fail:fail url:api withTips:NO];
}

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
               fail:(FMFailureBlock)fail
                url:(NSString*)api {
    [self generalPost:postParams success:success fail:fail url:api withTips:YES];
}

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
               fail:(FMFailureBlock)fail
                url:(NSString*)api
           withTips:(BOOL)isShowTip
{
    FMSuccessBlock successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            if (success)
                success(json);
        }
        else
        {
            if (fail)
                fail(json);
        }
    };
    
    FMFailureBlock failBlock = ^(id error){
        if ([self showAlertView:error] && fail)
            fail(error);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    if (isShowTip) {
        [MBProgressHUD showHUDAddedTo:[self getCurrentVC].view animated:YES];
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    [[FMNetworkMananger sharedFMNetworkMananger] postJSONWithUrl:api
                                                      parameters:params
                                                         success:successBlock
                                                            fail:failBlock];
}

- (void)cancelAllRequest {
    [MBProgressHUD hideHUDForView:[self getCurrentVC].view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[FMNetworkMananger sharedFMNetworkMananger].arrayOfTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL *stop) {
        [taskObj cancel]; /// when sending cancel to the task failure: block is going to be called
    }];
}
@end
