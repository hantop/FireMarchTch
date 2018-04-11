//
//  FMImageUploadView.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/9.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FMImageUploadViewDelegate <NSObject>
- (void)deleteEvaluatePic:(NSString*)url andIndex:(NSIndexPath*)indexP;;
- (void)addEvaluatePic:(NSArray*)urls andIndex:(NSIndexPath*)indexP;;
@end

@interface FMImageUploadView : UIView
@property (weak, nonatomic) id<FMImageUploadViewDelegate> delegate;
@property (strong, nonatomic) NSIndexPath* cellIndexPath;

- (void)setPicAry:(NSArray*)picAry;
@end
