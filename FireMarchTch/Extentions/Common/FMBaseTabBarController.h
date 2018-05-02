//
//  FMBaseTabBarController.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/26.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBaseTabBarController : UITabBarController<UITabBarControllerDelegate>
{
    //最近一次选择的Index
    NSUInteger _lastSelectedIndex;
}
@property(readonly, nonatomic) NSUInteger lastSelectedIndex;

@end
