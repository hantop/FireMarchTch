//
//  FMImageUploadView.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/9.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMImageUploadView.h"
#import "VPImageCropperViewController.h"
#import "FSDeletableImageView.h"
#import "AppDelegate.h"
#import <ZLPhotoModel.h>
#import <ZLPhotoActionSheet.h>

@interface FMImageUploadView ()
<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
VPImageCropperDelegate
>
@property (strong, nonatomic)  UIButton *picBtn;
@property (nonatomic, strong) NSArray<ZLPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSMutableArray *arrDataSources;
@end

@implementation FMImageUploadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.picBtn addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
        return self;
    }
    return nil;
}

- (void)addPicAction:(id)sender
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self];
}


- (void)setPicAry:(NSArray*)picAry
{
    [self.arrDataSources removeAllObjects];
    self.arrDataSources = [picAry mutableCopy];
    [self removeAllSubViewsExceptView:self.picBtn];
    
    
    for (int i = 0; i < self.arrDataSources.count; i++)
    {
        NSString* imgUrl = self.arrDataSources[i];
        CGRect imageFrame = [FMUtils viewFrameFromDynamic:CZJMarginMake(15, 10) size:CGSizeMake(60, 60) index:i divide:Divide subWidth:0];
        FSDeletableImageView* picImage = [[FSDeletableImageView alloc]initWithFrame:imageFrame andImageName:imgUrl];
        picImage.deleteButton.tag = i;
        [picImage.deleteButton addTarget:self action:@selector(picViewDeleteBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:picImage];
    }
    CGRect picBtnFrame = [FMUtils viewFrameFromDynamic:CZJMarginMake(15, 10) size:CGSizeMake(60, 60) index:(int)self.arrDataSources.count divide:Divide subWidth:0];
    self.picBtn.frame = picBtnFrame;
//    self.picBtnLeading.constant = picBtnFrame.origin.x;
//    self.picBtnTop.constant = picBtnFrame.origin.y;
}

- (void)picViewDeleteBtnHandler:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(deleteEvaluatePic:andIndex:)])
    {
        [_delegate deleteEvaluatePic:self.arrDataSources[sender.tag] andIndex:self.cellIndexPath];
    }
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([FMUtils isCameraAvailable] &&
            [FMUtils doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([FMUtils isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [(UIViewController*)_delegate presentViewController:controller
                                                       animated:YES
                                                     completion:^(void){
                                                         NSLog(@"Picker View Controller is presented");
                                                     }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([FMUtils isPhotoLibraryAvailable]) {
            ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
            //设置照片最大选择数
            actionSheet.configuration.maxSelectCount = 5;
            //设置照片最大预览数
            actionSheet.configuration.maxPreviewCount = 10;
            actionSheet.sender = self.delegate;
            weakSelf(self);
            [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
                strongSelf(weakSelf);
                strongSelf.arrDataSources = [images mutableCopy];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[FMUtils getCurrentVC].view animated:YES];
                hud.label.text = @"上传中";
                [[FMTBaseDataManager sharedFMTBaseDataManager] uploadImages:self.arrDataSources param:@{@"imageType" : @"1"} progress:nil success:^(id json) {
                    NSArray* tmpAry = json[@"data"];
                    NSMutableArray* urls = [NSMutableArray array];
                    for (NSDictionary* dictKey in tmpAry)
                    {
                        [urls addObject:dictKey[@"image_url"]];
                        
                    }
                    if ([_delegate respondsToSelector:@selector(addEvaluatePic:andIndex:)])
                    {
                        [_delegate addEvaluatePic:urls andIndex:self.cellIndexPath];
                    }
                } failure:^(id json){

                }];

            }];
            [actionSheet showPreviewAnimated:YES];
        }
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        //获取从ImagePicker返回来的图像信息生成一个UIImage
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [FMUtils imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, ((UIViewController*)_delegate).view.frame.size.width, ((UIViewController*)_delegate).view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [(UIViewController*)_delegate presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [[FMTBaseDataManager sharedFMTBaseDataManager] uploadImages:@[editedImage] param:nil progress:nil success:^(id json) {
            iLog(@"%@",[json description]);
            if ([_delegate respondsToSelector:@selector(addEvaluatePic:andIndex:)])
            {
                //                [_delegate addEvaluatePic:json[kResoponData][@"image1"][@"url"] andIndex:self.cellIndexPath];
            }
        } failure:^(id json){
            
        }];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}



- (UIButton *)picBtn {
    if (!_picBtn) {
        _picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_picBtn setImage:IMAGENAMED(@"uploadPhoto") forState:UIControlStateNormal];
        [self addSubview:_picBtn];
        [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.top.mas_equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
    }
    return _picBtn;
}

@end
