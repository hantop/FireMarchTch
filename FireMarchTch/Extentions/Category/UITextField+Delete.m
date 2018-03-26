//
//  UITextFiled+Delete.m
//  FireMarchTch
//
//  Created by Joe.Pen on 26/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "UITextField+Delete.h"
#import <objc/runtime.h>
NSString * const FMTextFieldDidDeleteBackwardNotification = @"com.joe.textfield.deleteback.notification";

@implementation UITextField(Delete)


+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(FM_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)FM_deleteBackward {
    [self FM_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <FMTextFieldDelegate> delegate  = (id<FMTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FMTextFieldDidDeleteBackwardNotification object:self];
}

@end
