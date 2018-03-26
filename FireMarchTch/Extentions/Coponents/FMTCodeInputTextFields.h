//
//  FMTCodeInputTextField.h
//  FireMarchTch
//
//  Created by Joe.Pen on 22/03/2018.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, FMTCodeType)
{
    FMTCodeTypeShort = 0,
    FMTCodeTypeLong
};

@interface FMTCodeInputTextFieldsConfig : NSObject
//
@property (strong, nonatomic) UIColor * tintColor;
//
@property (strong, nonatomic) UIColor * originBoderColor;
//
@property (assign, nonatomic) CGFloat cornerRadius;
//
@property (assign, nonatomic) FMTCodeType codeType;
//
@property (assign, nonatomic) CGSize textFieldSize;
//
@property(nonatomic) UIKeyboardType keyboardType;

- (instancetype)initWithCodeType:(FMTCodeType)type;
@end


@protocol FMTCodeInputTextFieldsDelegate <NSObject>
- (void)codeInputTextFieldOverWithString:(NSString *)codeStr;
@end

@interface FMTCodeInputTextFields : UIView
@property (weak, nonatomic) id<FMTCodeInputTextFieldsDelegate> delegate;
@property (strong, nonatomic) FMTCodeInputTextFieldsConfig *configuration;


- (instancetype)initWithConfiguration: (FMTCodeInputTextFieldsConfig *)configuration delegate: (id<FMTCodeInputTextFieldsDelegate>)delegate;

- (void)resetCodeInputTextField;
@end
