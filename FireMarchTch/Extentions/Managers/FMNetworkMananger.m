//
//  FMNetworkMananger.m
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMNetworkMananger.h"

static NSString* const ImageName = @"image";
static NSString* const ImageFileName = @"imageFile";

@implementation FMNetworkMananger

singleton_implementation(FMNetworkMananger)
-(id)init{
    if (self = [super init]) {
        self.arrayOfTasks = [NSMutableArray array];
        return self;
    }
    
    return nil;
}


//检测网络状态
- (void)checkNetWorkStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
                 DLog(@"未知网络状态");
                 break;
                 
             case AFNetworkReachabilityStatusNotReachable:
             {
                 UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                 if (localNotification == nil) {
                     return;
                 }
                 //设置本地通知的时区
                 localNotification.timeZone = [NSTimeZone defaultTimeZone];
                 //设置通知的内容
                 localNotification.alertBody = @"检查网络连接";
                 //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
                 localNotification.userInfo = @{@"alertType" : @"检查网络连接"};
                 //立即触发一个通知
                 [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
             }
                 DLog(@"检查网络连接");
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 DLog(@"手机自有网络连接");
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 DLog(@"Wifi连接");
                 break;
                 
             default:
                 break;
         }
     }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (NSString*)getPath:(NSString*)cmd{
    return [NSString stringWithFormat:@"%@%@",kFMTAPIHost,cmd];
}

- (void)postJSONWithUrl:(NSString *)urlStr
             parameters:(id)parameters
                success:(void (^)(id responseObject))success
                   fail:(void (^)(id error))fail
{
    NSString* path =  [self getPath:urlStr];
    [self postJSONWithNoServerAPI:path parameters:parameters success:success fail:fail];
}

- (void )postJSONWithNoServerAPI:(NSString *)urlStr
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                            fail:(void (^)(id error))fail
{
    DLog(@"\nServerAPI:%@, \nParameter:%@",urlStr,[parameters description]);
    // 设置请求格式
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 10.f;
    
    // 设置请求Header token值
    [self.requestSerializer setValue:[USER_DEFAULT valueForKey:kUserDefaultAccessToken] forHTTPHeaderField:kUserDefaultAccessToken];
    
    // 设置返回类型
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 调用AF发起请求
    NSURLSessionDataTask *task = [self POST:urlStr
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success)
                  success(responseObject);
              
              //回到主线程
              dispatch_async(dispatch_get_main_queue(), ^(){
              });
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
              if (fail)
                  fail(error.userInfo);
          }];
    [self.arrayOfTasks addObject:task];
    [self checkNetWorkStatus];
}


- (void)uploadImageWithUrl:(NSString *)urlStr
                     image:(UIImage *)image
                parameters:(id)parameters
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(void))failure {
    
    
    // 设置返回类型
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 设置返回格式
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* path =  [self getPath:urlStr];
    
    NSURLSessionDataTask *task = [self POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
    [self.arrayOfTasks addObject:task];
    [self checkNetWorkStatus];
}

- (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)(void))fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        /**    URLWithString返回的是网络的URL,如果使用本地URL,需要注意
         * @eg NSURL *fileURL1 = [NSURL URLWithString:path];
         */
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    [task resume];
    [self checkNetWorkStatus];
}


- (void)saveImage:(UIImage *)image withFilename:(NSString *)filename
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"HTTPClientImages/"];
    
    BOOL isDir;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if(!isDir) {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            
            NSLog(@"%@",error);
        }
    }
    
    path = [path stringByAppendingPathComponent:filename];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSLog(@"Written: %d",[imageData writeToFile:path atomically:YES]);
}



//上传图片文件（可多张）
- (void)uploadData:(NSArray*)_uploadImageAry
         parameter:(id)_parameter
             toURL:(NSString*)_urlStr
          progress:(void (^)(NSProgress *))_progress
            sccess:(void (^)(id responseObject))_success
           failure:(void (^)())_fail
{
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/javascript",@"text/html", @"text/json", nil];
    self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* path =  [self getPath:_urlStr];
    
    [self POST:path parameters:_parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(NSInteger i = 0; i < _uploadImageAry.count; i++)
        {
            UIImage* image = _uploadImageAry[i];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0);
            NSString * Name = [NSString stringWithFormat:@"%@%zi", ImageName, i+1];
            NSString * fileName = [NSString stringWithFormat:@"%@%zi.jpeg", ImageFileName,i+1];
            NSLog(@"%ld",imageData.length);
            
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            [FMUtils tipWithText:[error description] onView:nil];
            _fail();
        }
    }];
}

//上传音频文件
- (void)uploadVoice:(NSData*)_voiceData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail
{
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self POST:_urlStr parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", str];
        [formData appendPartWithFileData:_voiceData name:@"voice" fileName:fileName mimeType:@"amr/mp3/wmr"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            _fail();
        }
    }];
}

//上传视频文件
- (void)uploadVideo:(NSData*)_videoData
         parameters:(id)_param
              toURL:(NSString*)_urlStr
           progress:(void (^)(NSProgress *))_progress
            success:(void (^)(id responseObject))_success
            failure:(void (^)())_fail
{
    _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self POST:_urlStr parameters:_param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        [formData appendPartWithFileData:_videoData name:@"video" fileName:fileName mimeType:@"video/mpeg4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (_progress) {
            _progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_success) {
            _success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            DLog(@"Error::%@",[error description]);
            _fail();
        }
    }];
}


@end
