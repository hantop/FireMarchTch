//
//  FMUtils.h
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 XWBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUtils : NSObject

#pragma mark- 数据解析
+ (NSData *)jsonDataFormData:(id)data;
+ (NSString *)jsonStringFromData:(id)data;
+ (NSArray *)arrayFromJsonString:(id)jsonString;
+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;

#pragma mark- 数据本地持久化
+ (BOOL)saveNSDataToDocumentDirectory:(NSData *)data withPlistName:(NSString *)plistName;
+ (BOOL)saveStringDataToDocumentDirectory:(NSString *)str withPlistName:(NSString *)plistName;
+ (BOOL)saveArrayToDocumentsDirectory:(NSMutableArray *)array withPlistName:(NSString *)plistName;
+ (BOOL)saveDictionaryToDocumentsDirectory:(NSMutableDictionary *)dict withPlistName:(NSString *)plistName;

#pragma mark- 从本地读取数据
+ (NSData *)readDataFromDocumentDirectoryWithName:(NSString *)plistName;
+ (NSString *)readStringDataFromDocumentDirectoryWithName:(NSString *)plistName;
+ (NSMutableArray *)readArrayFromDocumentsDirectoryWithName:(NSString *)plistName;
+ (NSMutableArray *)readArrayFromBundleDirectoryWithName:(NSString *)plistName;
+ (NSMutableDictionary *)readDictionaryFromDocumentsDirectoryWithPlistName:(NSString *)plistName;
+ (NSMutableDictionary *)readDictionaryFromBundleDirectoryWithPlistName:(NSString *)plistName;

#pragma mark- 正则判断
+ (BOOL)isCarNumberPlate:(NSString *)carNo;
+ (BOOL)isLicencePlate:(NSString *)plateNum;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

#pragma mark- 颜色和UI
+( UIColor *)getColorFromString:( NSString *)hexColor;
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
+ (void)customizeNavigationBarForTarget:(UIViewController*)target;
+ (void)customizeNavigationBarForTarget:(UIViewController *)target hiddenButton:(BOOL)hidden;
+ (void)fullScreenGestureRecognizeForTarget:(UIViewController *)currenTarget;

#pragma mark- 提示框
+ (void)tipWithText:(NSString *)text onView:(UIView *)view;
+ (void)tipWithText:(NSString *)text onView:(UIView *)view withCompeletHandler:(FMGeneralBlock)compeletBlock;
+ (UIView*)showInfoCanvasOnTarget:(id)target action:(SEL)buttonSel;

#pragma mark- 字符串处理
+ (BOOL)isBlankString:(NSString *)string;
+ (NSString *)getExplicitServerAPIURLPathWithSuffix:(NSString *)urlStr;
+ (NSString *)cutString:(NSString *)str Prefix:(NSString *)pre;
+ (NSString *)resetString:(NSString *)str;
+ (CGSize)calculateTitleSizeWithString:(NSString *)string WithFont:(UIFont *)font;
+ (CGSize)calculateTitleSizeWithString:(NSString *)string AndFontSize:(CGFloat)fontSize;
+ (CGSize)calculateStringSizeWithString:(NSString *)string Font:(UIFont *)font Width:(CGFloat)width;
+ (NSMutableAttributedString *)stringWithDeleteLine:(NSString *)string;

#pragma mark- 控制器处理
+ (UIViewController*)getViewControllerFromStoryboard:(NSString*)storyboardName andVCName:(NSString*)vcName;
+ (UIViewController*)getViewControllerInUINavigator:(UINavigationController*)navi withClass:(Class)_class;
+ (id)getXibViewByName:(NSString*)xibName;


#pragma mark- 时间处理
+ (BOOL)isTimeCrossOneDay;
+ (BOOL)isTimeCrossFiveMin:(int)intervalMin;
+ (BOOL)isTimeCrossMinInterval:(int)intervalTimer withIdentity:(NSString*)userDefault;
+ (FMDateTime*)getLeftDatetime:(NSInteger)timeStamp;
+ (NSString*)getCurrentDateTime;
+ (NSString*)getFullDateTime:(NSInteger)time;
//+ (NSString*)getChatDatetime:(NSInteger)chatTime;
+ (NSString*)getCurrentHourTime;
+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime;

#pragma mark- 系统处理
//延迟执行Block
+ (void)performBlock:(FMGeneralBlock)block afterDelay:(NSTimeInterval)delay;
//打印类所有方法和成员变量
+ (void)printClassMethodList:(id)target;
+ (void)printClassMemberVarible:(id)target;
//调用打电话
+ (void)callHotLine:(NSString*)phoneNum AndTarget:(id)target;
//创建字符Layer
+ (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point andNumOfMenu:(int)_numOfMenu;
+ (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point;

@end
