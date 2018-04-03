//
//  FMDeviceInfo.h
//  FireMarchTch
//
//  Created by Joe.Pen on 03/04/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDeviceInfo : NSObject
+ (NSDictionary *)XWGetDeviceInfo;
+ (NSDictionary *)getCurrentAppInfo;
@end
