//
//  XWAFSDK.h
//  XWAFSDK
//
//  Created by Joe.Pen on 2017/4/18.
//  Copyright © 2017年 XWBank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//新网开放平台各环境地址变量
UIKIT_EXTERN NSString *const XWAF_API;        // 生产环境
UIKIT_EXTERN NSString *const XWAF_UAT_A;      // A环境
UIKIT_EXTERN NSString *const XWAF_UAT_B;      // B环境
UIKIT_EXTERN NSString *const XWAF_UAT_C;      // C环境
UIKIT_EXTERN NSString *const XWAF_UAT_D;      // D环境
UIKIT_EXTERN NSString *const XWAF_UAT_E;      // E环境
UIKIT_EXTERN NSString *const XWAF_UAT_F;      // F环境
UIKIT_EXTERN NSString *const XWAF_UAT_G;      // G环境
UIKIT_EXTERN NSString *const XWAF_UAT_H;      // H环境
UIKIT_EXTERN NSString *const XWAF_UAT_I;      // I环境

@interface XWAFSDK : NSObject
/**
 *  初始化SDK，并返回TokenKey.只需调用一次。
 *
 *  @param appId 开发者在新网开放平台注册的AppAccessKey
 *  @param XWAF_URL 请求环境地址（参考“新网开放平台各环境地址变量”）
 */
+ (NSString *)initWithAppID:(NSString *)appId
                     andURL:(NSString *)XWAF_URL;

/**
 *  上送设备指纹，在需要的上送的地方调用。
 *  如初始化失败，则会报错（@“XW设备指纹初始化失败，请重新初始化”）
 */
+ (void)postDeviceInfo;

@end
