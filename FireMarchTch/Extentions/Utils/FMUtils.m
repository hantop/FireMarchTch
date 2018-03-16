//
//  FMUtils.m
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 XWBank. All rights reserved.
//

#import "FMUtils.h"

#include <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>



@interface FMUtils ()<UIAlertViewDelegate>

@end

@implementation FMUtils


#pragma mark- 数据解析
+ (NSData*)jsonDataFormData:(id)data{
    
    NSError* error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    return jsonData;
}

+ (NSString*)jsonStringFromData:(id)data
{
    NSString *jsonString = nil;
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error:%@",error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSArray*)arrayFromJsonString:(id)jsonString {
    
    NSArray *DataDic = [NSJSONSerialization JSONObjectWithData:jsonString
                                                       options:NSJSONReadingMutableLeaves
                                                         error:nil];
    return DataDic;
}

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

#pragma mark- 数据的持久化
+ (BOOL)saveNSDataToDocumentDirectory:(NSData*)data withPlistName:(NSString *)plistName{
    NSString *path = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSLog(@"%@",path);
    if ([data writeToFile:path atomically:YES]) {
        return YES;
    }
    return NO;
}

+ (BOOL)saveStringDataToDocumentDirectory:(NSString*)str withPlistName:(NSString *)plistName{
    NSString *path = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (!isExists) {
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    NSData *resultData = [str dataUsingEncoding:NSUTF8StringEncoding];

    return [resultData writeToFile:path atomically:YES];
}

+ (BOOL)saveArrayToDocumentsDirectory:(NSMutableArray*)array withPlistName:(NSString*)plistName{
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (!isExists) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    return [array writeToFile:plistPath atomically:YES];
}

+ (BOOL)saveDictionaryToDocumentsDirectory:(NSMutableDictionary*)dict withPlistName:(NSString*)plistName
{
    NSError *error;
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (!isExists) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:dict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:NSPropertyListMutableContainersAndLeaves
                                                                    error:&error];
    if(plistData) {
        return [plistData writeToFile:plistPath atomically:YES];
    }
    return NO;
}


#pragma mark- 从本地读取数据
+ (NSData *)readDataFromDocumentDirectoryWithName:(NSString *)plistName{
    NSString *path = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:path];
    if (isExists) {
        NSData* data=[NSData dataWithContentsOfFile:path options:0 error:NULL];
        return data;
    }
    return nil;
}

+ (NSString *)readStringDataFromDocumentDirectoryWithName:(NSString *)plistName{
    return [FMUtils jsonStringFromData:[FMUtils readDataFromDocumentDirectoryWithName:plistName]];
}


