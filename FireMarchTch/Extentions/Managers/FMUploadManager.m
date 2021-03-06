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

#define RootFileCache @""

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
        NSTimeInterval duration = obj.duration;

        
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:obj];
    
        PHAssetResource *resource;
        
        for (PHAssetResource *assetRes in assetResources) {
            
            if (assetRes.type == PHAssetResourceTypePairedVideo ||
                
                assetRes.type == PHAssetResourceTypeVideo) {
                
                resource = assetRes;
                
            }
            
        }
        NSString * fileName;
        
        if (resource.originalFilename) {
            
            fileName = resource.originalFilename;
            NSString *id = resource.assetLocalIdentifier;
        }
        
        if (obj.mediaType == PHAssetMediaTypeVideo ||
            obj.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            
            options.version = PHImageRequestOptionsVersionCurrent;
            
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            
//            NSString *savePath =  [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
//
//            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:savePath] options:nil completionHandler:^(NSError * _Nullable error) {
//            }
            
        }
        
//        [ZLPhotoManager requestOriginalImageDataForAsset:obj completion:^(NSData * data, NSDictionary *info) {
//            FMTImageUploadModel *model = [FMTImageUploadModel new];
//            model.data = data;
//            model.totalSize = data.length;
//            TICK;
//            NSString *path = [FMUtils writeToCacheVideo:data appendNameString:@"video.mov"];
//            NSDictionary *dict = [self getVideoInfoWithSourcePath:path];
//            TOCK;
//            if (completeBlock) {
//                completeBlock();
//            }
//            DLog(@"大小：%lu, 路径：%d, %@",data.length,obj.duration, dict);
//        }];

    }];
    
    
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    options.version = PHImageRequestOptionsVersionCurrent;
    
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    [manager requestExportSessionForVideo:asset options:options exportPreset:AVAssetExportPresetMediumQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info)
     
     NSString *savePath = [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
     
     exportSession.outputURL = [NSURL fileURLWithPath:savePath];
     
     exportSession.shouldOptimizeForNetworkUse = NO;
     
     exportSession.outputFileType = AVFileTypeMPEG4;
     
     [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exportSession status]) {
                
            case AVAssetExportSessionStatusFailed:
                
            {
                
                if (failure) {
                    
                    NSError *e = [exportSession error];
                    
                    NSLog(@"%@",e);
                    
                    failure([[exportSession error] localizedDescription]);
                    
                }
                
                break;
                
            }
                
            case AVAssetExportSessionStatusCancelled:
                
            {
                
                if (cancell) {
                    
                    cancell();
                    
                }
                
                break;
                
            }
                
            case AVAssetExportSessionStatusCompleted:
                
            {
                
                if (result) {
                    
                    result(savePath,[savePath lastPathComponent]);
                    
                }
                
                break;
                
            }
                
            default:
                
                break;
                
        }
        
    } ];
     
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

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
}
        


+(NSString *)rootDirDoc{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *rootDir = [documentsDirectory stringByAppendingPathComponent:RootFileCache];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return rootDir;
    
}

//获取Library目录

+(NSString *)rootDirLib{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *libraryDirectory = [paths objectAtIndex:0];
    
    NSString *rootDir = [libraryDirectory stringByAppendingPathComponent:RootFileCache];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return rootDir;
    
}

//获取Cache目录

+(NSString *)rootDirCache{
    
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachePath = [cacPath objectAtIndex:0];
    
    NSString *rootDir = [cachePath stringByAppendingPathComponent:RootFileCache];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return rootDir;
    
}

//获取Tmp目录

+(NSString *)rootDirTmp{
    
    NSString *tmpDirectory = NSTemporaryDirectory();
    
    NSString *rootDir = [tmpDirectory stringByAppendingPathComponent:RootFileCache];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    return rootDir;
    
}

+(NSString *)getDir:(NSString *)dirName rootDir:(NSString *)rootDir{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = false;
    
    NSString *dirPath = [rootDir stringByAppendingPathComponent:dirName];
    
    BOOL isDirExist = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
        
    {
        
        BOOL createDir =  [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];;
        
        if(!createDir){
            
            //            dirPath = nil;
            
        }
        
    }
    
    return dirPath;
    
}

