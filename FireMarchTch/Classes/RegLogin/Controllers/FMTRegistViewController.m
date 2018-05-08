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
#import "FMTRegTopView.h"

@interface FMTRegistViewController () <FMTCodeInputTextFieldsDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *inviteCode;
@property (assign, nonatomic) __block BOOL isOK;
@property (strong, nonatomic) __block FMTCodeInputTextFields *codeTextField;

@property (weak, nonatomic) IBOutlet UIView *inputPhoneNumView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UILabel *getMsgCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineThrHeight;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *msgCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;

@property (weak, nonatomic) IBOutlet UIButton *getMsgCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

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
    self.inputPhoneNumView.alpha = 0;
    self.inputPhoneNumView.hidden = YES;
    self.lineOneHeight.constant = 0.3;
    self.lineTwoHeight.constant = 0.3;
    self.lineThrHeight.constant = 0.3;
    self.nextButton.layer.cornerRadius = 25;
    self.phoneNumTextField.delegate = self;
    self.msgCodeTextField.delegate = self;
    self.qqTextField.delegate = self;
    [self.phoneNumTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.msgCodeTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.qqTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    switch (self.registType) {
        case FMTRegistTypeRegist:
        {
            if ([USER_DEFAULT valueForKey:kUserDefaultInviteCodeCheck]) {
                [self showPhoneNumAndPWDView];
                self.inviteCode = [USER_DEFAULT valueForKey:kUserDefaultInviteCodeCheck];
            } else {
                self.mainTitleLabel.text = @"填写邀请码";
                self.subTitleLabel.text = @"邀请码的获取方式来自好友的分享及加群获取";
                self.codeTextField.hidden = NO;
            }
        }
            break;
        case FMTRegistTypeReset:
        {
            self.mainTitleLabel.text = @"验证手机";
            self.subTitleLabel.text = @"输入手机号";
            self.inputPhoneNumView.alpha = 1;
            self.inputPhoneNumView.hidden = NO;
            self.qqTextField.hidden = YES;
            self.lineThrHeight.constant = 0;
            [self updateNextStepButton:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [[FMTBaseDataManager sharedFMTBaseDataManager] cancelAllRequest];
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
    //手机合法性及是否注册
    if (textField.tag == self.phoneNumTextField.tag) {
        if (self.phoneNumTextField.text.length == 11){
            self.hintLabel.hidden = [FMUtils isMobileNumber:self.phoneNumTextField.text];
        }else{
            self.hintLabel.hidden = YES;
        }
    }
    else{
        self.hintLabel.hidden = [FMUtils isMobileNumber:self.phoneNumTextField.text];
    }
    
    //验证短信验证码合法性
    if (self.msgCodeTextField.text.length == 6 &&
        self.msgCodeTextField.tag == textField.tag)
    {
        [self postCheckSMSCode];
        if (FMTRegistTypeReset == self.registType){
            [self.nextButton setBackgroundColor:FSYellow];
            [self.nextButton setEnabled:YES];
            return;
        }
    }
    
    //手机号是否正确、验证码是否正确、QQ号是否正确 决定是否显示下一步按钮
    if (self.phoneNumTextField.text.length == 11 &&
        self.msgCodeTextField.text.length == 6 &&
        self.qqTextField.text.length > 5 &&
        [FMUtils isMobileNumber:self.phoneNumTextField.text]) {
        [self.nextButton setBackgroundColor:FSYellow];
        [self.nextButton setEnabled:YES];
    }
    else
    {
        [self.nextButton setBackgroundColor:FSGrayColorA8];
        [self.nextButton setEnabled:NO];
    }
}

#pragma mark- FMTCodeInputTextFieldsDelegate
- (void)codeInputTextFieldOverWithString:(NSString *)codeStr textFields:(FMTCodeInputTextFields *)textField
{
    [self.view endEditing:YES];
    [self postCheckInviteCodeWithCodeString:codeStr];
}


#pragma mark- 验证邀请码
- (void)postCheckInviteCodeWithCodeString:(NSString *)codeStr {
    __weak typeof(self) weakSelf = self;
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:@{@"inviteCode" : codeStr} success:^(id json) {
        [USER_DEFAULT setValue:codeStr forKey:kUserDefaultInviteCodeCheck];
        weakSelf.inviteCode = codeStr;
        [weakSelf showPhoneNumAndPWDView];
    } fail:^(NSError *error) {
        DLog(@"%@",error);
        [_codeTextField resetCodeInputTextField];
    } url:kFMTAPICheckInviteCode];
}

#pragma mark- 邀请码验证成功显示注册界面
- (void)showPhoneNumAndPWDView {
    [self updateNextStepButton:nil];
    self.inputPhoneNumView.hidden = NO;
    
    self.mainTitleLabel.text = @"填写手机号码和QQ号";
    self.subTitleLabel.text = @"手机号获取短信验证码，QQ号用作辅助审核";
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inputPhoneNumView.alpha = 1;
        _codeTextField.alpha = 0;
        //必须调用此方法，才能出动画效果
        [_codeTextField.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [_codeTextField removeFromSuperview];
//            [self.phoneNumTextField becomeFirstResponder];
        }
    }];
}

