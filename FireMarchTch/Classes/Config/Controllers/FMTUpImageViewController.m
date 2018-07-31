//
//  FMTUpImageViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/9.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTUpImageViewController.h"
#import "UIView+SDAutoLayout.h"
#import "FMImageCollectionViewCell.h"
#import <ZLPhotoModel.h>
#import <ZLPhotoActionSheet.h>
#import <ZLPhotoManager.h>
#import "FMTCourseSetController.h"
#import "FMTRegTopView.h"
#import "HWCircleView.h"
#import "FMTImageUploadModel.h"
#import "CWFileUploadManager.h"
#import "CWFileStreamSeparation.h"
#import "CWUploadTask.h"
#import "CWFileManager.h"
typedef NS_ENUM(NSInteger, FMImageType) {
    FMImageTypePic = 0,
    FMImageTypeVideo
};

@interface FMTUpImageViewController () < UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate>
@property (nonatomic, assign) FMImageType fmImageType;
@property (strong, nonatomic) __block NSMutableArray *photoPicUrlArray;
@property (strong, nonatomic) __block NSMutableArray *photoVideoUrlArray;
@property (strong, nonatomic) __block NSMutableArray<FMTImageUploadModel *> *uploadPicModelArray;
@property (strong, nonatomic) __block NSMutableArray<FMTImageUploadModel *> *uploadVideoModelArray;
@property (strong, nonatomic)UICollectionView* myPicCollectionView;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssetsP;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssetsV;
@property (nonatomic, assign) BOOL isOriginal;


@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewLeading;

- (IBAction)photoAction:(id)sender;
- (IBAction)vedioAction:(id)sender;
- (IBAction)uploadAction:(id)sender;
- (void)nextStepAction:(id)sender;

@end

@implementation FMTUpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initTopView];
    [self initViews];
}

- (void)initTopView {
    FMTRegTopView *tipView = [FMTRegTopView new];
    [self.view addSubview:tipView];
    [self.view sendSubviewToBack:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.leading.mas_equalTo(self.view).offset(0);
        make.trailing.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(150);
    }];
    tipView.bigTitleLabel.text = @"②影像资料上传";
    tipView.subTitleLabel.text = @"照片";
    [tipView updateHeight];
}

- (void)initViews {
    self.photoPicUrlArray = [NSMutableArray array];
    self.photoVideoUrlArray = [NSMutableArray array];
    self.uploadPicModelArray = [NSMutableArray array];
    self.uploadVideoModelArray = [NSMutableArray array];
    self.fmImageType = FMImageTypePic;
    self.buttomViewWidth.constant = PJ_SCREEN_WIDTH*0.5;
    
    [self photoAction:nil];
    [self.myPicCollectionView reloadData];
    
    [[CWFileUploadManager shardUploadManager] removeAllUploadTask];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepAction:)];
    rightItem.width = 60.f;
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:BOLDSYSTEMFONT(16)} forState:UIControlStateNormal];
    [rightItem setTintColor:FSYellow];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (UICollectionView *)myPicCollectionView {
    if (!_myPicCollectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing=0.f;//左右间隔
        flowLayout.minimumLineSpacing=5.f;
        _myPicCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _myPicCollectionView.delegate = self;
        _myPicCollectionView.dataSource = self;
        _myPicCollectionView.clipsToBounds = YES;
        _myPicCollectionView.alwaysBounceVertical = YES;
        _myPicCollectionView.backgroundColor = WHITECOLOR;
        UINib *nib=[UINib nibWithNibName:@"FMImageCollectionViewCell" bundle:nil];
        [_myPicCollectionView registerNib: nib forCellWithReuseIdentifier:@"FMImageCollectionViewCell"];
        [_imageView addSubview:_myPicCollectionView];
        [_myPicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_imageView);
            make.size.mas_equalTo(_imageView);
        }];
        
    }
    return _myPicCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fmImageType == FMImageTypePic ? self.photoPicUrlArray.count + 1 : self.photoVideoUrlArray.count + 1;
}

