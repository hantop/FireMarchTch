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

//上传图片文件（可多张）
- (void)uploadData:(NSArray*)_uploadImageAry
         parameter:(id)_parameter
             toURL:(NSString*)_urlStr
          progress:(void (^)(NSProgress *))_progress
            sccess:(void (^)(id responseObject))_success
           failure:(void (^)())_fail;

//上传音频文件
- (void)uploadVoice:(NSData*)_voiceData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail;

//上传视频文件
- (void)uploadVideo:(NSData*)_videoData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail;

@end
