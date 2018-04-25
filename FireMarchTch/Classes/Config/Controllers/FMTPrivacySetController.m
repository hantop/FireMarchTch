//
//  FMTPrivacySetController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/23.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTPrivacySetController.h"
#import "FMTRegTopView.h"
#import "FMTCodeInputTextFields.h"

@interface FMTPrivacySetController () <FMTCodeInputTextFieldsDelegate>

@property (strong, nonatomic) __block FMTCodeInputTextFields *textField1;
@property (strong, nonatomic) __block FMTCodeInputTextFields *textField2;
@property (strong, nonatomic) __block NSString *firstCode;
@property (strong, nonatomic) __block NSString *secCode;
@end

@implementation FMTPrivacySetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initTopView];
    [self initCodeInputTextFieldView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTopView {
    FMTRegTopView *tipView = [FMTRegTopView new];
    [self.view addSubview:tipView];
    [self.view sendSubviewToBack:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.leading.mas_equalTo(self.view).offset(0);
        make.trailing.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(150);
    }];
    tipView.bigTitleLabel.text = @"④设置隐私密码";
    tipView.subTitleLabel.text = @"保护你的隐私";
    [tipView updateHeight];
}

- (void)initCodeInputTextFieldView {
    FMTCodeInputTextFieldsConfig *config = [[FMTCodeInputTextFieldsConfig alloc] initWithCodeType:FMTCodeTypeShort];
    config.tintColor = FSYellow;
    _textField1 = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
    _textField1.tag = 1;
    [self.view addSubview:_textField1];
    [_textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(60));
        make.width.mas_equalTo(@(self.view.size.width));
        make.top.mas_equalTo(self.view).with.offset(150);
        make.leading.mas_equalTo(self.view.mas_leading).offset(0);
    }];
    
    _textField2 = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
    _textField2.tag = 2;
    [self.view addSubview:_textField2];
    [_textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(60));
        make.width.mas_equalTo(@(self.view.size.width));
        make.top.mas_equalTo(self.view).with.offset(150);
        make.leading.mas_equalTo(self.view.mas_trailing).offset(0);
    }];
}

- (void)codeInputTextFieldOverWithString:(NSString *)codeStr textFields:(FMTCodeInputTextFields *)textField
{
    if (1 == textField.tag) {
        _firstCode = codeStr;
        [self moveTextFieldForward:YES];
        return;
    } else {
        _secCode = codeStr;
    }
    
    if ([_secCode isEqualToString:_firstCode])
    {
        [self.view endEditing:YES];
    }
    else
    {
        [self moveTextFieldForward:NO];
    }
}

- (void)moveTextFieldForward:(BOOL)forward {
    _textField1.hidden = NO;
    if (!forward) {
        [_textField1 resetCodeInputTextField];
        [_textField2 resetCodeInputTextField];
        [_textField1 becomeFirstResponser];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [_textField1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.view.mas_leading).offset(forward ? -self.view.size.width : 0);
        }];
        [_textField2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.view.mas_trailing).offset(forward ? -self.view.size.width : 0);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _textField1.hidden = forward;
        forward ? [_textField2 becomeFirstResponser] : [_textField1 becomeFirstResponser];
    }];
}

@end
