//
//  FMTBaseDataManager.h
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTBaseDataManager : NSObject
singleton_interface(FMTBaseDataManager)
@property (nonatomic) NSMutableDictionary *baseParams;


- (void)generalPostNoTips:(NSDictionary*)postParams
                  success:(FMSuccessBlock)success
                      url:(NSString*)api;

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
                url:(NSString*)api;

- (void)generalPostNoTips:(NSDictionary*)postParams
                  success:(FMSuccessBlock)success
                     fail:(FMFailureBlock)fail
                      url:(NSString*)api;

- (void)generalPost:(NSDictionary*)postParams
            success:(FMSuccessBlock)success
               fail:(FMFailureBlock)fail
                url:(NSString*)api;


- (void)uploadImages:(NSArray*)_imageAry
               param:(NSDictionary*)_params
            progress:(FMProgressBlock)_progress
             success:(FMSuccessBlock)_success
             failure:(FMFailureBlock)_fail;

- (void)cancelAllRequest;
@end
