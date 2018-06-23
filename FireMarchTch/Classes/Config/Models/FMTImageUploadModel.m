//
//  FMTImageUploadModel.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/5/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTImageUploadModel.h"

@implementation FMTImageUploadModel
+ (instancetype)modelWithAsset:(PHAsset *)asset
{
    FMTImageUploadModel *model = [[FMTImageUploadModel alloc] init];
//    model.asset = asset;
//    model.type = type;
//    model.duration = duration;
//    model.selected = NO;
    return model;
}
@end
