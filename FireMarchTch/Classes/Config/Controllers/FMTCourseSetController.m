//
//  FMTCourseSetController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/23.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTCourseSetController.h"
#import "FMTRegTopView.h"
#import "FMTPrivacySetController.h"
#import "FMTCourseCell.h"
#import "FMTCourseModel.h"
#import "FMTCourseEditView.h"

@interface FMTCourseSetController () <UITableViewDelegate, UITableViewDataSource,LMJDropdownMenuDelegate>
@property (strong, nonatomic) UITableView* myTableView;
@property (strong, nonatomic) FMTCourseEditView *courseEditView;

@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *editView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *doneButton;
//@property (strong, nonatomic)
@property (strong, nonatomic) NSMutableArray<FMTCourseModel *> *courseAry;
@end

@implementation FMTCourseSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initDatas];
    [self initEditViews];
    [self initTopView];
    // Do any additional setup after loading the view from its nib.
}

- (void)initDatas {
    _courseAry = [NSMutableArray array];
    FMTCourseModel *courseMode = [FMTCourseModel new];
    courseMode.courseFee = @"600";
    courseMode.courseName = @"标准版";
    courseMode.courseItems = @[@"春天的一阵风",@"知性",@"服务好",@"倾国倾城"];
    courseMode.courseNumber = @"P";
    courseMode.courseDuration = @"60";
    FMTCourseModel *courseMode1 = [FMTCourseModel new];
    courseMode1.courseFee = @"700";
    courseMode1.courseName = @"标准版Plus";
    courseMode1.courseItems = @[@"春天的一阵风",@"知性",@"服务好",@"倾国倾城"];
    courseMode1.courseNumber = @"PP";
    courseMode1.courseDuration = @"60";
    FMTCourseModel *courseMode2 = [FMTCourseModel new];
    courseMode2.courseFee = @"800";
    courseMode2.courseName = @"标准版PP";
    courseMode2.courseItems = @[@"春天的一阵风",@"知性",@"服务好",@"倾国倾城"];
    courseMode2.courseNumber = @"PP";
    courseMode2.courseDuration = @"60";
    [_courseAry addObject:courseMode];
    [_courseAry addObject:courseMode1];
    [_courseAry addObject:courseMode2];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction:)];
    rightItem.width = 60.f;
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:BOLDSYSTEMFONT(16)} forState:UIControlStateNormal];
    [rightItem setTintColor:FSYellow];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.myTableView reloadData];
}

- (void)initEditViews {
    self.maskView.hidden = YES;
    self.courseEditView.hidden = NO;
    self.courseEditView.layer.cornerRadius = 10;
}

- (void)initTopView {
    FMTRegTopView *tipView = [FMTRegTopView new];
    [self.view addSubview:tipView];
    [self.view sendSubviewToBack:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.leading.mas_equalTo(self.view).offset(0);
        make.trailing.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(150);
    }];
    tipView.bigTitleLabel.text = @"③设置课程";
    tipView.subTitleLabel.text = @"课程";
    [tipView updateHeight];
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
    return 1 + self.courseAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FMTCourseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FMTCourseCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cardView.hidden = NO;
    if (indexPath.row == self.courseAry.count)
    {
        cell.cardView.hidden = YES;
    }
    else
    {
        FMTCourseModel* model = self.courseAry[indexPath.row];
        cell.courseNameLabel.text = model.courseName;
        cell.courseFeeLabel.text = model.courseFee;
        cell.courseNumLabel.text = model.courseNumber;
        cell.courseDurationLabel.text = model.courseDuration;
        cell.courseContentView.tags = model.courseItems;
        [cell.courseContentView setTouchEnableFalse];
    }
    return cell;
}

#pragma mark-UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
    [self showEditView];
    if (indexPath.row < self.courseAry.count) {
        [self updateEditView:self.courseAry[indexPath.row]];
    } else {
        [self updateEditView:nil];
    }
                                    
}

#pragma mark- MenuDelegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellContent:(id)content {
    switch (menu.tag) {
        case 1:
            DLog(@"%@",content);
            break;
        case 2:
            DLog(@"%@",content);
            break;
        case 3:
            DLog(@"%@",content);
            break;
            
        default:
            break;
    }
}


