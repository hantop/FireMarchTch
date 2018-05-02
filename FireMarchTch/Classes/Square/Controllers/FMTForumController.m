//
//  FMTForumController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/26.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTForumController.h"

@interface FMTForumController ()

@end

@implementation FMTForumController

- (void)viewDidLoad {
    [super viewDidLoad];
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
