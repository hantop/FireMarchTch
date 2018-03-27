//
//  FMTBaseDataManager.m
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTBaseDataManager.h"

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

- (BOOL)showAlertView:(id)info{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] delegate].window animated:YES];
    NSDictionary* dict = [FMUtils dictionaryFromJsonString:info];
    if (nil != dict && ![dict[@"code"] isEqualToString:@"000000"]) {
        [FMUtils tipWithText:dict[@"msg"] onView:[[UIApplication sharedApplication] delegate].window];
        return NO;
    }
    return YES;
}


- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
                url:(NSString*)api
{
    [self generalPost:postParams success:success fail:nil url:api];
}

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
               fail:(FMFailureBlock)fail
                url:(NSString*)api
{
    FMSuccessBlock successBlock = ^(id json){
        if ([self showAlertView:json])
        {
            success(json);
        }
        else
        {
            if (fail)
                fail(json);
        }
    };
    
    FMFailureBlock failBlock = ^(id error){
        [self showAlertView:error];
        if (fail)
            fail(error);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] delegate].window animated:YES];
    [[FMNetworkMananger sharedFMNetworkMananger] postJSONWithUrl:api
                                                     parameters:params
                                                        success:successBlock
                                                           fail:failBlock];
}
@end
