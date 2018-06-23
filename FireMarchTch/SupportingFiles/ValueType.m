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
NSString *const kFMTAPIHost = @"http://118.126.113.252/";
NSString *const kFMTAPILogin = @"auth/login";
NSString *const kFMTAPIRegister = @"auth/register";
NSString *const kFMTAPICheckInviteCode = @"auth/inviteCode";
NSString *const kFMTAPICheckUserFirst = @"auth/checkUserFirst";
NSString *const kFMTAPIForgotPWD = @"auth/forgetPassword";
NSString *const kFMTAPISendSMSCode = @"auth/sendSmsCode";
NSString *const kFMTAPICheckSMSCode = @"auth/smsCodeValid";
NSString *const kFMTAPIFileAuth = @"fileserv/auth";
NSString *const kFMTAPIUploadImage = @"file/{fileId}";
NSString *const kFMTAPISetBasicInfo = @"";


#pragma mark- 字符串定义
//token key值定义
NSString *const kUserDefaultAccessToken = @"token";
//
NSString *const kUserDefaultAccessCode = @"accessCode";
NSString *const kUserDefaultIsLogin = @"isLogin";
//以天为间隔时间
NSString *const kUserDefaultTimeDay = @"userdefaultTimeDay";
//以分钟为间隔时间
NSString *const kUserDefaultTimeMin = @"userdefaultTimeMin";
//定位间隔时间
NSString *const kUserDefaultTimeMinLocation = @"userdefaultTimeMinLocation";
NSString *const kUserDefaultRandomCode = @"userdefaultRandomCode";
//邀请码是否验证过了
NSString *const kUserDefaultInviteCodeCheck = @"invitecodeIsChecked";

#pragma mark- 通知类定义
//新消息通知
NSString *const kFMNotifiLoginSuccess = @"loginSuccess";
NSString *const kFMNotifiRefreshOrderlist = @"refreshOrderListNotify";
