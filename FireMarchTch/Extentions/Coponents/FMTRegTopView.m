//
//  FMTRegTopView.m
//  FireMarchTch
//
//  Created by Joe.Pen on 2018/4/18.
//  Copyright © 2018 Joe.Pen. All rights reserved.
//

#import "FMTRegTopView.h"
#import <NSAttributedString+YYText.h>

@implementation FMTRegTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bigTitleLabel.text = @"";
        self.subTitleLabel.text = @"";
        [self.topLogoImageView setTintColor:FSGrayColorB8];
        self.backgroundColor = WHITECOLOR;
        return self;
    }
    return nil;
}


- (void)updateHeight {
    [_bigTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self getMessageHeight:_bigTitleLabel]);
    }];
    [_subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self getMessageHeight:_subTitleLabel]);
    }];
    
//    CGFloat introHeight = [FMUtils calculateStringSizeWithString:_subTitleLabel.text Font:_subTitleLabel.font Width:PJ_SCREEN_WIDTH - 40].height;
//    _subTitleLabel.width = introHeight + 50;
}
/**
 *  获取lb的高度（默认字体13，行间距8，lb宽ScreenWidth-100）
 *  @param mess lb.text
 *  @param lb (YYLabel *)label
 *  @return lb的高度
 */
-(CGFloat)getMessageHeight:(YYLabel *)lb
{
    CGFloat introHeight = [FMUtils calculateStringSizeWithString:lb.text Font:lb.font Width:PJ_SCREEN_WIDTH - 40].height;
    return introHeight;
}


- (MMLabel *)bigTitleLabel {
    if (!_bigTitleLabel) {
        _bigTitleLabel = [MMLabel new];
        _bigTitleLabel.font = SYSTEMFONT(24);
        _bigTitleLabel.keyWordFont = SYSTEMFONT(18);
        _bigTitleLabel.textColor = FSBlackColor33;
        _bigTitleLabel.textAlignment = NSTextAlignmentCenter;
        _bigTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bigTitleLabel.numberOfLines = 1;
        [self addSubview:_bigTitleLabel];
        [_bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(20);
            make.trailing.mas_equalTo(self).offset(-20);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self).offset(60);
        }];
    }
    return _bigTitleLabel;
}

- (YYLabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [YYLabel new];
        _subTitleLabel.font = SYSTEMFONT(15);
        _subTitleLabel.textColor = FSGrayColorA8;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.preferredMaxLayoutWidth = PJ_SCREEN_WIDTH -40;
        [self addSubview:_subTitleLabel];
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).offset(20);
            make.trailing.mas_equalTo(self).offset(-20);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(_bigTitleLabel.mas_bottom).offset(20);
        }];
    }
    return _subTitleLabel;
}

- (UIImageView *)topLogoImageView {
    if (!_topLogoImageView) {
        _topLogoImageView = [UIImageView new];
        [self addSubview:_topLogoImageView];
        [_topLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    return _topLogoImageView;
}

@end
