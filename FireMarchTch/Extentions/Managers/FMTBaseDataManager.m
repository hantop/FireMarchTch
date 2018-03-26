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
    NSDictionary* dict = [FMUtils dictionaryFromJsonString:info];
    if (![dict[@"status"] isEqualToString:@"000000"]) {
        [FMUtils tipWithText:[dict description] onView:nil];
        return YES;
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
    };
    
    FMFailureBlock failBlock = ^(id error){
        if (fail)
            fail(error);
    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValuesForKeysWithDictionary:self.params];
    [params setValuesForKeysWithDictionary:postParams];
    
    [[FMNetworkMananger sharedFMNetworkMananger] postJSONWithUrl:api
                                                     parameters:params
                                                        success:successBlock
                                                           fail:failBlock];
}
@end