+(NSString *)createPathWithFileName:(NSString *)fileName direName:(NSString *)dirName rootDir:(NSString *)rootDir{
    
    NSString *targetDir = [self getDir:dirName rootDir:rootDir];
    
    return [targetDir stringByAppendingPathComponent:[URLCodeUtils decodeString:fileName]];
    
}

+(NSString *)createPathWithFileName:(NSString *)fileName rootDir:(NSString *)rootDir{
    
    return [self createPathWithFileName:fileName direName:DefautlDir rootDir:rootDir];
    
}

+(NSString *)createPathWithFileName:(NSString *)fileName{
    
    return [self createPathWithFileName:fileName direName:DefautlDir rootDir:[self rootDirCache]];
    
}

+(void)enumeratorFiles:(NSString *)path block:(void(^)(NSString *path))block{
    
    // 1.判断文件还是目录
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    
    if (isExist) {
        
        // 2. 判断是不是目录
        
        if (isDir) {
            
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            
            NSString * subPath = nil;
            
            for (NSString * str in dirArray) {
                
                subPath  = [path stringByAppendingPathComponent:str];
                
                BOOL issubDir = NO;
                
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                
                [self enumeratorFiles:subPath  block:block];
                
            }
            
        }else{
            
            if (block) {
                
                block(path);
                
            }
            
        }
        
    }
    
}

+(NSMutableArray *)filePathsWithDirPath:(NSString *)dirPath{
    
    NSMutableArray *filePaths = [NSMutableArray new];
    
    if (dirPath) {
        
        [self enumeratorFiles:dirPath block:^(NSString *path) {
            
            [filePaths addObject:path];
            
        }];
        
    }
    
    return filePaths;
    
}

+(NSMutableArray *)filePathsWithDirName:(NSString *)dirName rootDir:(NSString *)rootDir{
    
    NSMutableArray *filePaths = [NSMutableArray new];
    
    NSString *dirPath = [self getDir:dirName rootDir:rootDir];
    
    if (dirPath) {
        
        [self enumeratorFiles:dirPath block:^(NSString *path) {
            
            [filePaths addObject:path];
            
        }];
        
    }
    
    return filePaths;
    
}

+(NSString *)saveFile:(NSData *)tempData WithName:(NSString *)fileName

{
    
    NSString* fullPathToFile = [self createPathWithFileName:fileName];
    
    [self writeData:tempData toPath:fullPathToFile];
    
    return fullPathToFile;
    
}

+(void)saveFile:(NSData *)data savePath:(NSString *)filePath{
    
    [self writeData:data toPath:filePath];
    
}

+(NSString *)saveFile:(NSData *)tempData name:(NSString *)fileName rootDir:(NSString *)rootDir

{
    
    NSString* fullPathToFile = [self createPathWithFileName:fileName rootDir:rootDir];
    
    [self writeData:tempData toPath:fullPathToFile];
    
    return fullPathToFile;
    
}

+(NSData *)dataForPath:(NSString *)path{
    
    @synchronized (self) {
        
        return [NSData dataWithContentsOfFile:path options:0 error:NULL];
        
    }
    
}

+(void)writeData:(NSData*)data toPath:(NSString *)path {
    
    @synchronized (self) {
        
        [data writeToFile:path atomically:YES];
        
    }
    
}

+(void)deleteDataAtPath:(NSString *)path {
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
}

+(void)deleteWithFileName:(NSString *)fileName rootDir:(NSString *)rootDir{
    
    NSFileManager *defaultManager;
    
    defaultManager = [NSFileManager defaultManager];
    
    NSArray *contents = [defaultManager contentsOfDirectoryAtPath:rootDir error:NULL];
    
    NSEnumerator *e = [contents objectEnumerator];
    
    NSString *filename;
    
    NSArray *tempArray= [fileName componentsSeparatedByString:@"/"];
    
    NSString * distinationFileName;
    
    if ([tempArray count]>=2) {
        
        distinationFileName=[tempArray objectAtIndex:[tempArray count]-1];
        
    }else{
        
        distinationFileName=fileName;
        
    }
    
    while ((filename = [e nextObject])) {
        
        if ([filename isEqualToString:distinationFileName]) {
            
            [defaultManager removeItemAtPath:[rootDir stringByAppendingPathComponent:filename] error:NULL];
            
            break;
            
        }
        
    }
    
}

