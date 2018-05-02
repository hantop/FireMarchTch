//
//  FMTMyInfoController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/26.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTMyInfoController.h"
#import "FMTMyInfoCell.h"

@interface FMTMyInfoController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView* myTableView;
@property (strong, nonatomic) NSArray *cells;
@end

@implementation FMTMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cells = @[@{@"image":@"tencent_QQ",@"name":@"账户"},
                   @{@"image":@"tencent_QQ",@"name":@"数据中心"},
                   @{@"image":@"tencent_QQ",@"name":@"我的相册"},
                   @{@"image":@"tencent_QQ",@"name":@"我的评价"},
                   @{@"image":@"tencent_QQ",@"name":@"分享赚钱"},
                   @{@"image":@"tencent_QQ",@"name":@"设置"}];
    [self.myTableView reloadData];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    //导航栏背景透明化
    id navigationBarAppearance = self.navigationController.navigationBar;
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"nav_bargound"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.translucent = NO;
    self.navigationController.navigationBar.shadowImage =[UIImage imageNamed:@"nav_bargound"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    NSArray *views = self.navigationController.viewControllers;
    DLog(@"%@",views);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        FMTMyInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FMTMyInfoCell" forIndexPath:indexPath];
        cell.backgroundColor = CLEARCOLOR;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.text = self.cells[indexPath.row - 1][@"name"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.imageView setImage:[IMAGENAMED(self.cells[indexPath.row - 1][@"image"]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [cell.imageView setTintColor:FSGrayColorA8];
        cell.backgroundColor = CLEARCOLOR;
        return cell;
    }

    return nil;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 100;
    }
    else {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        
    }
    else {
        
    }
}

- (UITableView*)myTableView
{
    if (!_myTableView)
    {
        self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT) style:UITableViewStylePlain];
        self.myTableView.tableFooterView = [[UIView alloc]init];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        self.myTableView.scrollEnabled = YES;
        self.myTableView.clipsToBounds = YES;
        self.myTableView.showsVerticalScrollIndicator = NO;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.myTableView.backgroundColor = CLEARCOLOR;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.myTableView];
        
        NSArray* nibArys = @[@"FMTMyInfoCell"
                             ];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

@end
