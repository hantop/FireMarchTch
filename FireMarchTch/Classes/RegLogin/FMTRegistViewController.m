//
//  FMTRegistViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTRegistViewController.h"
#import "FMTCodeInputTextFields.h"

@interface FMTRegistViewController () <FMTCodeInputTextFieldsDelegate>
@property (strong, nonatomic) FMTCodeInputTextFields *textField;

@end

@implementation FMTRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写邀请码";
    [FMUtils customizeNavigationBarForTarget:self];
    
    FMTCodeInputTextFieldsConfig *config = [[FMTCodeInputTextFieldsConfig alloc]initWithCodeType:FMTCodeTypeLong];
    config.textFieldSize = (iPhone5 || iPhone4) ? CGSizeMake(40, 50) : CGSizeMake(50, 50);
    _textField = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
    [self.view addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(@(100));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)codeInputTextFieldOverWithString:(NSString *)codeStr
{
    
}

@end
