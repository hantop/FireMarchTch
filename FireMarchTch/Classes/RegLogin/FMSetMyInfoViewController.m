//
//  FMSetMyInfoViewController.m
//  FireMarchTch
//
//  Created by Joe.Pen on 04/04/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMSetMyInfoViewController.h"
#import "LewPickerController.h"
#import "FMTUpImageViewController.h"

@interface FMSetMyInfoViewController ()
<
LewPickerControllerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (strong, nonatomic) NSArray<NSString *> *heightArray;
@property (strong, nonatomic) NSArray<NSString *> *oldArray;
@property (strong, nonatomic) NSArray<NSString *> *weightArray;
@property (strong, nonatomic) NSArray<NSString *> *bustArray;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) __block UIView* backgroundView;
@property (assign, nonatomic) NSInteger currentSelectHeight;
@property (assign, nonatomic) NSInteger currentSelectWeight;
@property (assign, nonatomic) NSInteger currentSelectOld;
@property (assign, nonatomic) NSInteger currentSelectBust;
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line4;
@property (weak, nonatomic) IBOutlet UITextField *heightLabel;
@property (weak, nonatomic) IBOutlet UITextField *weightLabel;
@property (weak, nonatomic) IBOutlet UITextField *bustLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldLabel;

- (IBAction)buttonAction:(id)sender;
- (IBAction)nextStepAction:(id)sender;

@end

@implementation FMSetMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FMUtils customizeNavigationBarForTarget:self];
    [self initViewsAndDatas];
    // Do any additional setup after loading the view from its nib.
}

- (void)initViewsAndDatas {
    self.line1.constant = 0.5;
    self.line2.constant = 0.5;
    self.line3.constant = 0.5;
    self.line4.constant = 0.5;
    
    self.bigTitleLabel.text = @"设置基本信息";
    self.bigTitleLabel.hidden = NO;
    
    self.heightArray = @[@"155-159cm",@"160-165cm",@"166-169cm",@"170-175cm",@"176-179cm",@"180+cm"];
    self.weightArray = @[@"40-45kg",@"46-49kg",@"50-55kg",@"56-59kg",@"60+kg"];
    self.bustArray = @[@"B", @"B+", @"C", @"C+", @"D", @"E", @"F",];
    self.oldArray = @[@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    [self.view endEditing:YES];
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.tag = ((UIButton*)sender).tag;
    LewPickerController *pickerController = [[LewPickerController alloc]initWithDelegate:self];
    pickerController.pickerView = _pickerView;
    
    [self.view addSubview:_backgroundView];
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }];
    
    [pickerController showInView:self.view];
    
    
    NSString *title = @"";
    switch (_pickerView.tag) {
        case 1:
            title = @"身高";
            [_pickerView selectRow:self.currentSelectHeight inComponent:0 animated:YES];
            break;
        case 2:
            title = @"体重";
            [_pickerView selectRow:self.currentSelectWeight inComponent:0 animated:YES];
            break;
        case 3:
            title = @"芳龄";
            [_pickerView selectRow:self.currentSelectOld inComponent:0 animated:YES];
            break;
        case 4:
            title = @"胸围";
            [_pickerView selectRow:self.currentSelectBust inComponent:0 animated:YES];
            break;
            
            
        default:
            break;
    }
    pickerController.titleLabel.text = title;
}

- (IBAction)nextStepAction:(id)sender {
    FMTUpImageViewController *imageUpVC = [[FMTUpImageViewController alloc] init];
    [self.navigationController pushViewController:imageUpVC animated:YES];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return self.heightArray.count;
            break;
            
        case 2:
            return self.weightArray.count;
            break;
            
        case 3:
            return self.oldArray.count;
            break;
            
        case 4:
            return self.bustArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return self.heightArray[row];
            break;
            
        case 2:
            return self.weightArray[row];
            break;
            
        case 3:
            return self.oldArray[row];
            break;
            
        case 4:
            return self.bustArray[row];
            break;
            
        default:
            break;
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark - LewPickerControllerDelegate
- (BOOL)lewPickerControllerShouldOKButtonPressed:(LewPickerController *)pickerController{
    switch (pickerController.pickerView.tag) {
        case 1:
            self.heightLabel.text = self.heightArray[[_pickerView selectedRowInComponent:0]];
            break;
            
        case 2:
            self.weightLabel.text = self.weightArray[[_pickerView selectedRowInComponent:0]];
            break;
            
        case 3:
            self.oldLabel.text = self.oldArray[[_pickerView selectedRowInComponent:0]];
            break;
            
        case 4:
            self.bustLabel.text = self.bustArray[[_pickerView selectedRowInComponent:0]];
            break;
            
        default:
            break;
    }
    [self closeBackgroundView];
    return  YES;
}

- (void)lewPickerControllerDidOKButtonPressed:(LewPickerController *)pickerController{
    NSLog(@"OK");
    [self closeBackgroundView];
}

- (void)lewPickerControllerDidCancelButtonPressed:(LewPickerController *)pickerController{
    NSLog(@"cancel");
    [self closeBackgroundView];
}

- (void)closeBackgroundView
{
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
    }];
}

@end
