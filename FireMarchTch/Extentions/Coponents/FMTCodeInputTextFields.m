//
//  FMTCodeInputTextField.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTCodeInputTextFields.h"
#import "UITextField+Delete.h"

@implementation FMTCodeInputTextFieldsConfig
- (id)init
{
    return [self initWithCodeType:FMTCodeTypeShort];
}

- (instancetype)initWithCodeType:(FMTCodeType)type
{
    if (self = [super init]) {
        self.codeType = type;
        self.keyboardType = _codeType == FMTCodeTypeShort ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
        
        self.tintColor = [UIColor colorWithRed:250/255.0f green:100/255.0f blue:0/255.0f alpha:1];
        self.originBoderColor = [UIColor colorWithRed:216/255.0f green:216/255.0f blue:216/255.0f alpha: 1];
        self.textFieldSize = CGSizeMake(50, 50);
    }
    return self;
}
@end


@interface FMTCodeInputTextFields ()<UITextFieldDelegate,  FMTextFieldDelegate>
@property (strong, nonatomic) NSMutableArray<UITextField *> *fieldsAry;
@property (strong, nonatomic) NSMutableArray<UIButton *> *buttonAry;
@property (strong, nonatomic) NSMutableArray *codeStrAry;
@end

@implementation FMTCodeInputTextFields

- (instancetype)initWithConfiguration: (FMTCodeInputTextFieldsConfig *)configuration delegate: (id<FMTCodeInputTextFieldsDelegate>)delegate
{
    if (self = [super init]) {
        self.configuration = configuration;
        self.delegate = delegate;
        [self setWidth:[[UIScreen mainScreen] bounds].size.width];
        [self initTextFields];
        [self updateTextField];
    }
    return self;
}


- (void)initTextFields
{
    NSInteger count = (_configuration.codeType == FMTCodeTypeShort) ? 4 : 6;
    NSInteger leading = (_configuration.codeType == FMTCodeTypeShort) ? 40 : 20;
    NSInteger width = self.bounds.size.width;
    float margin = (float)(width - count * _configuration.textFieldSize.width - 2 * leading)/(count - 1);
    _fieldsAry = [NSMutableArray arrayWithCapacity:count];
    _buttonAry = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        UITextField *textField = [self createTextField];
        textField.tag = i;
        CGRect rect = CGRectMake(leading + (float)i*(_configuration.textFieldSize.width + margin), 5, _configuration.textFieldSize.width, _configuration.textFieldSize.height);
        textField.frame = rect;
        [self addSubview:textField];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = rect;
        [self addSubview:button];
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_fieldsAry addObject:textField];
        [_buttonAry addObject:button];
    }
    
    [_fieldsAry.firstObject becomeFirstResponder];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        if (textField.tag > 0
            && ((UITextField *)_fieldsAry[textField.tag - 1]).hasText
            && !textField.hasText)
        {
            [_fieldsAry[textField.tag] resignFirstResponder];
            [_fieldsAry[textField.tag - 1] becomeFirstResponder];
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

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    DLog(@"%@, %ld",textField.text, textField.tag);
    [self textFieldChanged:textField];
}

- (void)textFieldChanged:(UITextField *)textField {
    if (textField.text.length > 1)
    {
        textField.text = [textField.text substringFromIndex:1];
    }
    if (textField.tag < _fieldsAry.count - 1 && ![textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag + 1] becomeFirstResponder];
    }
    if (textField.tag > 0 && [textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag] resignFirstResponder];
        [_fieldsAry[textField.tag - 1] becomeFirstResponder];
    }
    if (textField.tag > 0 && [textField.text isEqualToString:@""]) {
        [_fieldsAry[textField.tag - 1] becomeFirstResponder];
    }
    [self updateTextField];
}

- (void)updateTextField
{
    NSInteger count = 0;
    NSMutableArray *codeAry = [NSMutableArray array];
    
    for (UITextField *textField in _fieldsAry) {
        ((UIButton *)_buttonAry[textField.tag]).hidden = NO;
        if (textField.hasText) {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = _configuration.tintColor.CGColor;
            textField.textColor = _configuration.tintColor;
            [codeAry addObject:textField.text];
            count++;
        }
        else
        {
            textField.layer.borderWidth = 0.7f;
            textField.layer.borderColor = _configuration.originBoderColor.CGColor;
        }
        
    }
    
    if (count < _buttonAry.count) {
        ((UIButton *)_buttonAry[count]).hidden = YES;
        ((UITextField*)_fieldsAry[count]).layer.borderColor = _configuration.tintColor.CGColor;
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
    [_fieldsAry.firstObject becomeFirstResponder];
}


- (UITextField *)createTextField
{
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, 130, 30)];
    //边框样式一定要选None
    text.borderStyle = UITextBorderStyleNone;
    text.secureTextEntry = FMTCodeTypeShort == _configuration.codeType;
    //
    text.tintColor = _configuration.tintColor;
    text.layer.borderColor = _configuration.tintColor.CGColor;
    //
    text.textAlignment = NSTextAlignmentCenter;
    //
    text.keyboardType = _configuration.keyboardType;
    //
    text.font = [UIFont fontWithName:@"FZLTXHK" size:22];
    //
    text.delegate = self;
    
    //
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //
//    text.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeading;
    //
    text.layer.cornerRadius = _configuration.cornerRadius;
    text.clipsToBounds = YES;
    return text;
}

@end












