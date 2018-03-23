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

#pragma mark- 静态数据变量声明
extern NSString *const kFMTAPIHttpScheme;
extern NSString *const kFMTAPIHost;
extern NSString *const kFMTAPILogin;
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
typedef void (^FMFailureBlock)(void);
typedef void (^FMGeneralBlock)(void);


#endif /* ValueType_h */
