//
//  FMTRegLoginHomeController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTRegLoginHomeController.h"
#import "UIView+Shadow.h"

@interface FMTRegLoginHomeController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@end

@implementation FMTRegLoginHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    //导航栏设置为透明色
    [self.navigationController.navigationBar lt_setBackgroundColor:RGBA(100, 100, 100, 0)];
    //登录、注册按钮设置
    _loginButton.layer.cornerRadius = 25;
    [_loginButton addShadowColor:FSYellow];
    
    
    _registButton.layer.cornerRadius = 25;
    _registButton.layer.borderWidth = 0.5;
    _registButton.layer.borderColor = FSYellow.CGColor;
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSArray *views = self.navigationController.viewControllers;
    DLog(@"%@",views);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