+(void)deleteWithFilePath:(NSString *)filePath{
    
    if (filePath) {
        
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        
        [defaultManager removeItemAtPath:filePath error:NULL];
        
    }
    
}

+(void)clearCacheWithDirPath:(NSString*)dirPath{
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    BOOL isDir = false;
    
    BOOL isDirExist = [defaultManager fileExistsAtPath:dirPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
        
    {
        
        return;
        
    }
    
    NSArray *contents = [defaultManager contentsOfDirectoryAtPath:dirPath error:NULL];
    
    for (NSString *path in contents) {
        
        [defaultManager removeItemAtPath:[dirPath stringByAppendingPathComponent:path] error:NULL];
        
    }
    
}

+(void)clearCache{
    
    NSString* documentsDirectory = [self rootDirCache];
    
    NSFileManager *defaultManager;
    
    defaultManager = [NSFileManager defaultManager];
    
    NSArray *contents = [defaultManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    for (NSString *path in contents) {
        
        [defaultManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:path] error:NULL];
        
    }
    
}

+(BOOL)isFileExit:(NSString*)filePath{
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    BOOL isDir = false;
    
    BOOL isDirExist = [defaultManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    return isDirExist;
    
}

+(NSDate *) getFileCreateTime:(NSString*) path

{
    
    NSDate *date;
    
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    
    if([filemanager fileExistsAtPath:path]){
        
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        
        if ([attributes objectForKey:NSFileCreationDate])
            
        {
            
            date = [attributes objectForKey:NSFileCreationDate];
            
        }
        
    }
    
    return  date;
    
}

+(NSInteger) getFileSize:(NSString*) path

{
    
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    
    if([filemanager fileExistsAtPath:path]){
        
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        
        NSNumber *theFileSize;
        
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            
            return  [theFileSize intValue];
        
        else
            
            return -1;
        
    }
    
    else
        
    {
        
        return -1;
        
    }
    
}

+ (float) getVideoDuration:(NSURL*) URL

{
    
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                          
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    float second = 0;
    
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    
    return second;
    
}

+(void)asyncConvertMovToMp4VideoWithVideoURL:(NSURL *)videoURL presetName:(NSString *)presetName failure:(void (^)(NSString *))failure success:(void (^)(NSString *))success cancell:(void (^)())cancell{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *fileName = [[formater stringFromDate:[NSDate date]] stringByAppendingString:@".mp4"];
    
    [self asyncConvertMovToMp4VideoWithVideoURL:videoURL fileName:fileName fileDir:DefautlDir rootDir:[self rootDirCache] presetName:presetName failure:failure success:success cancell:cancell];
    
}

+(void)asyncConvertMovToMp4VideoWithVideoURL:(NSURL *)videoURL fileName:(NSString *)fileName fileDir:(NSString *)fileDir rootDir:(NSString *)rootDir presetName:(NSString *)presetName failure:(void (^)(NSString *))failure success:(void (^)(NSString *))success cancell:(void (^)())cancell{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:presetName]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:presetName];
        
        NSString *path = [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
        
        exportSession.outputURL = [NSURL fileURLWithPath:path];
        
        exportSession.shouldOptimizeForNetworkUse = NO;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    
                {
                    
                    if (failure) {
                        
                        NSError *e = [exportSession error];
                        
                        NSLog(@"%@",e);
                        
                        failure([[exportSession error] localizedDescription]);
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    
                {
                    
                    if (cancell) {
                        
                        cancell();
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCompleted:
                    
                {
                    
                    if (success) {
                        
                        success(path);
                        
                    }
                    
                    break;
                    
                }
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
    }else{
        
        if (failure) {
            
            failure([NSString stringWithFormat:@"not exit %@ resource",presetName]);
            
        }
        
    }
    
}

+(void)cafToMP3:(NSString *)mp3FilePath cafFilePath:(NSString *)cafFilePath sampleRate:(int)sampleRate{
    
    @try {
        
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        
        fseek(pcm, 4*1024, SEEK_CUR);                                  //skip file header
        
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        
        const int MP3_SIZE = 8192;
        
        short int pcm_buffer[PCM_SIZE*2];
        
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        
        lame_set_in_samplerate(lame, sampleRate);
        
        lame_set_VBR(lame, vbr_default);
        
        lame_init_params(lame);
        
        do {
            
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            
            if (read == 0)
                
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            
            else
                
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        
        fclose(mp3);
        
        fclose(pcm);
        
    }
    
    @catch (NSException *exception) {
        
        NSLog(@"%@",[exception description]);
        
    }
    
    @finally {
        
        [self deleteDataAtPath:cafFilePath];
        
    }
    
}

+(void)getImagePathFromPHAsset:(PHAsset *)asset fileName:(NSString *)fileName fileDir:(NSString *)fileDir rootDir:(NSString *)rootDir complete:(void (^)(NSString *, NSString *))result{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // 同步获得图片, 只会返回1张图片
    
    options.synchronous = YES;
    
    //    options.version = PHImageRequestOptionsVersionOriginal;
    
    //    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //
    
    CGSize size = CGSizeMake(asset.pixelWidth,asset.pixelHeight);
    
    __block NSString *savePath =  [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        NSData *data = UIImageJPEGRepresentation(result, 0.5f);
        
        [FileUtils saveFile:data savePath:savePath];
        
    }];
    
    if (result) {
        
        result(savePath,fileName);
        
    }
    
}

+(void)getVideoPathFromPHAsset:(PHAsset *)asset fileName:(NSString *)fileName fileDir:(NSString *)fileDir rootDir:(NSString *)rootDir complete:(void (^)(NSString *, NSString *))result failure:(void (^)(NSString *))failure cancell:(void (^)())cancell{
    
    //    if(IOS9_OR_LATER){
    
    //
    
    //        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    
    //        PHAssetResource *resource;
    
    //
    
    //        for (PHAssetResource *assetRes in assetResources) {
    
    //            if (assetRes.type == PHAssetResourceTypePairedVideo ||
    
    //                assetRes.type == PHAssetResourceTypeVideo) {
    
    //                resource = assetRes;
    
    //            }
    
    //        }
    
    //
    
    ////        if (resource.originalFilename) {
    
    ////
    
    ////            fileName = resource.originalFilename;
    
    ////        }
    
    //
    
    //        if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
    
    ////            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    ////            options.version = PHImageRequestOptionsVersionCurrent;
    
    ////            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //
    
    //            NSString *savePath =  [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
    
    //
    
    //            [[PHAssetResourceManager defaultManager]writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:savePath] options:nil completionHandler:^(NSError * _Nullable error) {
    
    //
    
    //                if (!error&&result) {
    
    //
    
    //                    result(savePath,[savePath lastPathComponent]);
    
    //
    
    //                }else{
    
    //
    
    //                    if (cancell) {
    
    //
    
    //                        cancell();
    
    //                    }
    
    //                }
    
    //            }];
    
    //
    
    //        }else{
    
    //
    
    //            if (cancell) {
    
    //
    
    //                cancell();
    
    //            }
    
    //        }
    
    //
    
    //
    
    //    }else{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    options.version = PHImageRequestOptionsVersionCurrent;
    
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    [manager requestExportSessionForVideo:asset options:options exportPreset:AVAssetExportPresetMediumQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        
        NSString *savePath = [self createPathWithFileName:fileName direName:fileDir rootDir:rootDir];
        
        [FileUtils deleteDataAtPath:savePath];
        
        exportSession.outputURL = [NSURL fileURLWithPath:savePath];
        
        exportSession.shouldOptimizeForNetworkUse = NO;
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    
                {
                    
                    if (failure) {
                        
                        NSError *e = [exportSession error];
                        
                        NSLog(@"%@",e);
                        
                        failure([[exportSession error] localizedDescription]);
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    
                {
                    
                    if (cancell) {
                        
                        cancell();
                        
                    }
                    
                    break;
                    
                }
                    
                case AVAssetExportSessionStatusCompleted:
                    
                {
                    
                    if (result) {
                        
                        result(savePath,[savePath lastPathComponent]);
                        
                    }
                    
                    break;
                    
                }
                    
                default:
                    
                    break;
                    
            }
            
        }];
        
    }];
    
    //    }
    
}


    
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        


@end
