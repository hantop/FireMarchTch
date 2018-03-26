//
//  FMTBaseDataManager.h
//  FireMarchTch
//
//  Created by Joe.Pen on 20/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTBaseDataManager : NSObject
singleton_interface(FMTBaseDataManager)
@property (nonatomic) NSMutableDictionary *params;

@end