+ (NSMutableArray *)readArrayFromDocumentsDirectoryWithName:(NSString *)plistName
{
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    NSMutableArray* array = [NSMutableArray array];
    if (isExists) {
        array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return array;
}

+ (NSMutableArray *)readArrayFromBundleDirectoryWithName:(NSString *)plistName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    NSMutableArray* array = [NSMutableArray array];
    if (isExists) {
        array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    return array;
}

+ (NSMutableDictionary *)readDictionaryFromDocumentsDirectoryWithPlistName:(NSString *)plistName
{
    NSError *error;
    NSPropertyListFormat format;
    NSString *plistPath = [DocumentsDirectory stringByAppendingPathComponent:plistName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (isExists) {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary* dic =[NSPropertyListSerialization propertyListWithData:plistXML
                                                                            options:NSPropertyListMutableContainersAndLeaves
                                                                             format:&format
                                                                              error:&error];
        return dic;
    }
    return nil;
}

+ (NSMutableDictionary *)readDictionaryFromBundleDirectoryWithPlistName:(NSString *)plistName
{
    NSError *error;
    NSPropertyListFormat format;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:plistPath];
    if (isExists) {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary* dic =[NSPropertyListSerialization propertyListWithData:plistXML
                                                                            options:NSPropertyListMutableContainersAndLeaves
                                                                             format:&format
                                                                              error:&error];
        return dic;
    }
    return nil;
}


#pragma mark 正则判断

+ (BOOL)isCarNumberPlate:(NSString *)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *regextestCarNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", carRegex];
    if ([regextestCarNumber evaluateWithObject:carNo] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isLicencePlate:(NSString *)plateNum{
    NSString* LicenceRegex = @"^[A-Z0-9]{5}";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", LicenceRegex];
    if ([regextestmobile evaluateWithObject:plateNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    if (!mobileNum) {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,183,184,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,153,177,180,181,189
     * 最新号段：145、147、170、176、178
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|4[57]|7[068])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,183,184,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0217-9]|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,153,177,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\\\d{3})\\\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+( UIColor *)getColorFromString:( NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range. length = 2 ;
    range. location = 0 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    range. location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    range. location = 4 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView{
    tableView.separatorColor = RGBA(230.0f, 230.0f, 230.0f, 1.0f);
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

void backLastView(id sender)
{
    [((UIViewController*)sender).navigationController popViewControllerAnimated:YES];
}

+ (void)customizeNavigationBarForTarget:(UIViewController*)target
{
    [self customizeNavigationBarForTarget:target hiddenButton:false];
}

+ (void)customizeNavigationBarForTarget:(UIViewController *)target hiddenButton:(BOOL)hidden
{
    SEL popAction = sel_registerName("backLastView:");
    SEL back = @selector(backLastView:);
    //    IMP backImp = [self methodForSelector:@selector(backLastView:)];
    //    IMP backImp = [NSObject instanceMethodForSelector:@selector(backLastView:)];
    //经测试，以上俩方法都不能返回正确的IMP变量。
    IMP backImp = (IMP)backLastView;
    //1.先动态的给类添加一个方法，因为下面添加的返回按钮需要调用这个方法
    class_addMethod([target class],popAction,backImp,"v@:@");
    
    
    
    //UIButton
    UIButton *leftBtn = [[ UIButton alloc ] initWithFrame : CGRectMake(- 20 , 0 , 44 , 44 )];
    [leftBtn setBackgroundImage:[UIImage imageNamed:(hidden? @"all_arrow_backwhite" : @"prodetail_btn_backnor")] forState:UIControlStateNormal];
    [leftBtn addTarget:target action:popAction forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal]; //将leftItem设置为自定义按钮
    
    //UIBarButtonItem
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]initWithCustomView: leftBtn];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 20 : 0))
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -20 ;//这个数值可以根据情况自由变化
        target.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
        
    } else
    {
        target.navigationItem.leftBarButtonItem = leftItem;
    }
    target.navigationController.interactivePopGestureRecognizer.delegate = (id)target;
}


+ (void)fullScreenGestureRecognizeForTarget:(UIViewController*)currenTarget
{
    UIGestureRecognizer* gesture = currenTarget.navigationController.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView* gestureView = gesture.view;
    
    NSMutableArray* _targets = [gesture valueForKey:@"_targets"];
    id gestureRecogizerTarget = [_targets firstObject];
    id navigationInteractiveTransition = [gestureRecogizerTarget valueForKey:@"_target"];
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:handleTransition];
    [gestureView addGestureRecognizer:pan];
}


#pragma mark 提示框
+ (void)tipWithText:(NSString *)text onView:(UIView *)view
{
    [FMUtils tipWithText:text onView:view withCompeletHandler:nil];
}

+ (void)tipWithText:(NSString*)text onView:(UIView *)view withCompeletHandler:(FMGeneralBlock)compeletBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud setYOffset:PJ_SCREEN_HEIGHT/4];
    [hud hide:YES afterDelay:1.5];
    hud.completionBlock = compeletBlock;
}

+ (UIView*)showInfoCanvasOnTarget:(id)target action:(SEL)buttonSel{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, (PJ_SCREEN_HEIGHT-100)/2, PJ_SCREEN_WIDTH, 200)];
    
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_icon_noweb"]];
    image.frame = CGRectMake((PJ_SCREEN_WIDTH - 60)/2,0, 60, 60);
    [view addSubview:image];
    
    UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, PJ_SCREEN_WIDTH, 24)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:14];
    lab.textColor = RGBA(51, 51, 51, 1);
    lab.text = @"网络异常，请确认当前网络是否连接";
    [view addSubview:lab];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((PJ_SCREEN_WIDTH - 60)/2, 104, 60, 44)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [button setTitleColor:RGBA(255, 0, 0, 255) forState:UIControlStateNormal];
    [button addTarget:target action:buttonSel forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

#pragma mark 字符串处理
+ (BOOL)isBlankString:(NSString *)string
{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString *)getExplicitServerAPIURLPathWithSuffix:(NSString *)urlStr{
    return [NSString stringWithFormat:@"%@%@",kFMTAPIHost,urlStr];
}


+ (NSString *)cutString:(NSString *)str Prefix:(NSString *)pre
{
    NSRange range = [str rangeOfString:pre];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" :-''""{}"];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString* ns2 = [str stringByTrimmingCharactersInSet:set];
    return [ns2 substringWithRange:NSMakeRange(range.location+range.length, ([ns2 length]-(range.location+range.length)))];
}