#pragma mark- 验证手机号或QQ号是否已经注册过
- (void)postCheckPhoneOrQQisRegist {
    FMSuccessBlock successBlock = ^(id json) {
        self.isOK = YES;
    };
    FMFailureBlock failure = ^(id json) {
        self.isOK = NO;
    };
    

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
            [self.getMsgCodeButton setHidden:YES];
            [self.getMsgCodeLabel setHidden:NO];
            
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
                        [self.getMsgCodeButton setHidden:NO];
                        [self.getMsgCodeLabel setHidden:YES];
                    });
                }else{
                    int seconds = timeout % 10;
                    NSString *strTime = [NSString stringWithFormat:@"%ds", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.getMsgCodeButton setEnabled:NO];
                        [self.getMsgCodeButton setHidden:YES];
                        [self.getMsgCodeLabel setHidden:NO];
                        [self.getMsgCodeLabel setText:strTime];
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        };
        
        [[FMTBaseDataManager sharedFMTBaseDataManager] generalPostNoTips:@{@"mobile" : self.phoneNumTextField.text}
                                                           success:successblock
                                                               url:kFMTAPISendSMSCode];
    }
}

#pragma mark- 验证短信验证码
- (void)postCheckSMSCode {
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPostNoTips:@{@"smsCode":self.msgCodeTextField.text,@"mobile":self.phoneNumTextField.text}
                                                       success:nil
                                                          fail:nil
                                                           url:kFMTAPICheckSMSCode];
}

#pragma mark-
- (IBAction)nextStepAction:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    switch (self.registType) {
        case FMTRegistTypeReset:
        {
            params = [@{@"mobile":self.phoneNumTextField.text,
                        @"smsCode" : self.msgCodeTextField.text
                        } mutableCopy];
            [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:params success:^(id json) {
                [weakSelf performSegueWithIdentifier:@"segueToSetPwdVC" sender:weakSelf];
            } url:kFMTAPICheckSMSCode];
        }

            break;
        case FMTRegistTypeRegist:
        {
            params = [@{@"qqNumber":self.qqTextField.text,@"mobile":self.phoneNumTextField.text} mutableCopy];
            [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:params success:^(id json) {
                [weakSelf performSegueWithIdentifier:@"segueToSetPwdVC" sender:weakSelf];
            } url:kFMTAPICheckUserFirst];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToSetPwdVC"])
    {
        if (FMTRegistTypeReset == self.registType &&
            self.phoneNumTextField.text) {
            NSDictionary *dict = @{@"mobile" : self.phoneNumTextField.text,
                                   @"smscode" : self.msgCodeTextField.text
                                   };
            FMSetPWDViewController* setPwdVC = segue.destinationViewController;
            setPwdVC.basicInfo = [dict mutableCopy];
            setPwdVC.registType = self.registType;
        }
        else if (self.phoneNumTextField.text &&
                   self.qqTextField.text &&
                   self.inviteCode) {
            NSDictionary *dict = @{@"mobile" : self.phoneNumTextField.text,
                                   @"qqNumber" : self.qqTextField.text,
                                   @"inviteCode" : self.inviteCode
                                   };
            FMSetPWDViewController* setPwdVC = segue.destinationViewController;
            setPwdVC.basicInfo = [dict mutableCopy];
            setPwdVC.registType = self.registType;
        }
    }
}


#pragma mark- 懒加载
- (FMTCodeInputTextFields *)codeTextField {
    if (!_codeTextField) {
        FMTCodeInputTextFieldsConfig *config = [[FMTCodeInputTextFieldsConfig alloc]initWithCodeType:FMTCodeTypeLong];
        config.tintColor = FSYellow;
        config.keyboardType = UIKeyboardTypeEmailAddress;
        config.textFieldSize = (iPhone5 || iPhone4) ? CGSizeMake(40, 50) : CGSizeMake(50, 50);
        _codeTextField = [[FMTCodeInputTextFields alloc] initWithConfiguration:config delegate:self];
        [self.view addSubview:_codeTextField];
        [_codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.view).with.offset(180);
            make.height.mas_equalTo(@(100));
        }];
    }
    return _codeTextField;
}
@end
