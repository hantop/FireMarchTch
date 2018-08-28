//
//  FMSetMyInfoViewController.h
//  FireMarchTch
//
//  Created by Joe.Pen on 04/04/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMViewController.h"

typedef NS_ENUM (NSInteger, FMSetMyInfoType)
{
    FMSetMyInfoTypeRegist = 0,
    FMSetMyInfoTypeUpdate
};

@interface FMSetMyInfoViewController : FMViewController
@property(assign) FMSetMyInfoType setMyInfoType;
@end
