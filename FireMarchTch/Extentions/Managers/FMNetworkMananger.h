//
//  FMNetworkMananger.h
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMNetworkMananger : AFHTTPSessionManager
singleton_interface(FMNetworkMananger)

@property (strong, nonatomic) NSMutableArray *arrayOfTasks;

/*
 * 检查网络状态
 */
- (void)checkNetWorkStatus;

- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(void (^)(id error))fail;

- (void )postJSONWithNoServerAPI:(NSString *)urlStr
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                            fail:(void (^)(id error))fail;

- (void)uploadImageWithUrl:(NSString *)urlStr
                     image:(UIImage *)image
                parameters:(id)parameters
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(void))failure;

- (void)sessionDownloadWithUrl:(NSString *)urlStr
                       success:(void (^)(NSURL *fileURL))success
                          fail:(void (^)(void))fail;

- (void)saveImage:(UIImage *)image withFilename:(NSString *)filename;

@end
