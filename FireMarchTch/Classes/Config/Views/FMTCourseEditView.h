//
//  FMTCourseEditView.h
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/25.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMJDropdownMenu.h"
#import "HXTagsView.h"

@interface FMTCourseEditView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *courseNameTextField;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *courseNumMenu;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *courseDurationMenu;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *courseFeeMenu;
@property (weak, nonatomic) IBOutlet HXTagsView *courseContentView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