+ (NSString *)resetString:(NSString *)str
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" :-'''"""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* ns2 = [str stringByTrimmingCharactersInSet:set];
    return ns2;
}

+ (CGSize)calculateTitleSizeWithString:(NSString *)string AndFontSize:(CGFloat)fontSize
{
    return [self calculateStringSizeWithString:string Font:SYSTEMFONT(fontSize) Width:280];
}

+ (CGSize)calculateTitleSizeWithString:(NSString *)string WithFont:(UIFont *)font
{
    return [self calculateStringSizeWithString:string Font:font Width:280];
}

+ (CGSize)calculateStringSizeWithString:(NSString *)string Font:(UIFont *)font Width:(CGFloat)width
{
    NSDictionary *dic = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

+ (NSMutableAttributedString*)stringWithDeleteLine:(NSString *)string
{
    NSUInteger length = [string length];
    if (0 == length) {
        return nil;
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(0x999999) range:NSMakeRange(0, length)];
    return attri;
}


#pragma mark 界面控制器处理
+ (UIViewController*)getViewControllerFromStoryboard:(NSString*)storyboardName andVCName:(NSString*)vcName
{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    return [story instantiateViewControllerWithIdentifier:vcName];
}

+ (UIViewController*)getViewControllerInUINavigator:(UINavigationController*)navi withClass:(Class)_class
{
    UIViewController* vc;
    for (vc in navi.viewControllers)
    {
        if ([vc isKindOfClass:_class])
        {
            break;
        }
    }
    return vc;
}

+ (id)getXibViewByName:(NSString*)xibName
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil];
    return [nib objectAtIndex:0];
}


/**
 * @baseViewController  当前视图控制器，承载弹窗视图控制器
 * @myViewController    弹窗视图控制器
 */
//+ (void)showMyWindowOnTarget:(UIViewController*)baseViewController withPopVc:(UIViewController*)popViewController
//{
//    //初始化一个自定义弹窗视图
//    UIWindow *myWindow = [[UIWindow alloc] initWithFrame:baseViewController.popWindowInitialRect];
//    baseViewController.window = myWindow;
//    myWindow.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:baseViewController.windowAlpha];
//    myWindow.windowLevel = UIWindowLevelNormal;
//    myWindow.hidden = NO;
//    myWindow.rootViewController = popViewController;
//    [myWindow makeKeyAndVisible];
//
//    //动态给当前基础视图控制器添加点击回调函数（隐藏弹窗视图）
//    SEL dismissPopview = sel_registerName("tapToHidePopViewAction:");
//    class_addMethod([baseViewController class],dismissPopview,(IMP)tapToHidePopViewAction,"v@:");
//
//    //当前视图控制器的upView上添加手势监测
//    //初始化upView
//    baseViewController.upView = [[UIView alloc] initWithFrame:baseViewController.view.bounds];
//    baseViewController.upView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    baseViewController.upView.alpha = 0.0;
//    //添加背景层点击隐藏手势、向右侧滑隐藏手势、向下滑隐藏手势和弹出页向右侧滑隐藏手势
//    [baseViewController.upView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:baseViewController action:dismissPopview]];
//    [baseViewController.upView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:baseViewController action:dismissPopview]];
//    [popViewController.view addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:baseViewController action:dismissPopview]];
//    UISwipeGestureRecognizer* downGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:baseViewController action:dismissPopview];
//    [downGesture setDirection:UISwipeGestureRecognizerDirectionDown];
//    [baseViewController.upView addGestureRecognizer:downGesture];
//    //将upView添加到当前View上
//    [baseViewController.view addSubview:baseViewController.upView];
//
//
//    //动画出现弹窗视图
//    __weak typeof(baseViewController) weakSelf = baseViewController;
//    [UIView animateWithDuration:0.5 animations:^{
//        weakSelf.windowAlpha = 1.0f;
//        weakSelf.window.frame =  weakSelf.popWindowDestineRect;
//        weakSelf.upView.alpha = 1.0;
//    } completion:nil];
//    baseViewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}

//void tapToHidePopViewAction(id sender, SEL _cmd)
//{
//    //此为当前视图控制器，这是upView上手势的回调函数，已动态添加到当前视图控制器
//
//    UIViewController* baseViewController = ((UIViewController*)sender);
//    __weak typeof(baseViewController) weakSelf = baseViewController;
//    [UIView animateWithDuration:0.5 animations:^{
//        weakSelf.window.frame = weakSelf.popWindowInitialRect;
//        weakSelf.windowAlpha = 1.0f;
//        weakSelf.upView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [weakSelf.upView removeFromSuperview];
//            [weakSelf.window resignKeyWindow];
//            weakSelf.window  = nil;
//            weakSelf.upView = nil;
//            weakSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }];
//}


