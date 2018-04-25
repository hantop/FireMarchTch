//
//  FMImageCollectionViewCell.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMImageCollectionViewCell.h"

@implementation FMImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addImageView.hidden = YES;
    // Initialization code
}

@end
