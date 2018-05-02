//
//  FMBaseTabBarController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/26.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMBaseTabBarController.h"
#import <HHBadgeHUD.h>

@interface FMBaseTabBarController ()
@property (strong, nonatomic) UILabel* dotLabel;
@end

@implementation FMBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UITabBar appearance].translucent = NO;
    UIView *bg = [UIView new];
    bg.backgroundColor = WHITECOLOR;
    bg.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:bg atIndex:0];
    
    [self.tabBar setTintColor:FSYellow];
    [self.tabBar addShadowColor:FSGrayColorA8 offset:CGSizeMake(0, 5)];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }];
    
    [self refreshTabBarDotLabel];
    //注册接收有新消息显示小红点通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTabBarDotLabel) name:kFMNotifiLoginSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        _lastSelectedIndex = self.selectedIndex;
        DLog(@"1 OLD:%ld , NEW:%ld",self.lastSelectedIndex,selectedIndex);
    }
    
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    
    if (tabIndex != self.selectedIndex) {
        //设置最近一次变更
        _lastSelectedIndex = self.selectedIndex;
        DLog(@"2 OLD:%ld , NEW:%ld",self.lastSelectedIndex,tabIndex);
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

- (void)refreshTabBarDotLabel
{
}


@end
