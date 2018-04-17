//
//  HXTagAttribute.m
//  HXTagsView https://github.com/huangxuan518/HXTagsView
//  博客地址 http://blog.libuqing.com/
//  Created by Love on 16/6/30.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXTagAttribute.h"

@implementation HXTagAttribute

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIColor *normalColor = FSGrayColorA8;
        UIColor *normalBackgroundColor = [UIColor whiteColor];
        UIColor *selectedBackgroundColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
        
        _borderWidth = 0.5f;
        _borderColor = normalColor;
        _selectBorderColor = FSYellow;
        _cornerRadius = 5.0;
        _normalBackgroundColor = normalBackgroundColor;
        _selectedBackgroundColor = selectedBackgroundColor;
        _titleSize = 14;
        _textColor = normalColor;
        _keyColor = FSYellow;
        _tagSpace = 20;
    }
    return self;
}

@end
