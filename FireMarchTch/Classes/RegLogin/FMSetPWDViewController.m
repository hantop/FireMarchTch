//
//  FMSetPWDViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 27/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMSetPWDViewController.h"

@interface FMSetPWDViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstPWDTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPWDTextField;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineOneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTwoHeight;

- (IBAction)registAction:(id)sender;
@end

@implementation FMSetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews {
    self.registButton.layer.cornerRadius= 25;
    self.lineOneHeight.constant = 0.5;
    self.lineTwoHeight.constant = 0.5;
    
    self.firstPWDTextField.delegate = self;
    self.secondPWDTextField.delegate = self;
    [self updateRegistButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *numStr = [NSString stringWithFormat:@"%@%@",textField.text, string];
    if (numStr.length > 20){
        [FMUtils tipWithText:@"密码长度不大于20位" onView:self.view];
        return NO;
    }
    [self updateRegistButton];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.registButton.enabled = NO;
    [self.registButton setBackgroundColor:FSGrayColorA8];
    return YES;
}

- (void)updateRegistButton {
    self.registButton.enabled = NO;
    [self.registButton setBackgroundColor:FSGrayColorA8];
    if (self.firstPWDTextField.text.length > 6 &&
        self.secondPWDTextField.text.length > 6) {
        self.registButton.enabled = YES;
        [self.registButton setBackgroundColor:FSYellow];
    }
}

- (IBAction)registAction:(id)sender {
    if (![self.firstPWDTextField.text isEqualToString:self.secondPWDTextField.text]) {
        [FMUtils tipWithText:@"俩次密码输入不一致" onView:self.view withCompeletHandler:^{
            self.secondPWDTextField.text = @"";
            self.firstPWDTextField.text = @"";
            [self.firstPWDTextField becomeFirstResponder];
        }];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.basicInfo];
    [params setValuesForKeysWithDictionary:@{@"password" : self.firstPWDTextField.text}];
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPost:params success:^(id json) {
        
    } fail:^(NSError *error) {
        
    } url:kFMTAPIRegister];
}
@end
