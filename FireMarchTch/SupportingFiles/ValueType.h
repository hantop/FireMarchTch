//
//  ValueType.h
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef ValueType_h
#define ValueType_h

#pragma mark- 接口名称静态变量申明
UIKIT_EXTERN NSString *const kFMTAPIHttpScheme;
UIKIT_EXTERN NSString *const kFMTAPIHost;
UIKIT_EXTERN NSString *const kFMTAPILogin;
UIKIT_EXTERN NSString *const kFMTAPIRegister;
UIKIT_EXTERN NSString *const kFMTAPICheckInviteCode;
UIKIT_EXTERN NSString *const kFMTAPICheckUserFirst;
UIKIT_EXTERN NSString *const kFMTAPIForgotPWD;
UIKIT_EXTERN NSString *const kFMTAPISendSMSCode;
UIKIT_EXTERN NSString *const kFMTAPICheckSMSCode;
UIKIT_EXTERN NSString *const kFMTAPIUploadImage;




#pragma mark-
UIKIT_EXTERN NSString *const kFMTAccessToken;
UIKIT_EXTERN NSString *const kFMTAccessCode;




UIKIT_EXTERN NSString *const kUserDefaultTimeDay;
UIKIT_EXTERN NSString *const kUserDefaultTimeMin;
UIKIT_EXTERN NSString *const kUserDefaultTimeMinLocation;
UIKIT_EXTERN NSString *const kUserDefaultRandomCode;


#pragma mark- 枚举数据声明
struct CZJMargin {
    CGFloat horisideMargin;
    CGFloat vertiMiddleMargin;
};
typedef struct CZJMargin CZJMargin;

CG_INLINE CZJMargin CZJMarginMake(CGFloat horisideMargin, CGFloat vertiMiddleMargin)
{
    CZJMargin margin;
    margin.horisideMargin = horisideMargin;
    margin.vertiMiddleMargin = vertiMiddleMargin;
    return margin;
}


#pragma mark-
typedef void (^FMBasicBlock)(void);
typedef void (^FMButtonBlock)(UIButton* button);
typedef void (^FMProgressBlock)(NSProgress* progress);
typedef void (^FMSuccessBlock)(id json);
typedef void (^FMFailureBlock)(NSError *error);
typedef void (^FMGeneralBlock)(void);


#endif /* ValueType_h */