//+ (void)showSearchView:(CZJViewController*)target andNaviBar:(CZJNaviagtionBarView*)naviBar
//{
//    CZJSearchController* searchVC = (CZJSearchController*)[self getViewControllerFromStoryboard:@"Main" andVCName:@"searchVCSBID"];
//    searchVC.parent = target;
//
//    //把searchVC加入到当前navigationController中
//    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT)];
//    window.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
//    window.windowLevel = UIWindowLevelNormal;
//    window.hidden = NO;
//    window.rootViewController = searchVC;
//    target.window = window;
//    [window makeKeyAndVisible];
//
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        target.window.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT);
//        ((CZJSearchController*)searchVC).delegate = naviBar ? naviBar : target;
//        ((CZJSearchController*)searchVC).detailType = naviBar.detailType;
//    } completion:^(BOOL finished) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }];
//}

//+ (void)removeSearchVCFromCurrent:(CZJViewController*)target
//{
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
//     {
//         target.window.frame = CGRectMake(0, PJ_SCREEN_HEIGHT, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT);
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//     }
//                     completion:^(BOOL finished)
//     {
//         if (finished) {
//             [target.window resignKeyWindow];
//             target.window  = nil;
//         }
//     }];
//}


//+ (BOOL)isLoginIn:(CZJViewController*)target andNaviBar:(CZJNaviagtionBarView*)naviBar
//{
//    return YES;
//    if ([USER_DEFAULT boolForKey:kCZJIsUserHaveLogined])
//    {
//        return YES;
//    }
//    else
//    {
//        [self showLoginView:target andNaviBar:nil];
//        return NO;
//    }
//}

//+ (void)showLoginView:(CZJViewController*)target andNaviBar:(CZJNaviagtionBarView*)naviBar
//{
//
//    //由storyboard根据LoginView获取到登录界面
//    TICK;
//    UINavigationController* loginView = (UINavigationController*)[self getViewControllerFromStoryboard:@"Main" andVCName:@"LoginView"];
//
//    ((CZJLoginController*)loginView.topViewController).delegate = naviBar ? naviBar : target;
//    [target presentViewController:loginView animated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }];
//    TOCK;
//}


//+ (void)removeLoginViewFromCurrent:(CZJViewController*)target
//{
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
//     {
//         target.window.frame = CGRectMake(0, PJ_SCREEN_HEIGHT, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT);
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//     }
//                     completion:^(BOOL finished)
//     {
//         if (finished) {
//             [target.window resignKeyWindow];
//             target.window  = nil;
//         }
//     }];
//}


//+ (void)showCommitOrderView:(UIViewController *)target andParams:(NSArray*)_settleOrderAry
//{
//    UINavigationController* commitVC = (UINavigationController*)[CZJUtils getViewControllerFromStoryboard:kCZJStoryBoardFileMain andVCName:@"OrderSettleNavi"];
//    CZJCommitOrderController* settleOrder = ((CZJCommitOrderController*)commitVC.topViewController);
//    settleOrder.settleParamsAry = _settleOrderAry;
//    settleOrder.isUseCouponAble = YES;
//    [target presentViewController:commitVC animated:YES completion:^
//     {
//     }];
//}

//+ (void)showShoppingCartView:(CZJViewController*)target  andNaviBar:(CZJNaviagtionBarView*)naviBar
//{
//    //由storyboard根据LoginView获取到登录界面
//    UINavigationController *shopping = (UINavigationController*)[self getViewControllerFromStoryboard:@"Main" andVCName:@"ShoppingCart"];
//
//    //把loginView加入到当前navigationController中
//    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(PJ_SCREEN_WIDTH, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT)];
//    window.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
//    window.windowLevel = UIWindowLevelNormal;
//    window.hidden = NO;
//    window.rootViewController = shopping;
//    target.window = window;
//    [window makeKeyAndVisible];
//
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        target.window.frame = CGRectMake(0, 0, PJ_SCREEN_WIDTH, PJ_SCREEN_HEIGHT);
//        ((CZJShoppingCartController*)shopping.topViewController).delegate = naviBar ? naviBar : target;
//    } completion:^(BOOL finished) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }];
//}


