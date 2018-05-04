//
//  UIView+Shadow.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/24.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Shadow)
- (void)addShadow;
- (void)addShadowColor:(UIColor *)color;
- (void)addShadowColor:(UIColor *)color offset:(CGSize)offset;
- (void)addShadowColor:(UIColor *)color offset:(CGSize)offset edge:(UIEdgeInsets)edgeInsets;
@end
