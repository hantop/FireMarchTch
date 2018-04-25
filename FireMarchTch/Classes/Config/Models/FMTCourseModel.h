//
//  FMTCourseModel.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/24.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTCourseModel : NSObject
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSArray<NSString *> *courseItems;
@property (strong, nonatomic) NSString *courseNumber;
@property (strong, nonatomic) NSString *courseDuration;
@property (strong, nonatomic) NSString *courseFee;
@end
