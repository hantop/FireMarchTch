//
//  FMUtils.h
//  FireMarchTch
//
//  Created by Joe.Pen on 16/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
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
+ (NSString *)resetString:(NSString *)str;
+ (NSString *)cutString:(NSString *)str Prefix:(NSString *)pre;
+ (NSString *)getExplicitServerAPIURLPathWithSuffix:(NSString *)urlStr;
+ (NSMutableAttributedString *)stringWithDeleteLine:(NSString *)string;
+ (CGSize)calculateTitleSizeWithString:(NSString *)string WithFont:(UIFont *)font;
+ (CGSize)calculateTitleSizeWithString:(NSString *)string AndFontSize:(CGFloat)fontSize;
+ (CGSize)calculateStringSizeWithString:(NSString *)string Font:(UIFont *)font Width:(CGFloat)width;


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
+ (NSString*)getCurrentHourTime;
+ (NSString*)getDateTimeSinceTime:(NSInteger)skillTime;


#pragma mark- 系统处理
+ (void)performBlock:(FMGeneralBlock)block afterDelay:(NSTimeInterval)delay;
+ (void)printClassMethodList:(id)target;
+ (void)printClassMemberVarible:(id)target;
+ (void)callHotLine:(NSString*)phoneNum AndTarget:(id)target;
+ (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point andNumOfMenu:(int)_numOfMenu;
+ (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point;


#pragma mark- 相机处理
+ (BOOL)isCameraAvailable:(UIViewController*)base;
+ (BOOL)isCameraAvailable;
+ (BOOL)isRearCameraAvailable;
+ (BOOL)isFrontCameraAvailable;
+ (BOOL)doesCameraSupportTakingPhotos;
+ (BOOL)isPhotoLibraryAvailable;
+ (BOOL)canUserPickVideosFromPhotoLibrary;
+ (BOOL)canUserPickPhotosFromPhotoLibrary;
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;


#pragma mark- 缓存文件大小计算及清除
+ (float)fileSizeAtPath:(NSString *)path;
+ (float)folderSizeAtPath:(NSString *)path;
+ (void)clearFile:(NSString *)path andSuccess:(FMGeneralBlock)success;
+ (void)clearCache:(FMGeneralBlock)success;
+ (NSMutableArray*)getAggregationArrayFromArray:(NSArray*)sourcArray;


#pragma mark- 获取App当前版本号
+ (NSString*)getAppCurrentVersion;

@end
