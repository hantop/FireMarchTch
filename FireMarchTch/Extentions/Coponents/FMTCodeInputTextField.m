//
//  FMTCodeInputTextField.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTCodeInputTextField.h"

@interface FMTCodeInputTextField ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *thrTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *thrButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;


@property (strong, nonatomic) NSMutableArray *fieldsAry;
@property (strong, nonatomic) NSMutableArray *buttonAry;
@property (strong, nonatomic) NSMutableArray *codeStrAry;
@end

@implementation FMTCodeInputTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initTextFields];
    [self updateTextField];
    // Initialization code
}

- (void)initTextFields
{
    _fieldsAry = [NSMutableArray arrayWithObjects:_oneTextField,_twoTextField,_thrTextField,_fourTextField, nil];
    _buttonAry = [NSMutableArray arrayWithObjects:_oneButton,_twoButton,_thrButton,_fourButton, nil];
    for (UITextField *textField in _fieldsAry) {
        textField.delegate = self;
        textField.font = [UIFont fontWithName:@"FZLTXHK" size:22];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    [_oneTextField becomeFirstResponder];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DLog(@"string:%@, text:%@,tag:%ld",string,textField.text,textField.tag);
    
    if (string.length == 0) {
        if (textField.tag > 1
            && ((UITextField *)_fieldsAry[textField.tag -2]).hasText
            && !textField.hasText)
        {
            [_fieldsAry[textField.tag - 1] resignFirstResponder];
            [_fieldsAry[textField.tag - 2] becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    
    if (!textField.hasText)
        return YES;
    
    if (![textField.text isEqualToString:string])
        textField.text = string;
    return YES;
    
    
    return NO;
}

- (void)textFieldChanged:(UITextField *)textField {
    DLog(@"text:%@,tag:%ld",textField.text,textField.tag);
    if (textField.text.length > 1)
    {
        textField.text = [textField.text substringFromIndex:1];
    }
    if (textField.tag < _fieldsAry.count && ![textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag] becomeFirstResponder];
    }
    if (textField.tag > 1 && [textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag - 1] resignFirstResponder];
        [_fieldsAry[textField.tag - 2] becomeFirstResponder];
    }
    if (textField.tag > 1 && [textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag - 2] becomeFirstResponder];
    }
    [self updateTextField];
}

- (void)updateTextField
{
    NSInteger count = 0;
    NSMutableArray *codeAry = [NSMutableArray array];
    
    for (UITextField *textField in _fieldsAry) {
        ((UIButton *)_buttonAry[textField.tag - 1]).hidden = NO;
        if (textField.hasText) {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = RGB(255, 100, 0).CGColor;
            textField.textColor = RGB(255, 100, 0);
            DLog(@"%@",textField.text);
            [codeAry addObject:textField.text];
            count++;
        }
        else
        {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = RGB(216, 216, 216).CGColor;
        }
        
    }
    
    if (count < _buttonAry.count) {
        ((UIButton *)_buttonAry[count]).hidden = YES;
    }
    
    if (count == _fieldsAry.count && [self.delegate respondsToSelector:@selector(codeInputTextFieldOverWithString:)]) {
        [self.delegate codeInputTextFieldOverWithString:[codeAry componentsJoinedByString:@""]];
    }
}



- (void)resetCodeInputTextField
{
    for (UITextField *textField in _fieldsAry) {
        textField.text = @"";
    }
    [self updateTextField];
    [_oneTextField becomeFirstResponder];
}

@end
