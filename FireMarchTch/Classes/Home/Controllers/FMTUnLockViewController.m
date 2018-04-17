//
//  FMTUnLockViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 21/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUnLockViewController.h"
#import "FMTCodeInputTextFields.h"

@interface FMTUnLockViewController ()<FMTCodeInputTextFieldsDelegate>
@property (strong, nonatomic) FMTCodeInputTextFields *textField;

@end

@implementation FMTUnLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FMTCodeInputTextFieldsConfig *config = [[FMTCodeInputTextFieldsConfig alloc] initWithCodeType:FMTCodeTypeShort];
    config.tintColor = FSYellow;
    _textField = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(60));
        make.top.equalTo(self.view).with.offset(100);
        make.right.left.equalTo(self.view).with.offset(0);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- FMTCodeInputTextFieldDelegate
- (void)codeInputTextFieldOverWithString:(NSString *)codeStr
{
    DLog(@"codestr:%@",codeStr);
    NSString *accessCode = [USER_DEFAULT valueForKey:kFMTAccessCode];
    
    if ([codeStr isEqualToString:accessCode])
    {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [_textField resetCodeInputTextField];
    }
}

@end
