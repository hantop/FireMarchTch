//
//  CZJSBAlertView.m
//  CZJShop
//
//  Created by Joe.Pen on 2/24/16.
//  Copyright © 2016 JoeP. All rights reserved.
//

#import "FMAlertViewController.h"

@interface FMAlertViewController ()
@property (nonatomic, copy) FMGeneralBlock basicBlock;
@end

@implementation FMAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView
{
    _popView = [FMUtils getXibViewByName:@"CZJAlertView"];
    [_popView setWidth:PJ_SCREEN_WIDTH];
    [_popView setPosition:CGPointMake(PJ_SCREEN_WIDTH*0.5, PJ_SCREEN_HEIGHT*0.5) atAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.view addSubview:_popView];
    self.view.backgroundColor = CLEARCOLOR;
    
    [self.popView.confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setConfirmItemHandle:(FMGeneralBlock)basicBlock
{
    self.basicBlock = basicBlock;
}

- (void)confirmBtnClick:(UIButton*)sender
{
    if (self.basicBlock)
    {
        self.basicBlock();
    }
}

@end
