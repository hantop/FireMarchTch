//
//  FMModel.h
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 XWBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMModel : NSObject

@end

@interface FMDateTime : NSObject
@property (strong, nonatomic) NSString* day;
@property (strong, nonatomic) NSString*  hour;
@property (strong, nonatomic) NSString*  minute;
@property (strong, nonatomic) NSString*  second;
@end
