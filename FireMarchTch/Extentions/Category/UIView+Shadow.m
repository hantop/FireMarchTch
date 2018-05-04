//
//  UIView+Shadow.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/24.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)addShadow{
    [self addShadowColor:[UIColor blackColor] offset:CGSizeMake(0, 5)];
}

- (void)addShadowColor:(UIColor *)color
{
    [self addShadowColor:color offset:CGSizeMake(0, 5)];
}

- (void)addShadowColor:(UIColor *)color offset:(CGSize)offset
{
    [self addShadowColor:color offset:offset edge:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)addShadowColor:(UIColor *)color offset:(CGSize)offset edge:(UIEdgeInsets)edgeInsets
{
    UIView * shadowView= [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor whiteColor];
    // 禁止将 AutoresizingMask 转换为 Constraints
    shadowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview insertSubview:shadowView belowSubview:self];
    // 添加 right 约束
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:shadowView attribute:NSLayoutAttributeRight multiplier:1.0 constant:edgeInsets.right];
    [self.superview addConstraint:rightConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:edgeInsets.left];
    [self.superview addConstraint:leftConstraint];
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:edgeInsets.top];
    [self.superview addConstraint:topConstraint];
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:edgeInsets.bottom];
    [self.superview addConstraint:bottomConstraint];
    shadowView.layer.shadowColor = color.CGColor;
    shadowView.layer.shadowOffset = offset;
    shadowView.layer.shadowOpacity = 0.5;
    shadowView.layer.shadowRadius = 10;
    shadowView.clipsToBounds = NO;
}

@end
