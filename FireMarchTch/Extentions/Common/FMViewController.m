//
//  FMViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 02/04/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMViewController.h"
#import "FMAlertViewController.h"

@interface FMViewController ()

@end

@implementation FMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFMAlertView:(NSString*)promptStr
      andConfirmHandler:(FMGeneralBlock)confirmBlock
       andCancleHandler:(FMGeneralBlock)cancleBlock
{
    self.cancleBlock = cancleBlock;
    FMAlertViewController* alertViewVC = [[FMAlertViewController alloc]init];
    self.popWindowInitialRect = ZEROVERTICALHIDERECT;
    self.popWindowDestineRect = ZERORECT;
    self.windowAlpha = 0;
    [FMUtils showMyWindowOnTarget:self withPopVc:alertViewVC];
    alertViewVC.popView.descLabel.text = promptStr;
    [alertViewVC.popView.cancelBtn addTarget:self action:@selector(hideWindow) forControlEvents:UIControlEventTouchUpInside];
    [alertViewVC setConfirmItemHandle:confirmBlock];
}

- (void)hideWindow
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.window.frame = self.popWindowInitialRect;
        self.windowAlpha = 1.0f;
        self.upView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.upView removeFromSuperview];
            [self.window resignKeyWindow];
            self.window  = nil;
            self.upView = nil;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            if (self.cancleBlock) self.cancleBlock();
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
