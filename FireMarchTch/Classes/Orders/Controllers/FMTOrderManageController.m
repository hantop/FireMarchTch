//
//  FMTOrderManageController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/26.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTOrderManageController.h"
#import "CZJPageControlView.h"
#import "FMTLoginViewController.h"

@interface FMTOrderManageController ()
@property (assign, nonatomic)NSInteger orderListTypeIndex;

@end

@implementation FMTOrderManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageBarView];
    [self checkToken];
    // Do any additional setup after loading the view.
}

- (void)initPageBarView {
    
    UIViewController *v1 = [[UIViewController alloc] init];
    v1.view.backgroundColor = REDCOLOR;
    UIViewController *v2 = [[UIViewController alloc] init];
    v2.view.backgroundColor = BLUECOLOR;
    UIViewController *v3 = [[UIViewController alloc] init];
    v3.view.backgroundColor = GRAYCOLOR;
    NSMutableArray *orderListAry = [@[v1, v2, v3] mutableCopy];
    CGRect pageViewFrame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT);
    CZJPageControlView* pageview = [[CZJPageControlView alloc]initWithFrame:pageViewFrame andPageIndex:_orderListTypeIndex];
    [pageview setTitleArray:@[@"预约",@"进行中",@"完成"] andVCArray:orderListAry];
    pageview.backgroundColor = WHITECOLOR;
    [self.navigationController.navigationBar addSubview:pageview];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)checkToken {
    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPostNoTips:nil success:^(id json) {
        //token未过期，直接进入app。从后台返回需要显示隐私码
        [USER_DEFAULT setValue:@"1" forKey:kUserDefaultAccessCodeShow];
        NSLog(@"%@",json);
    } fail:^(id error) {
        [USER_DEFAULT setValue:@"0" forKey:kUserDefaultAccessCodeShow];
        //token过期，需重新登录，进入den
        FMTLoginViewController *loginViewController = (FMTLoginViewController *)[FMUtils getViewControllerFromStoryboard:@"RegLogin" andVCName:@"LoginScene"];
        loginViewController.isPopView = YES;
        [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
        NSLog(@"%@",error);
    } url:kFMTAPICheckToken];
}


@end
