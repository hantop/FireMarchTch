//
//  UINavigationBar+BackgroundColor.m
//  FireMarchTch
//
//  Created by Joe.Pen on 23/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"

@implementation UINavigationBar (BackgroundColor)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    NSArray *view  = self.subviews;
    UINavigationBar* barView = [view firstObject];
    NSArray *view2  = barView.subviews;
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        // insert an overlay into the view hierarchy
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:self.overlay atIndex:0];
        
        NSArray *view3  = self.subviews;
        DLog(@"%@",view3);
    }
    [self sendSubviewToBack:self.overlay];
    self.overlay.userInteractionEnabled = NO;
    self.overlay.backgroundColor = backgroundColor;
}

@end
