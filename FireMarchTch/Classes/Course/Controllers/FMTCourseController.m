//
//  FMTCourseController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/20.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTCourseController.h"

@interface FMTCourseController ()

@end

@implementation FMTCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置为透明色
    [self.navigationController.navigationBar lt_setBackgroundColor:RGBA(100, 100, 100, 0)];
    // Do any additional setup after loading the view.
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

@end
