//
//  FMTRegTopView.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/18.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYLabel.h>
#import "MMLabel.h"

@interface FMTRegTopView : UIView
@property (strong, nonatomic) MMLabel *bigTitleLabel;
@property (strong, nonatomic) YYLabel *subTitleLabel;
@property (strong, nonatomic) UIImageView *topLogoImageView;

- (void)updateHeight;
@end
