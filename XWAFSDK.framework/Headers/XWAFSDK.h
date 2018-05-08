//
//  XWAFSDK.h
//  XWAFSDK
//
//  Created by Joe.Pen on 2017/4/18.
//  Copyright © 2017年 XWBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface XWAFSDK : NSObject

+ (instancetype)shareInstance;

/**
 *  初始化SDK，并返回TokenKey.只需调用一次。
 *
 *  @param appId 开发者在开放平台注册的AppAccessKey
 */
+ (NSString *)initWithAppID:(NSString *)appId;

/**
 *  上送设备指纹，在需要的上送的地方调用。
 *
 */
+ (void)postDeviceInfo;

@end
