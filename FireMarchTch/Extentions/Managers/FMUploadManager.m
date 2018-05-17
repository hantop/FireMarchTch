//
//  FMUploadManager.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/5/14.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMUploadManager.h"
#import <ZLPhotoManager.h>
#define PHOTOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"photoCache"]
#define VIDEOCACHEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"videoCache"]

@implementation FMUploadManager
singleton_implementation(FMUploadManager)

- (id)init {
    if (self == [super init]) {
        self.uploadPicModelArray = [NSMutableArray array];
        self.uploadVideoModelArray = [NSMutableArray array];
    }
    return self;
}

- (void)dealWithVideoPHAssets:(NSArray<PHAsset *> *)assets complete:(UploadCompleteBlock)completeBlock
{
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ZLPhotoManager requestOriginalImageDataForAsset:obj completion:^(NSData * data, NSDictionary *info) {
            FMTImageUploadModel *model = [FMTImageUploadModel new];
            model.data = data;
            model.totalSize = data.length;
            TICK;
            NSString *path = [FMUtils writeToCacheVideo:data appendNameString:@"video.mov"];
            TOCK;
            if (completeBlock) {
                completeBlock();
            }
            DLog(@"大小：%lu, 路径：%@",data.length,path);
        }];

    }];
}

- (void)dealWithImagePHAssets:(NSArray<PHAsset *> *)assets  complete:(UploadCompleteBlock)completeBlock
{
    
}

//将Image保存到缓存路径中
- (void)saveImage:(UIImage *)image toCachePath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:PHOTOCACHEPATH]) {
        
        NSLog(@"路径不存在, 创建路径");
        [fileManager createDirectoryAtPath:PHOTOCACHEPATH
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    } else {
        
        NSLog(@"路径存在");
    }
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:path atomically:YES];
}

- (void)saveVideoFromPath:(NSString *)videoPath toCachePath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:VIDEOCACHEPATH]) {
        
        NSLog(@"路径不存在, 创建路径");
        [fileManager createDirectoryAtPath:VIDEOCACHEPATH
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    } else {
        
        NSLog(@"路径存在");
    }
    
    NSError *error;
    [fileManager copyItemAtPath:videoPath toPath:path error:&error];
    if (error) {
        
        NSLog(@"文件保存到缓存失败");
    }
}

@end
