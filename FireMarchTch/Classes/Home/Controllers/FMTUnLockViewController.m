//
//  FMTUnLockViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 21/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUnLockViewController.h"

@interface FMTUnLockViewController ()<FMTCodeInputTextFieldDelegate>
@property (strong, nonatomic) FMTCodeInputTextField *textField;

@end

@implementation FMTUnLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textField = [FMUtils getXibViewByName:@"FMTCodeInputTextField"];
    _textField.delegate = self;
    _textField.frame = CGRectMake(0, 200, PJ_SCREEN_WIDTH, 60);
    [self.view addSubview:_textField];
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
