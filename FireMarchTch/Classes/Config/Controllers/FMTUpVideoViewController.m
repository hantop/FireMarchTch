//
//  FMTUpVideoViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/7/10.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUpVideoViewController.h"

@interface FMTUpVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *upvideoButton;
- (IBAction)upVideoAciton:(id)sender;
@end

@implementation FMTUpVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)upVideoAciton:(id)sender {
}
@end
