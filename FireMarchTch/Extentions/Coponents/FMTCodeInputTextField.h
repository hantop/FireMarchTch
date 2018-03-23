//
//  FMTCodeInputTextField.h
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMTCodeInputTextFieldDelegate <NSObject>
- (void)codeInputTextFieldOverWithString:(NSString *)codeStr;
@end

@interface FMTCodeInputTextField : UITableViewCell
@property (weak, nonatomic) id<FMTCodeInputTextFieldDelegate> delegate;

- (void)resetCodeInputTextField;
@end
