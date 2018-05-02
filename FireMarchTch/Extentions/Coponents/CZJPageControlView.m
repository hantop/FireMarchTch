
//
//  CZJPageControlView.m
//  CZJShop
//
//  Created by Joe.Pen on 12/16/15.
//  Copyright © 2015 JoeP. All rights reserved.
//

#import "CZJPageControlView.h"
#define BtnTag 1001


@interface CZJPageControlView()
<UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
UIScrollViewDelegate>
{
}
/**
 *  只需要修改的第一处
 */
@property (nonatomic, strong) NSMutableArray *btnArr;
/**
 *  只需要修改的第二处,
 */
@property (nonatomic, strong) NSArray *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger tapIndex;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, assign) __block BOOL isTapButton;
@end

@implementation CZJPageControlView
@synthesize btnArr = _btnArr;
@synthesize viewControllerArray = _viewControllerArray;
- (instancetype)initWithFrame:(CGRect)frame andPageIndex:(NSInteger)pageIndex
{
    if (self == [super initWithFrame:frame])
    {
        _currentPageIndex = pageIndex;
        _btnArr = [NSMutableArray array];
        _isTapButton = NO;
        return self;
    }
    return nil;
}

- (void)setTitleArray:(NSArray*)titleArray andVCArray:(NSArray*)vcArray
{
    _viewControllerArray = vcArray;
    if (titleArray.count != 0 && _viewControllerArray != 0)
    {
        [self initMainControllerWithTitles:titleArray];
        [self setupPageViewController];
    }
    else
    {
        UIAlertView* alertview = [[UIAlertView alloc]initWithTitle:@"无内容" message:@"" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:@"", nil];
        [alertview show];
    }
}


#pragma mark- 初始化PageViewController
-(void)setupPageViewController{
    [self addSubview:self.pageController.view];
    [self syncScrollView];
}

-(void)syncScrollView{
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *pageScrollView = (UIScrollView *)view;
            pageScrollView.delegate = self;
            pageScrollView.scrollsToTop=NO;
        }
    }
}

- (UIPageViewController *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.view.frame = ((nil == self.pageControlViewConfig) ? kGeneralPageControllerFrame : self.pageControlViewConfig.pageControllerFrame);
        _pageController.view.backgroundColor = ((nil == self.pageControlViewConfig) ? CLEARCOLOR : self.pageControlViewConfig.pageControllerBGColor);
        _pageController.delegate = self;
        _pageController.dataSource = self;
        
        [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:_currentPageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageController;
}


#pragma mark- 初始化顶部PageViewController导航按钮
-(void)initMainControllerWithTitles:(NSArray *)titles{
    CGSize size = CGSizeMake(PJ_SCREEN_WIDTH *0.5 / titles.count, 50);
    
    UIView *statusView = [UIView new];
    statusView.backgroundColor = WHITECOLOR;
    [self addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(PJ_SCREEN_WIDTH, 20));
        make.bottom.mas_equalTo(self.mas_top).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
    }];
    
    _topView = [UIView new];
    [self addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(PJ_SCREEN_WIDTH * 0.5, 50));
        make.top.mas_equalTo(self).offset(0);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
    }];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:((nil == self.pageControlViewConfig) ? [UIColor darkTextColor] : self.pageControlViewConfig.btnTitleColorNormal) forState:UIControlStateNormal];
        [btn setTitleColor:((nil == self.pageControlViewConfig) ? FSYellow : self.pageControlViewConfig.btnTitleColorSelected) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:(nil == self.pageControlViewConfig) ? 16 : self.pageControlViewConfig.btnTitleLabelSize];
        [btn setBackgroundColor:(nil == self.pageControlViewConfig) ?  WHITECOLOR : self.pageControlViewConfig.btnBackgroundColor];
        btn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.numberOfLines = 2;
        float originX = i * size.width;
        btn.frame = CGRectMake(originX, 0, size.width, size.height);
        btn.tag = BtnTag + i;

        [btn addTarget:self action:@selector(changeControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        if (i == _currentPageIndex)
        {
            btn.selected = YES;
        }
        [_btnArr addObject:btn];
    }
    
    _buttomView = [UIView new];
    _buttomView.backgroundColor = FSYellow;
    _buttomView.tag = 2000;
    [_topView addSubview:_buttomView];
    CGSize titleSize = [FMUtils calculateTitleSizeWithString:((UIButton *)_btnArr.firstObject).titleLabel.text WithFont:((UIButton *)_btnArr.firstObject).titleLabel.font];
    _buttomView.frame = CGRectMake(0 + (size.width - titleSize.width) * 0.5, 40, titleSize.width, 2);
}


