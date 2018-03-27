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
extern NSString *const kFMTAPIHttpScheme;
extern NSString *const kFMTAPIHost;
extern NSString *const kFMTAPILogin;
extern NSString *const kFMTAPIRegister;
extern NSString *const kFMTAPICheckInviteCode;
extern NSString *const kFMTAPICheckUserFirst;
extern NSString *const kFMTAPIForgotPWD;
extern NSString *const kFMTAPISendSMSCode;
extern NSString *const kFMTAPICheckSMSCode;



#pragma mark-
extern NSString *const kFMTAccessToken;
extern NSString *const kFMTAccessCode;




extern NSString *const kUserDefaultTimeDay;
extern NSString *const kUserDefaultTimeMin;
extern NSString *const kUserDefaultTimeMinLocation;
extern NSString *const kUserDefaultRandomCode;


#pragma mark- 枚举数据声明



#pragma mark-
typedef void (^FMBasicBlock)(void);
typedef void (^FMButtonBlock)(UIButton* button);
typedef void (^FMSuccessBlock)(id json);
typedef void (^FMFailureBlock)(NSError *error);
typedef void (^FMGeneralBlock)(void);


#endif /* ValueType_h */
