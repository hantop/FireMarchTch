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
#import "FMUploadManager.h"
typedef NS_ENUM(NSInteger, FMImageType) {
    FMImageTypePic = 0,
    FMImageTypeVideo
};

@interface FMTUpImageViewController () < UICollectionViewDelegate, UICollectionViewDataSource>
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
    tipView.subTitleLabel.text = @"照片视频让学生更直观的了解你";
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
    cell.maskView.hidden = NO;
    cell.addImageView.hidden = NO;
    cell.videoImage.hidden = YES;
    [cell stopSpin];
    switch (self.fmImageType) {
        case FMImageTypePic:
        {
            if (indexPath.item == self.photoPicUrlArray.count) {
                [cell.addImageView setImage:[IMAGENAMED(@"addSqure") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor:FSGrayColorA8];
                cell.maskView.hidden = YES;
            }
            else {
                
                [cell startSpin];
                cell.maskView.hidden = NO;
                [cell.addImageView setImage:[IMAGENAMED(@"arrowTop") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor:WHITECOLOR];
                //        NSString *urlStr = self.photoPicUrlArray[indexPath.item];
                //        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DefaultPlaceHolderSquare];
                [cell.imageView setImage:self.photoPicUrlArray[indexPath.item]];
                
                HWCircleView *circleProgressView = [HWCircleView new];
                [cell addSubview:circleProgressView];
                [circleProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.mas_equalTo(cell.center).offset(0);
                    make.size.mas_equalTo(CGSizeMake(60, 60));
                }];
                circleProgressView.progress = 0.0;
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
                cell.maskView.hidden = NO;
                [cell.addImageView setImage:[IMAGENAMED(@"arrowTop") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.addImageView setTintColor: WHITECOLOR];
                [cell.videoImage setImage:[IMAGENAMED(@"video") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                [cell.videoImage setTintColor: WHITECOLOR];
                //        NSString *urlStr = self.photoPicUrlArray[indexPath.item];
                //        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:DefaultPlaceHolderSquare];
                [cell.imageView setImage:self.photoVideoUrlArray[indexPath.item]];
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
                [actionSheet previewSelectedPhotos:self.photoPicUrlArray assets:self.lastSelectAssetsP index:indexPath.row isOriginal:self.isOriginal];
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
                [actionSheet previewSelectedPhotos:self.photoVideoUrlArray assets:self.lastSelectAssetsV index:indexPath.row isOriginal:self.isOriginal];
            }
        }
            break;
            
        default:
            break;
    }
    
}

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
}

- (void)nextStepAction:(id)sender {
    FMTCourseSetController *courseVC = [[FMTCourseSetController alloc] init];
    [self.navigationController pushViewController:courseVC animated:YES];
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
        [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            strongSelf(weakSelf);

            switch (strongSelf.fmImageType) {
                case FMImageTypePic:
                {
                    strongSelf.photoPicUrlArray = images.mutableCopy;
                    strongSelf.isOriginal = isOriginal;
                    strongSelf.lastSelectAssetsP = assets.mutableCopy;
                
                }
                    break;
                case FMImageTypeVideo:
                {
                    TICK;
//                    [[FMUploadManager sharedFMUploadManager] dealWithVideoPHAssets:assets complete:^{
//                        DLog(@"1");
//                        TOCK;
//                        [strongSelf.myPicCollectionView reloadData];
//                    }];
                    DLog(@"2");
                    strongSelf.photoVideoUrlArray = images.mutableCopy;
                    strongSelf.isOriginal = isOriginal;
                    strongSelf.lastSelectAssetsV = assets.mutableCopy;
                }
                    break;
                    
                default:
                    break;
            }
  
            
            
            
            self.fmImageType == FMImageTypePic ? [self photoAction:nil] : [self vedioAction:nil];
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[FMUtils getCurrentVC].view animated:YES];
//            hud.label.text = @"上传中...";
//            [[FMTBaseDataManager sharedFMTBaseDataManager] uploadImages:FMImageTypePic == self.fmImageType ? self.photoPicUrlArray : self.lastSelectAssetsV param:@{@"imageType" : @"1"} progress:nil success:^(id json) {
//                NSArray* tmpAry = json[@"data"];
//                for (NSDictionary* dictKey in tmpAry)
//                {
//                    switch (strongSelf.fmImageType) {
//                        case FMImageTypePic:
//                            [strongSelf.photoPicUrlArray addObject:dictKey[@"image_url"]];
//                            break;
//                        case FMImageTypeVideo:
//                            [strongSelf.photoVideoUrlArray addObject:dictKey[@"image_url"]];
//                            break;
//
//                        default:
//                            break;
//                    }
//
//                }
//                [strongSelf.myPicCollectionView reloadData];
//            } failure:^(id json){
//
//            }];
            
        }];
        
        actionSheet.cancleBlock = ^{
            NSLog(@"取消选择图片");
        };
        
        return actionSheet;
    }
    return nil;
}
@end
