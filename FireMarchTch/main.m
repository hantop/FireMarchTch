//
//  main.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/3/12.
//  Copyright © 2018年 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime StartTime;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        StartTime = CFAbsoluteTimeGetCurrent();
        NSLog(@"Begin APP");
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
