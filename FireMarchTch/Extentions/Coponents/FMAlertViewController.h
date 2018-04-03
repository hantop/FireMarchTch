//
//  CZJSBAlertView.h
//  CZJShop
//
//  Created by Joe.Pen on 2/24/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZJAlertView.h"

@interface FMAlertViewController : UIViewController
@property (nonatomic, strong)CZJAlertView* popView;
- (void)setConfirmItemHandle:(FMGeneralBlock)basicBlock;
@end
