//
//  FMTUnLockViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 21/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUnLockViewController.h"

@interface FMTUnLockViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *thrTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourTextField;

@property (strong, nonatomic) NSMutableArray *fieldsAry;
@end

@implementation FMTUnLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fieldsAry = [NSMutableArray arrayWithObjects:_oneTextField,_twoTextField,_thrTextField,_fourTextField, nil];
    for (UITextField *textField in _fieldsAry) {
        textField.delegate = self;
        textField.font = [UIFont fontWithName:@"FZLTXHK" size:22];
//        textField.layer.borderWidth = 0.7f;
//        textField.layer.borderColor= RGB(216, 216, 216).CGColor;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        textField.leftView.userInteractionEnabled = NO;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    [_oneTextField becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    for (UITextField *textField in _fieldsAry) {
        if ( textField.hasText) {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = RGB(255, 100, 0).CGColor;
            textField.textColor = RGB(255, 100, 0);
        }
        else
        {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = RGB(216, 216, 216).CGColor;
        }
        
    }
}

@end