#pragma mark 其它方法
+ (BOOL)isTimeCrossOneDay
{//判断俩次启动相隔时长
    
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970];     //当前时间
    UInt64 lastUpdateTime = [[USER_DEFAULT valueForKey:kUserDefaultTimeDay] longLongValue];   //上次更新时间
    UInt64 intervalTime = currentTime - lastUpdateTime;
    if (0 == lastUpdateTime ||
        intervalTime > 86400)
    {
        [USER_DEFAULT setValue:[NSString stringWithFormat:@"%llu",currentTime] forKey:kUserDefaultTimeDay];
        return YES;
    }
    return NO;
}


+ (BOOL)isTimeCrossFiveMin:(int)intervalMin
{
    return [self isTimeCrossMinInterval:intervalMin withIdentity:kUserDefaultTimeMin];
}

+ (BOOL)isTimeCrossMinInterval:(int)intervalTimer withIdentity:(NSString*)userDefault
{
    UInt64 currentTime = [[NSDate date] timeIntervalSince1970];     //当前时间
    UInt64 lastUpdateTime = [[USER_DEFAULT valueForKey:userDefault] longLongValue];   //上次更新时间
    UInt64 intervalTime = currentTime - lastUpdateTime;
    if (0 == lastUpdateTime ||
        intervalTime > intervalTimer*60)
    {
        [USER_DEFAULT setValue:[NSString stringWithFormat:@"%llu",currentTime] forKey:userDefault];
        return YES;
    }
    return NO;
}

+ (FMDateTime*)getLeftDatetime:(NSInteger)timeStamp
{
    FMDateTime* dateTime = [[FMDateTime alloc]init];
    NSInteger ms = timeStamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSString* hourStr = [NSString stringWithFormat:@"%ld", hour];
    if (hour < 10)
    {
        hourStr =[NSString stringWithFormat:@"0%ld", hour];
    }
    
    NSString* minutesStr = [NSString stringWithFormat:@"%ld", minute];
    if (minute < 10)
    {
        minutesStr = [NSString stringWithFormat:@"0%ld", minute];
    }
    
    NSString* secondStr = [NSString stringWithFormat:@"%ld", second];
    if (second < 10)
    {
        secondStr = [NSString stringWithFormat:@"0%ld", second];
    }
    
    dateTime.day = [NSString stringWithFormat:@"%ld", day];
    dateTime.hour = hourStr;
    dateTime.minute = minutesStr;
    dateTime.second = secondStr;
    return dateTime;
}

+ (NSString*)getCurrentHourTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}


+ (NSString*)getCurrentDateTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString*)getFullDateTime:(NSInteger)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    return dateTime;
}

//+ (NSString*)getChatDatetime:(NSInteger)chatTime
//{
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"HH:mm"];
//    NSString* dateTime = [[NSDate dateWithTimeIntervalInMilliSecondSince1970:chatTime] formattedTime];
//    return dateTime;
//}

+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:skillTime];
    NSString* dateTime = [formatter stringFromDate:date];
    return dateTime;
}

+ (void)printClassMethodList:(id)target
{
    Class currentClass=[target class];
    while (currentClass) {
        unsigned int methodCount;
        Method *methodList = class_copyMethodList(currentClass, &methodCount);
        unsigned int i = 0;
        for (; i < methodCount; i++) {
            NSLog(@"%@ - %@", [NSString stringWithCString:class_getName(currentClass) encoding:NSUTF8StringEncoding], [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
        }
        
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
}

+ (void)printClassMemberVarible:(id)target
{
    unsigned int count = 0;
    Ivar* var = class_copyIvarList([target class], &count);
    for (int i = 0; i < count; i++)
    {
        Ivar _var = *(var + i);
        DLog(@"%s, %s",ivar_getTypeEncoding(_var), ivar_getName(_var));
    }
}

+ (void)performBlock:(FMGeneralBlock)block afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

+ (void)callHotLine:(NSString*)phoneNum AndTarget:(id)target
{
    /*  第一种调用拨打电话的方式
     NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNum];
     UIWebView * callWebview = [[UIWebView alloc] init];
     [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
     [target addSubview:callWebview];
     */
    if ([self isCanSIMCardAvaiable])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

+ (BOOL)isCanSIMCardAvaiable
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        [self tipWithText:@"未安装SIM卡" onView:nil];
        return NO;
    }
    return YES;
}

+ (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point andNumOfMenu:(int)_numOfMenu
{
    
    CGSize size = [self calculateTitleSizeWithString:string AndFontSize:15];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (PJ_SCREEN_WIDTH / _numOfMenu) - 25) ? size.width : PJ_SCREEN_WIDTH / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 15.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}


@end
