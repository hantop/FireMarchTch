//
//  FMImageCollectionViewCell.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMImageCollectionViewCell.h"

@interface FMImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *animationImage;
@property (assign, nonatomic) BOOL isAnimate;

@end

@implementation FMImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isAnimate = NO;
    self.addImageView.hidden = YES;
    
    [self.animationImage setImage:[IMAGENAMED(@"loading") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.animationImage setTintColor:WHITECOLOR];
    self.animationImage.hidden = YES;
    // Initialization code
}

- (void) startSpin {
    self.animationImage.hidden = NO;
    if (!_isAnimate) {
        _isAnimate = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    self.animationImage.hidden = YES;
    _isAnimate = NO;
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.4f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.animationImage.transform = CGAffineTransformRotate(self.animationImage.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (_isAnimate) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

@end
