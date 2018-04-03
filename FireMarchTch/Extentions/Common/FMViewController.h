//
//  FMViewController.h
//  FireMarchTch
//
//  Created by Joe.Pen on 02/04/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMViewControllerDelegate <NSObject>

@optional
- (void)didCancel:(id)controller;
- (void)didDone:(id)controller;
- (void)didDone:(id)controller Info:(id)info;
- (void)didDone:(id)controller Text1:(NSString*)text1 Text2:(NSString*)text2 HeadImage:(UIImage*)image;
@end


@interface FMViewController : UIViewController <FMViewControllerDelegate>

/* 弹出窗口初始位置 */
@property (nonatomic, assign) CGRect popWindowInitialRect;
/* 弹出窗口动画后的最终位置 */
@property (nonatomic, assign) CGRect popWindowDestineRect;
/* 当有背景透明需求的时候，在这里设置 (默认为1)*/
@property (nonatomic, assign) CGFloat windowAlpha;
/* 弹出窗口 */
@property (nonatomic, strong) UIWindow *window;
/* 背景View
 * (处于当前视图控制器顶部，弹出窗口底部，在此upView上添加一个手势监测，以便点击返回)
 */
@property (nonatomic, strong) UIView *upView;
/* 弹出框取消按钮回调 */
@property (nonatomic, copy) FMGeneralBlock cancleBlock;

/* 显示弹出框，带确认和取消回调 */
- (void)showFMAlertView:(NSString*)promptStr
       andConfirmHandler:(FMGeneralBlock)confirmBlock
        andCancleHandler:(FMGeneralBlock)cancleBlock;

/* 隐藏弹出框，弹出框必须u加载在window上的 */
- (void)hideWindow;

@end
