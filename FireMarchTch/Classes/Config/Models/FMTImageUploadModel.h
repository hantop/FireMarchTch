//
//  FMTImageUploadModel.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/5/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTImageUploadModel : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSData *data;

// 总大小
@property (nonatomic, assign) int64_t totalSize;
// 总片数
@property (nonatomic, assign) NSInteger totalCount;
// 已上传片数
@property (nonatomic, assign) NSInteger uploadedCount;
// 上传所需参数
@property (nonatomic, copy) NSString *upToken;
// 上传状态标识, 记录是上传中还是暂停
@property (nonatomic, assign) BOOL isRunning;
// 缓存文件路径
@property (nonatomic, copy) NSString *filePath;
// 用来保存文件名使用
@property (nonatomic, copy) NSString *lastPathComponent;

// 以下属性用于给上传列表界面赋值
@property (nonatomic, assign) NSInteger docType;
@property (nonatomic, copy) NSString *title;
// 上传百分比
@property (nonatomic, assign) CGFloat uploadPercent;
+ (instancetype)modelWithAsset:(PHAsset *)asset;
@end
