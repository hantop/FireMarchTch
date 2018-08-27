//
//  FMTLoginViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTLoginViewController.h"
#import "FMSetMyInfoViewController.h"
#import "FMTRegistViewController.h"
#import "FMTRegTopView.h"
#import <NSAttributedString+YYText.h>

@interface FMTLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeight;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

- (IBAction)LoginAction:(id)sender;
- (IBAction)forgetPWDAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneNumTop;
@end

@implementation FMTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initViews];
    [self initTopView];
}

- (void)initViews {
    self.lineOneHeight.constant = 0.5;
    self.lineTwoHeight.constant = 0.5;
    self.loginButton.layer.cornerRadius = 5;
    
//    self.phoneNumTextField.leftView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"man")];
//    self.pwdTextField.leftView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"lock2")];
//    self.phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
//    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.phoneNumTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.phoneNumTextField.delegate = self;
    self.pwdTextField.delegate = self;
    
    //设置导航栏标题字体颜色大小
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:FSBlackColor33,NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
}

- (void)initTopView {
    FMTRegTopView *tipView = [FMTRegTopView new];
    [self.view addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
        make.leading.mas_equalTo(self.view).offset(0);
        make.trailing.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(200);
    }];
    [tipView.topLogoImageView setImage:[IMAGENAMED(@"myCircle") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tipView.topLogoImageView setTintColor:FSBlackColor33];
}

- (void)viewWillAppear:(BOOL)animated
{
    //如果界面是弹框出来
    if (self.isPopView) {
        self.phoneNumTop.constant = 200;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *numStr = [NSString stringWithFormat:@"%@%@",textField.text, string];
    if (0 == textField.tag &&
        numStr.length > 11) {
        return NO;
    }
    else if (1 == textField.tag && numStr.length > 20){
        [FMUtils tipWithText:@"密码长度不大于20位" onView:self.view];
        return NO;
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
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
}


- (IBAction)LoginAction:(id)sender {
    [self.view endEditing:YES];
    
    FMSetMyInfoViewController *setVC = [[FMSetMyInfoViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    return;
    
    //规则校验
    if (![FMUtils isMobileNumber:_phoneNumTextField.text]) {
        [FMUtils tipWithText:@"请输入正确的手机号" onView:self.view];
        return;
    }
    if (_pwdTextField.text.length < 8 || _pwdTextField.text.length > 20) {
        [FMUtils tipWithText:@"密码长度不对，不少于8位，不大于20位" onView:self.view];
        return;
    }
    
    //数据采集
    NSDictionary *deviceInfo = [FMDeviceInfo XWGetDeviceInfo];
    DLog(@"%@",[deviceInfo description]);

    NSDictionary *params = @{@"username" : _phoneNumTextField.text,
                             @"password" : _pwdTextField.text,
                             @"deviceid" : deviceInfo[@"uuid"]
                             };
    
    
    //发送请求
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:params success:^(id json) {
        [USER_DEFAULT setValue:json[@"token"] forKey:kUserDefaultAccessToken];
        [USER_DEFAULT setValue:@"1" forKey:kUserDefaultIsLogin];
        if ([json[@"completed"] isEqualToString:@""]) {
            //首次登录，跳转资料完善界面
            FMSetMyInfoViewController *setVC = [[FMSetMyInfoViewController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        else {
            //非首次登录则检查是否审核完成
            if ([json[@"approved"] isEqualToString:@""]) {
                //审核未完成跳转审核中页面
                
            }
            else {
                //审核完成，进入主页
                
            }
        }
        
    } url:kFMTAPILogin];
}

- (IBAction)forgetPWDAction:(id)sender {
    FMTRegistViewController *resetPWD = (FMTRegistViewController *)[FMUtils getViewControllerFromStoryboard:@"RegLogin" andVCName:@"registSBID"];
    resetPWD.registType = FMTRegistTypeReset;
    [self.navigationController pushViewController:resetPWD animated:YES];
}
@end
