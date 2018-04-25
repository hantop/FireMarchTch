//
//  FMTCourseCell.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/24.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTagsView.h"

@interface FMTCourseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseFeeLabel;
@property (weak, nonatomic) IBOutlet HXTagsView *courseContentView;

@end
