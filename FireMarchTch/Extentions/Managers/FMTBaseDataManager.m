//
//  FMTBaseDataManager.m
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTBaseDataManager.h"
#import <PPNetworkHelper.h>

@interface FMTBaseDataManager ()

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
    _baseParams = [_tmpparams mutableCopy];
}



- (BOOL)showAlertView:(id)info{
    [MBProgressHUD hideHUDForView:[FMUtils getCurrentVC].view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary* dict = [FMUtils dictionaryFromJsonString:info];
    DLog(@"ResponseData:%@", [dict description]);
    if (nil != dict &&
        dict[@"msg"] &&
        ![dict[@"code"] isEqualToString:@"000000"]) {
        [FMUtils tipWithText:dict[@"msg"] onView:[FMUtils getCurrentVC].view];
        return NO;
    }
    else if ([dict[@"NSLocalizedDescription"] isEqualToString: @"cancelled"])
    {
        return NO;
    }
    else if (!dict) {
        [FMUtils tipWithText:@"服务器偷懒了" onView:[FMUtils getCurrentVC].view];
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
    [params setValuesForKeysWithDictionary:self.baseParams];
    [params setValuesForKeysWithDictionary:postParams];
    
    if (isShowTip) {
        [MBProgressHUD showHUDAddedTo:[FMUtils getCurrentVC].view animated:YES];
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
    [[FMNetworkMananger sharedFMNetworkMananger] postJSONWithUrl:api
                                                      parameters:params
                                                         success:successBlock
                                                            fail:failBlock];
}

- (void)generalUploadImages:(NSArray*)_imageAry
                      param:(NSDictionary*)_params
                   progress:(FMProgressBlock)_progress
                    success:(FMSuccessBlock)_success
                    failure:(FMFailureBlock)_fail
                     andUrl:(NSString*)_url
{
    FMSuccessBlock successBlock = ^(id json)
    {
        if ([self showAlertView:json])
        {
            _success(json);
        }
        else if (_fail)
        {
            _fail(json);
        }
    };
    
    FMFailureBlock failBlock = ^(id json){
        if (_fail) {
            _fail(json);
        }
    };
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:_params];
    [params setValue:@"files" forKey:@"action"];
    [params setValuesForKeysWithDictionary:self.baseParams];
    
    [[FMNetworkMananger sharedFMNetworkMananger] uploadData:_imageAry
                                                parameter:params
                                                    toURL:_url
                                                 progress:_progress
                                                   sccess:successBlock
                                                  failure:failBlock];
}


- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(FMProgressBlock)_progress
             success:(FMSuccessBlock)_success
             failure:(FMFailureBlock)_fail
{
    [self generalUploadImages:_imageAry
                        param:_params
                     progress:_progress
                      success:_success
                      failure:_fail
                       andUrl:kFMTAPIUploadImage];
}

- (void)cancelAllRequest {
    [MBProgressHUD hideHUDForView:[FMUtils getCurrentVC].view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[FMNetworkMananger sharedFMNetworkMananger].arrayOfTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask *taskObj, NSUInteger idx, BOOL *stop) {
        [taskObj cancel]; /// when sending cancel to the task failure: block is going to be called
    }];
}
@end