#pragma mark- Actions
- (void)showEditView {
    [self.maskView setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _courseEditView.frame = CGRectMake(PJ_SCREEN_WIDTH*0.1, PJ_SCREEN_HEIGHT*0.1, PJ_SCREEN_WIDTH*0.8, PJ_SCREEN_HEIGHT*0.8);
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        [self.maskView layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

- (void)hideEditView {
    [UIView animateWithDuration:0.5 animations:^{
        _maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
        _courseEditView.frame = CGRectMake(PJ_SCREEN_WIDTH*0.1, PJ_SCREEN_HEIGHT, PJ_SCREEN_WIDTH*0.8, PJ_SCREEN_HEIGHT*0.8);
        [[UIApplication sharedApplication].keyWindow layoutIfNeeded];
        [self.maskView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.maskView setHidden:YES];
    }];
}

- (void)nextStepAction:(id)sender {
    FMTPrivacySetController *VC = [[FMTPrivacySetController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)cancelAction {
    [self hideEditView];
}

- (void)doneAction {
    [self hideEditView];
}

- (void)updateEditView:(FMTCourseModel *)courseModel {
    self.courseEditView.courseNameTextField.text = courseModel.courseName;
    [self.courseEditView.courseFeeMenu.mainBtn setTitle:courseModel.courseFee forState:UIControlStateNormal];
    [self.courseEditView.courseDurationMenu.mainBtn setTitle:courseModel.courseDuration forState:UIControlStateNormal];
    [self.courseEditView.courseNumMenu.mainBtn setTitle:courseModel.courseNumber forState:UIControlStateNormal];
    self.courseEditView.courseContentView.selectedTags = [courseModel.courseItems mutableCopy];
    [self.courseEditView.courseContentView reloadData];
    courseModel ? (self.courseEditView.typeLabel.text = @"编辑") : (self.courseEditView.typeLabel.text = @"新增");
}


#pragma mark- Lazy Load
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
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        
        [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.view.mas_leading).offset(0);
            make.trailing.mas_equalTo(self.view.mas_trailing).offset(0);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            make.top.mas_equalTo(self.view.mas_top).offset(160);
        }];
        
        NSArray* nibArys = @[@"FMTCourseCell"];
        
        for (id cells in nibArys) {
            UINib *nib=[UINib nibWithNibName:cells bundle:nil];
            [self.myTableView registerNib:nib forCellReuseIdentifier:cells];
        }
    }
    return _myTableView;
}

-(UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0);
        [_maskView bk_whenTapped:^{
            [self hideEditView];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(PJ_SCREEN_BOUNDS.size);
            make.center.mas_equalTo([UIApplication sharedApplication].keyWindow.center).offset(0);
        }];
    }
    return _maskView;
}

- (FMTCourseEditView *)courseEditView {
    if (!_courseEditView) {
        _courseEditView = [FMUtils getXibViewByName:@"FMTCourseEditView"];
        [[UIApplication sharedApplication].keyWindow addSubview:_courseEditView];
        _courseEditView.frame = CGRectMake(PJ_SCREEN_WIDTH*0.1, PJ_SCREEN_HEIGHT, PJ_SCREEN_WIDTH*0.8, PJ_SCREEN_HEIGHT*0.8);
        
//        [_courseEditView.doneButton setImage:[IMAGENAMED(@"correct") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_courseEditView.doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
//        [_courseEditView.cancelButton setImage:[IMAGENAMED(@"cross") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_courseEditView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_courseEditView.courseNumMenu setMenuTitles:@[@"P",@"PP",@"BY",@"BT"] rowHeight:30];
        _courseEditView.courseNumMenu.delegate = self;
        [_courseEditView.courseDurationMenu setMenuTitles:@[@"60",@"70",@"80",@"90"] rowHeight:30];
        _courseEditView.courseDurationMenu.delegate = self;
        [_courseEditView.courseFeeMenu setMenuTitles:@[@"200",@"300",@"500",@"600"] rowHeight:30];
        _courseEditView.courseFeeMenu.delegate = self;
        
        _courseEditView.courseContentView.isMultiSelect = YES;
        _courseEditView.courseContentView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _courseEditView.courseContentView.tags = @[@"知性",@"明媚",@"有为青年",@"颜值高",@"春天的一阵风",@"透心凉",@"服务好",@"倾国倾城",@"有缘再见"];
        _courseEditView.courseContentView.completion = ^(NSArray *selectTags, NSInteger currentIndex) {
            DLog(@"%@",selectTags);
        };
    }
    return _courseEditView;
}
@end
