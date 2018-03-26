//
//  UITextFiled+Delete.h
//  FireMarchTch
//
//  Created by Joe.Pen on 26/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FMTextFieldDidDeleteBackwardNotification;

@protocol FMTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end

@interface UITextField (Delete)

@end
