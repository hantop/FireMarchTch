//
//  FMUploadManager.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/5/14.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMTImageUploadModel.h"

typedef void(^UploadCompleteBlock)(void);

@interface FMUploadManager : NSObject
singleton_interface(FMUploadManager)

@property (strong, nonatomic) NSMutableArray <FMTImageUploadModel *> *uploadPicModelArray;
@property (strong, nonatomic) NSMutableArray <FMTImageUploadModel *> *uploadVideoModelArray;

- (void)dealWithVideoPHAssets:(NSArray<PHAsset *> *)assets complete:(UploadCompleteBlock)completeBlock;
- (void)dealWithImagePHAssets:(NSArray<PHAsset *> *)assets complete:(UploadCompleteBlock)completeBlock; 

@end
