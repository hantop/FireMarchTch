//
//  FMTRegistViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTRegistViewController.h"
#import "FMTCodeInputTextFields.h"
#import "FMSetPWDViewController.h"

@interface FMTRegistViewController () <FMTCodeInputTextFieldsDelegate, UITextFieldDelegate>
@property (strong, nonatomic) FMTCodeInputTextFields *textField;
@property (strong, nonatomic) NSString *inviteCode;
@property (weak, nonatomic) IBOutlet UIView *inputPhoneNumView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineThrHeight;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *msgCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;

@property (weak, nonatomic) IBOutlet UIButton *getMsgCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

- (IBAction)nextStepAction:(id)sender;
- (IBAction)getMsgCodeAction:(id)sender;
@end

@implementation FMTRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initViews];
}

- (void)initViews {
//    self.inputPhoneNumView.alpha = 0;
//    self.inputPhoneNumView.hidden = YES;
    self.lineOneHeight.constant = 0.8;
    self.lineTwoHeight.constant = 0.8;
    self.lineThrHeight.constant = 0.8;
    self.nextButton.layer.cornerRadius = 25;
    self.phoneNumTextField.delegate = self;
    self.msgCodeTextField.delegate = self;
    self.qqTextField.delegate = self;
    [self.phoneNumTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.msgCodeTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.qqTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    FMTCodeInputTextFieldsConfig *config = [[FMTCodeInputTextFieldsConfig alloc]initWithCodeType:FMTCodeTypeLong];
    config.textFieldSize = (iPhone5 || iPhone4) ? CGSizeMake(40, 50) : CGSizeMake(50, 50);
    _textField = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
    [self.view addSubview:_textField];
    _textField.hidden = YES;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(@(100));
    }];
    
    [self.phoneNumTextField becomeFirstResponder];
    [self updateNextStepButton:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *numStr = [NSString stringWithFormat:@"%@%@",textField.text, string];
    DLog(@"%@",numStr);
    switch (textField.tag) {
        case 0:   //电话号码输入框
        {
            if (numStr.length > 11)
                
                return NO;
        }
            break;
        case 1:   //验证码输入框
        {
            if (numStr.length > 6)
                return NO;
        }
            break;
        case 2:   //QQ号输入框
        {
            if (numStr.length > 13)
                return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
    [self updateNextStepButton:textField];
}

- (void)updateNextStepButton:(UITextField *)textField {
    if (self.phoneNumTextField.text.length == 11 &&
        textField.tag == self.phoneNumTextField.tag) {
        self.hintLabel.hidden = [FMUtils isMobileNumber:self.phoneNumTextField.text];
        [self postCheckPhoneOrQQisRegist];
    }
    else
    {
        self.hintLabel.hidden = YES;
    }
    if (self.msgCodeTextField.text.length == 6 &&
        self.msgCodeTextField.tag == textField.tag) {
        [self postCheckSMSCode];
    }
    if (self.phoneNumTextField.text.length == 11 &&
        self.msgCodeTextField.text.length == 6 &&
        self.qqTextField.text.length > 5) {
        [self.nextButton setBackgroundColor:FSYellowColor33];
        [self.nextButton setEnabled:YES];
    }
    else
    {
        [self.nextButton setBackgroundColor:FSGrayColorA8];
        [self.nextButton setEnabled:NO];
    }
}

#pragma mark- FMTCodeInputTextFieldsDelegate
- (void)codeInputTextFieldOverWithString:(NSString *)codeStr
{
    [self postCheckInviteCodeWithCodeString:codeStr];
}


#pragma mark- 验证邀请码
- (void)postCheckInviteCodeWithCodeString:(NSString *)codeStr {
    __weak typeof(self) weakSelf = self;
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:@{@"inviteCode" : codeStr} success:^(id json) {
        [weakSelf showPhoneNumAndPWDView];
        weakSelf.inviteCode = codeStr;
    } fail:^(NSError *error) {
        DLog(@"%@",error);
        [_textField resetCodeInputTextField];
        [weakSelf showPhoneNumAndPWDView];
    } url:kFMTAPICheckInviteCode];
}

#pragma mark- 邀请码验证成功显示注册界面
- (void)showPhoneNumAndPWDView {
    
    self.inputPhoneNumView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.inputPhoneNumView.alpha = 1;
        _textField.alpha = 0;
        //必须调用此方法，才能出动画效果
        [_textField.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [_textField removeFromSuperview];
        }
    }];
}

#pragma mark- 验证手机号或QQ号是否已经注册过
- (BOOL)postCheckPhoneOrQQisRegist {
    __block BOOL isOK = NO;
    FMSuccessBlock successBlock = ^(id json) {
        isOK = YES;
    };
    FMFailureBlock failure = ^(id json) {
        isOK = NO;
    };
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:@{@"qqNumber":self.qqTextField.text,@"mobile":self.phoneNumTextField.text}
                                                       success:successBlock
                                                          fail:failure
                                                           url:kFMTAPICheckUserFirst];
    return isOK;
}

#pragma mark- 发送验证码
- (IBAction)getMsgCodeAction:(id)sender {
    //输入内容校验（是不是手机号，以及有没有输入文字）
    if (!self.phoneNumTextField.text ||
        ![FMUtils isMobileNumber:self.phoneNumTextField.text] ||
        [self.phoneNumTextField.text isEqualToString:@""])
    {
        [FMUtils tipWithText:@"请输入正确手机号码!" onView:self.view];
        return;
    }

    if (self.getMsgCodeButton.enabled)
    {
        FMSuccessBlock successblock = ^(id json){
            [self.getMsgCodeButton setEnabled:NO];
            [self.msgCodeTextField becomeFirstResponder];
            
            __block int timeout=9; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.getMsgCodeButton setEnabled:YES];
                        [self.getMsgCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [self.getMsgCodeButton setTitleColor:FSYellowColor33 forState:UIControlStateNormal];
                    });
                }else{
                    int seconds = timeout % 10;
                    NSString *strTime = [NSString stringWithFormat:@"(%dS)", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.getMsgCodeButton setEnabled:NO];
                        [self.getMsgCodeButton setTitle:strTime forState:UIControlStateNormal];
                        [self.getMsgCodeButton setTitleColor:FSGrayColorC8 forState:UIControlStateNormal];
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        };
        
        [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:@{@"mobile" : self.phoneNumTextField.text}
                                                           success:successblock
                                                               url:kFMTAPISendSMSCode];
    }
}

#pragma mark- 验证短信验证码
- (void)postCheckSMSCode {
    FMSuccessBlock successBlock = ^(id json) {
        
    };
    FMFailureBlock failure = ^(id json) {
        
    };
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:@{@"smsCode":self.msgCodeTextField.text,@"mobile":self.phoneNumTextField.text}
                                                       success:successBlock
                                                          fail:failure
                                                           url:kFMTAPICheckSMSCode];
}

#pragma mark-
- (IBAction)nextStepAction:(id)sender {
    [self.qqTextField resignFirstResponder];
    BOOL isOK = [self postCheckPhoneOrQQisRegist];
    if (isOK) {
         [self performSegueWithIdentifier:@"segueToSetPwdVC" sender:self];
    }
    else {
        
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToSetPwdVC"])
    {
        NSDictionary *dict = @{@"mobile" : self.phoneNumTextField.text,
                               @"qqNumber" : self.qqTextField.text,
                               @"inviteCode" : self.inviteCode
                               };
        
        FMSetPWDViewController* setPwdVC = segue.destinationViewController;
        setPwdVC.basicInfo = [dict mutableCopy];
    }
}
@end
