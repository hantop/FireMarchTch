//
//  FMNetworkMananger.m
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMNetworkMananger.h"

@implementation FMNetworkMananger

singleton_implementation(FMNetworkMananger)
-(id)init{
    if (self = [super init]) {
        
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
                 [FMUtils tipWithText:@"请检查网络设置，确保连接网络" onView:nil];
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
                   fail:(void (^)(void))fail
{
    NSString* path =  [self getPath:urlStr];
    [self postJSONWithNoServerAPI:path parameters:parameters success:success fail:fail];
}

- (void)postJSONWithNoServerAPI:(NSString *)urlStr
                     parameters:(id)parameters
                        success:(void (^)(id responseObject))success
                           fail:(void (^)(void))fail
{
    DLog(@"\nServerAPI:%@, \nParameter:%@",urlStr,[parameters description]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    // 设置请求Header token值
    [manager.requestSerializer setValue:[USER_DEFAULT valueForKey:kFMTAccessToken] forHTTPHeaderField:kFMTAccessToken];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    // 设置返回类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog();
        if (success)
        {
            success(responseObject);
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"~~~~~~~~~~~~~~~~~~~~网络失败~~~~~~~~~~~~~~~~~~~~");
    }];
}


- (void)uploadImageWithUrl:(NSString *)urlStr
                     image:(UIImage *)image
                parameters:(id)parameters
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(void))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString* path =  [self getPath:urlStr];
    
    [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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


@end
