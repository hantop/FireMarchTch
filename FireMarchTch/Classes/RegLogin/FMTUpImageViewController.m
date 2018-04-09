//
//  FMTUpImageViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/9.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUpImageViewController.h"
#import "CPAddEvaluationPhotoVCell.h"
#import "UIView+SDAutoLayout.h"
#import "FMImageUploadView.h"

@interface FMTUpImageViewController () <CPAddEvaluatePhotoDelegate>
@property (strong, nonatomic) FMImageUploadView *photoView;
@property (strong, nonatomic) NSMutableArray *photoPicArray;
@property (weak, nonatomic) IBOutlet UILabel *bigTitle;
@property (weak, nonatomic) IBOutlet UILabel *littleTitle;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@end

@implementation FMTUpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    self.photoPicArray = [NSMutableArray array];
    
    [self.imageView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.equalTo(self.imageView);
        make.height.equalTo(self.imageView);
    }];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteEvaluatePic:(NSString*)url andIndex:(NSIndexPath*)indexP
{
    [self.photoPicArray removeObject:url];
    [self updatePhotoView];
}

- (void)addEvaluatePic:(NSArray*)urls andIndex:(NSIndexPath*)indexP
{
    [self.photoPicArray addObjectsFromArray:urls];
    [self updatePhotoView];
}

- (void)updatePhotoView
{
    [self.photoView setSize_sd:CGSizeMake(PJ_SCREEN_WIDTH, (1 + self.photoPicArray.count/Divide) * 90)];
    [self.photoView setPicAry:self.photoPicArray];
}


- (FMImageUploadView *)photoView
{
    if (!_photoView) {
        _photoView = [[FMImageUploadView alloc]initWithSize:self.imageView.size];
        _photoView.delegate = self;
    }
    return _photoView;
}

@end
