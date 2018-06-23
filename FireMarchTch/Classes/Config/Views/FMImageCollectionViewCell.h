//
//  FMImageCollectionViewCell.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWUploadTask.h"

@interface FMImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic, strong)CWUploadTask *uploadTask;


@end
