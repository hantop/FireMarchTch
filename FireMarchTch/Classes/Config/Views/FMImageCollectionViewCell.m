//
//  FMImageCollectionViewCell.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/11.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMImageCollectionViewCell.h"
#import "CWFileStreamSeparation.h"
#import "HWCircleView.h"

@interface FMImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *animationImage;
@property (assign, nonatomic) BOOL isAnimate;
@property (nonatomic, copy) NSString *statusText;
@property (weak, nonatomic) IBOutlet HWCircleView *processView;

@end

@implementation FMImageCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isAnimate = NO;
    self.addImageView.hidden = YES;
    self.processView.hidden = YES;
    
    [self registeNotification];
    // Initialization code
}

- (void)setUploadTask:(CWUploadTask *)uploadTask
{
    _uploadTask = uploadTask;
    [self.imageView setImage:_uploadTask.fileStream.image];
    self.maskView.hidden = NO;
    [self refreshUI:_uploadTask.fileStream];
}

#pragma mark - refresh UI
- (void)refreshUI:(CWFileStreamSeparation *)fileStream{
    if (![fileStream.md5String isEqualToString:_uploadTask.ID]) {
        return;
    }
    _maskView.hidden = NO;
    //根据是否在上传来决定上传箭头图片，进度条的显示
    if (fileStream.progressRate < 0.01) {
        _processView.hidden = YES;
        _addImageView.hidden = NO;
    }
    else
    {
        _processView.hidden = NO;
        _addImageView.hidden = YES;
        _processView.progress = fileStream.progressRate;
    }
    
    
    switch (fileStream.fileStatus) {
        case CWUploadStatusUpdownloading:
            _statusText = @"上传中...";
            break;
        case CWUploadStatusWaiting:
            _statusText = @"等待";
            break;
        case CWUploadStatusFinished:
            _statusText = @"完成";
            _maskView.hidden = YES;
            _processView.hidden = YES;
            break;
        case CWUploadStatusFailed:
            _statusText = @"失败";
            break;
        case CWUploadStatusPaused:
            _statusText = @"暂停";
            break;
        default:
            break;
    }

    
//    _uploadSizeLab.text = [NSString stringWithFormat:@"%zd/%zd",fileStream.uploadDateSize,fileStream.fileSize];
//    _rateLab.text = [NSString stringWithFormat:@"%.1f%%",fileStream.progressRate*100];
//    _uploadStatusLab.text = _statusText;
    if (fileStream.fileStatus == CWUploadStatusUpdownloading) {
//        _startOrStopBtn.selected = YES;
    }else{
//        _startOrStopBtn.selected = NO;
    }
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

- (void)registeNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeIng:) name:CWUploadTaskExeing object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeEnd:) name:CWUploadTaskExeEnd object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeError:) name:CWUploadTaskExeError object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskExeSupend:) name:CWUploadTaskExeSuspend object:nil];
}

- (void)taskExeIng:(NSNotification *)notification
{
    [self refreshUI:notification.userInfo[@"fileStream"]];
}

- (void)taskExeSupend:(NSNotification *)notification
{
    [self refreshUI:notification.userInfo[@"fileStream"]];
}

- (void)taskExeEnd:(NSNotification *)notification
{
    CWFileStreamSeparation *fs = notification.userInfo.allValues.firstObject;
    [self refreshUI:fs];
}

- (void)taskExeError:(NSNotification *)notification
{
    CWFileStreamSeparation *fs = notification.userInfo[@"fileStream"];
    NSError *error = (NSError *)notification.userInfo[@"error"];
    NSLog(@"%@,%@",fs,error);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