//返回CollectionCell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FMImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView setImage:nil];
//    cell.maskView.hidden = NO;
    cell.addImageView.hidden = NO;
    cell.videoImage.hidden = YES;
    switch (self.fmImageType) {
        case FMImageTypePic:
        {
            if (indexPath.item == self.photoPicUrlArray.count) {
                [cell.addImageView setImage:[IMAGENAMED(@"addSqure") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor:FSGrayColorA8];
                cell.maskView.hidden = YES;
            }
            else {
//                cell.maskView.hidden = NO;
                [cell.addImageView setImage:[IMAGENAMED(@"arrowTop") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor:WHITECOLOR];
                [cell.imageView setImage:self.photoPicUrlArray[indexPath.item]];
//                cell.uploadTask = [CWFileUploadManager shardUploadManager].allTasks.allValues[indexPath.row - 1];
//                HWCircleView *circleProgressView = [HWCircleView new];
//                [cell addSubview:circleProgressView];
//                [circleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.center.mas_equalTo(cell.center).offset(0);
//                    make.size.mas_equalTo(CGSizeMake(60, 60));
//                }];
//                circleProgressView.progress = 0.0;
            }
        }
            break;
        case FMImageTypeVideo:
        {
            if (indexPath.item == self.photoVideoUrlArray.count) {
                cell.maskView.hidden = YES;
                [cell.addImageView setImage:[IMAGENAMED(@"addSqure") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor:FSGrayColorA8];
            }
            else {
                cell.videoImage.hidden = NO;
                [cell.addImageView setImage:[IMAGENAMED(@"arrowTop") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor: WHITECOLOR];
                [cell.videoImage setImage:[IMAGENAMED(@"video") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.videoImage setTintColor: WHITECOLOR];
                NSArray* taskAry = [CWFileUploadManager shardUploadManager].allTasks.allValues;
                NSInteger item = indexPath.item;
                cell.uploadTask = taskAry[item];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


//返回collectionCell尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int width = (PJ_SCREEN_WIDTH - 20)/3;
    int height = width;
    return CGSizeMake(width, height);
}


//返回
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.fmImageType) {
        case FMImageTypePic:
        {
            ZLPhotoActionSheet *actionSheet = [self getPas];
            [actionSheet.configuration setAllowSelectImage:YES];
            [actionSheet.configuration setAllowSelectVideo:NO];
            if (indexPath.item == self.photoPicUrlArray.count) {
                [actionSheet showPhotoLibrary];
            }
            else {
                [actionSheet previewSelectedPhotos:nil assets:self.lastSelectAssetsP index:indexPath.row isOriginal:self.isOriginal];
            }
            
        }
            break;
        case FMImageTypeVideo:
        {
            ZLPhotoActionSheet *actionSheet = [self getPas];
            [actionSheet.configuration setAllowSelectImage:NO];
            [actionSheet.configuration setAllowSelectVideo:YES];
            if (indexPath.item == self.photoVideoUrlArray.count) {

                [actionSheet showPhotoLibrary];
            }
            else {
                [actionSheet previewSelectedPhotos:nil assets:self.lastSelectAssetsV index:indexPath.row isOriginal:self.isOriginal];
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark- Action
- (IBAction)photoAction:(id)sender {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.buttomViewLeading.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
    self.fmImageType = FMImageTypePic;
    [self.photoButton setTitleColor:FSBlackColor00 forState:UIControlStateNormal];
    [self.videoButton setTitleColor:FSGrayColorB8 forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    NSString *sting = [NSString stringWithFormat:@"开始上传图片(%d/%lu)",0,(unsigned long)self.photoPicUrlArray.count];
    [self.uploadButton setTitle:sting forState:UIControlStateNormal];
    [self.myPicCollectionView removeAllSubViews];
    [self.myPicCollectionView reloadData];
}

- (IBAction)vedioAction:(id)sender {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        self.buttomViewLeading.constant = PJ_SCREEN_WIDTH*0.5;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    self.fmImageType = FMImageTypeVideo;
    [self.photoButton setTitleColor:FSGrayColorB8 forState:UIControlStateNormal];
    [self.videoButton setTitleColor:FSBlackColor00 forState:UIControlStateNormal];
    [self.uploadButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    NSString *sting = [NSString stringWithFormat:@"开始上传视频(%d/%lu)",0,(unsigned long)self.photoVideoUrlArray.count];
    [self.uploadButton setTitle:sting forState:UIControlStateNormal];
    [self.myPicCollectionView removeAllSubViews];
    [self.myPicCollectionView reloadData];
}

- (IBAction)uploadAction:(id)sender {
    switch (self.fmImageType) {
        case FMImageTypePic:
        {
            
        }
            break;
            
        case FMImageTypeVideo:
        {
            
        }
            break;
            
        default:
            break;
    }
}


- (ZLPhotoActionSheet *)getPas
{
    if ([FMUtils isPhotoLibraryAvailable]) {
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.configuration.maxSelectCount = 10;
        //设置照片最大预览数
        actionSheet.configuration.maxPreviewCount = 10;
        actionSheet.sender = self;
        actionSheet.arrSelectedAssets = FMImageTypePic == self.fmImageType ? self.lastSelectAssetsP : self.lastSelectAssetsV;
        weakSelf(self);
        __block NSString *filePathOriginal;
        [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            strongSelf(weakSelf);

            switch (strongSelf.fmImageType) {
                case FMImageTypePic:
                {
                    strongSelf.photoPicUrlArray = images.mutableCopy;
                    strongSelf.isOriginal = isOriginal;
                    strongSelf.lastSelectAssetsP = assets.mutableCopy;
                    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSData *data = UIImageJPEGRepresentation((UIImage *)obj, 1);
                        NSInteger size =  data.length;
                        
                        NSString *createPath =  [CachesDirectory stringByAppendingPathComponent:@"photo"];
                        NSFileManager *fileManager = [[NSFileManager alloc] init];
                        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
                        BOOL photo = [[NSFileManager defaultManager] fileExistsAtPath:createPath];
                        NSString *path = [CachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/photo/%.0f%@",[NSDate date].timeIntervalSince1970,@"test"]];
                        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                        NSError *error;
                        BOOL test = [[NSFileManager defaultManager] fileExistsAtPath:path];
                        [CWFileManager writeFileAtPath:createPath content:obj error:&error];
                        NSLog(@"%@",error);
                        BOOL isexist = [CWFileManager isFileAtPath:path error:&error];
                        NSLog(@"%@",error);
                        NSDictionary* dict = [ZLPhotoManager getVideoInfoWithSourcePath:path];
//                        CWUploadTask *task = [[CWFileUploadManager shardUploadManager] createUploadTask:path];
                    }];
                    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [ZLPhotoManager requestAssetFileUrl:obj complete:^(NSString *filePath) {
                            filePathOriginal = filePath;
                            NSString *newpath1 = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@"/private"];
                            
                            NSError *error;
                            BOOL test = [[NSFileManager defaultManager] fileExistsAtPath:newpath1];
                            BOOL test1 = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                            [[NSFileManager defaultManager] attributesOfItemAtPath:newpath1 error:&error];
//                            BOOL isexist = [CWFileManager isFileAtPath:newpath1 error:&error];
                            NSLog(@"%@",error);
                            
                            NSDictionary* dict = [ZLPhotoManager getVideoInfoWithSourcePath:newpath1];

                            [ZLPhotoManager getPhotoBytesWithAsset:obj completion:^(NSString *photosBytes) {
                                NSLog(@"%@", photosBytes);
                                NSString *fileName = [filePath lastPathComponent];

                                NSString *newpath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
                                NSDictionary *argdict = @{@"fileName" : fileName,
                                                          @"fileSize" : photosBytes
                                                          };
                                [[FMTBaseDataManager sharedFMTBaseDataManager] generalPostNoTips:argdict success:^(id json) {
                                    NSLog(@"%@",json);
                                } url:kFMTAPIFileAuth];

//                                CWUploadTask *task = [[CWFileUploadManager shardUploadManager] createUploadTask:filePathOriginal];
                            }];
                        }];
                    }];
                    
                }
                    break;
                case FMImageTypeVideo:
                {
                    strongSelf.photoVideoUrlArray = images.mutableCopy;
                    strongSelf.isOriginal = isOriginal;
                    strongSelf.lastSelectAssetsV = assets.mutableCopy;
                    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [ZLPhotoManager requestAssetFileUrl:obj complete:^(NSString *filePath) {
                            __block UIImage *image;
                            [ZLPhotoManager requestOriginalImageDataForAsset:obj completion:^(NSData *data, NSDictionary *info) {
                                if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                                    image = [ZLPhotoManager transformToGifImageWithData:data];
                                    NSDictionary* dict = [ZLPhotoManager getVideoInfoWithSourcePath:filePath];
                                    NSString *fileName = [filePath lastPathComponent];
                                    NSDictionary *argdict = @{@"fileName" : fileName,
                                                              @"fileSize" : dict[@"size"]
                                                              };
                                    
                                    [[FMTBaseDataManager sharedFMTBaseDataManager] generalPostNoTips:argdict success:^(id json) {
                                        NSLog(@"%@",json);
                                        CWUploadTask *uploadTask = [[CWFileUploadManager shardUploadManager] createUploadTask:filePath withFileid:json[@"fileId"] andImage:image];
                                        [uploadTask taskResume];
                                        [self.myPicCollectionView reloadData];
                                    } url:kFMTAPIFileAuth];
                                }
                            }];
                        }];
                    }];
                    
                }
                    break;
                    
                default:
                    break;
            }
   
            
//            [self.myPicCollectionView reloadData];
//            self.fmImageType == FMImageTypePic ? [self photoAction:nil] : [self vedioAction:nil];
            
        }];
        
        actionSheet.cancleBlock = ^{
            NSLog(@"取消选择图片");
        };
        
        return actionSheet;
    }
    return nil;
}

- (void)nextStepAction:(id)sender {
    FMTCourseSetController *courseVC = [[FMTCourseSetController alloc] init];
    [self.navigationController pushViewController:courseVC animated:YES];
}

@end
