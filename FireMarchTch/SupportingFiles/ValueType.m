//
//  ValueType.m
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//


#import "ValueType.h"

#pragma mark- 接口请求地址
NSString *const kFMTAPIHttpScheme = @"https";
NSString *const kFMTAPIHost = @"https://dev.cucole.cc/";
NSString *const kFMTAPILogin = @"auth/login";
NSString *const kFMTAPIRegister = @"auth/register";
NSString *const kFMTAPICheckInviteCode = @"auth/inviteCode";
NSString *const kFMTAPICheckUserFirst = @"auth/checkUserFirst";
NSString *const kFMTAPIForgotPWD = @"auth/forgetPassword";
NSString *const kFMTAPISendSMSCode = @"auth/sendSmsCode";
NSString *const kFMTAPICheckSMSCode = @"auth/smsCodeValid";
NSString *const kFMTAPIUploadImage = @"";


#pragma mark- 字符串定义
//token key值定义
NSString *const kFMTAccessToken = @"token";
//
NSString *const kFMTAccessCode = @"accessCode";
//以天为间隔时间
NSString *const kUserDefaultTimeDay = @"userdefaultTimeDay";
//以分钟为间隔时间
NSString *const kUserDefaultTimeMin = @"userdefaultTimeMin";
//定位间隔时间
NSString *const kUserDefaultTimeMinLocation = @"userdefaultTimeMinLocation";
NSString *const kUserDefaultRandomCode = @"userdefaultRandomCode";