#pragma mark 点击了pageController的按钮
-(void)changeControllerClick:(id)sender{
    _isTapButton = YES;
    UIButton *btn = (UIButton *)sender;
    NSInteger tempIndex = _currentPageIndex;
    __weak typeof (self) weakSelf = self;
    NSInteger nowTemp = btn.tag - BtnTag;
    _tapIndex = nowTemp;
    /**
     * 这种方式只动画滑动一个页面
     */
    if (nowTemp > tempIndex)
    {
        [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:nowTemp]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            if (finished) {
                [weakSelf updateCurrentPageIndex:nowTemp];
                [[NSNotificationCenter defaultCenter]postNotificationName:kFMNotifiRefreshOrderlist object:nil userInfo:@{@"currentIndex" : [NSString stringWithFormat:@"%ld",nowTemp]}];
            }
        }];
    }
    else if (nowTemp < tempIndex)
    {
        [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:nowTemp]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            if (finished) {
                [weakSelf updateCurrentPageIndex:nowTemp];
                [[NSNotificationCenter defaultCenter]postNotificationName:kFMNotifiRefreshOrderlist object:nil userInfo:@{@"currentIndex" : [NSString stringWithFormat:@"%ld",nowTemp]}];
            }
        }];
    }
    
    /**
     * 这种方式有多少个页面就动画滑动多少个页面
     */
    
//    if (nowTemp > tempIndex) {
//        for (int i = (int)tempIndex + 1; i <= nowTemp; i ++) {
//            [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
//                if (finished) {
//                    [weakSelf updateCurrentPageIndex:i];
//                    if (i == nowTemp)
//                    {
//                        [[NSNotificationCenter defaultCenter]postNotificationName:kFMNotifiRefreshOrderlist object:nil userInfo:@{@"currentIndex" : [NSString stringWithFormat:@"%ld",nowTemp]}];
//                    }
//                }
//            }];
//        }
//    }else if (nowTemp < tempIndex){
//        for (int i = (int)tempIndex ; i >= nowTemp; i--) {
//            [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
//                if (finished) {
//                    [weakSelf updateCurrentPageIndex:i];
//                    if (i == nowTemp)
//                    {
//                        [[NSNotificationCenter defaultCenter]postNotificationName:kFMNotifiRefreshOrderlist object:nil userInfo:@{@"currentIndex" : [NSString stringWithFormat:@"%ld",nowTemp]}];
//                    }
//                }
//            }];
//        }
//    }
}

-(void)updateCurrentPageIndex:(NSInteger)newIndex
{
    _currentPageIndex = newIndex;
    _isTapButton = NO;
    UIButton *btn = (UIButton *)[self viewWithTag:BtnTag+_currentPageIndex];
    for (int i = 0 ; i < self.btnArr.count; i ++) {
        UIButton *otherBtn = (UIButton *)[self viewWithTag:BtnTag + i];
        if (btn.tag == otherBtn.tag) {
            otherBtn.selected = YES;
        }else{
            otherBtn.selected = NO;
        }
    }
}


#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;

    //判断边界，左边或右边都不动
    if ((_currentPageIndex == 0 && offsetX <= scrollView.size.width) ||
        (_currentPageIndex == self.btnArr.count - 1 && offsetX >= scrollView.size.width)) {
        return;
    }
    float percentage = fabs(scrollView.size.width - offsetX)/scrollView.size.width;
    
    UIButton *currentBtn =  _btnArr[_currentPageIndex];
    CGRect curBtnPoint = currentBtn.frame;
    NSInteger nextIndex = _isTapButton ? _tapIndex : ((offsetX > scrollView.size.width) ? (_currentPageIndex + 1) : (_currentPageIndex -1));
    UIButton *nextBtn = _btnArr[nextIndex];
    
    CGSize curtitleSize = [FMUtils calculateTitleSizeWithString:currentBtn.titleLabel.text WithFont:currentBtn.titleLabel.font];
    CGSize nexttitleSize = [FMUtils calculateTitleSizeWithString:nextBtn.titleLabel.text WithFont:nextBtn.titleLabel.font];
    
    float variWidth = curtitleSize.width + (nexttitleSize.width - curtitleSize.width) * percentage;
    float curPosX = curBtnPoint.origin.x + (currentBtn.size.width - curtitleSize.width) * 0.5;
    float nextPosX = currentBtn.size.width * nextIndex + (nextBtn.size.width - nexttitleSize.width) * 0.5;
    float originX = curPosX + (nextPosX - curPosX) * percentage;
    
    _buttomView.frame = CGRectMake(originX, 40, variWidth, 2);
}


#pragma mark UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [_viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfController:viewController];
    index++;
    
    if (index == [_viewControllerArray count]) {
        return nil;
    }
    return [_viewControllerArray objectAtIndex:index];
}


#pragma mark UIPageViewControllerDelegate
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        _currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        [self updateCurrentPageIndex:_currentPageIndex];
        [[NSNotificationCenter defaultCenter]postNotificationName:kFMNotifiRefreshOrderlist object:nil userInfo:@{@"currentIndex" : [NSString stringWithFormat:@"%ld",_currentPageIndex]}];
        NSLog(@"当前界面是界面=== %ld",_currentPageIndex);
    }
}

-(NSInteger)indexOfController:(UIViewController *)viewController
{
    for (int i = 0; i<[_viewControllerArray count]; i++) {
        if (viewController == [_viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

@end



@implementation CZJPageControlViewConfig
- (id)init {
    if ([super init]) {
        
        _btnTitleLabelSize = 18;
        
        return self;
    }
    return nil;
}
@end
