//
//  RDLabel.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import "RDLabel.h"

@implementation RDLabel
{
    UIColor *_logoColor;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.text = @"RD";
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:frame.size.width/2];
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
    }
    return self;
}

//OverWrite
-(void)setIsLighted:(BOOL)isLighted
{
    if (_isLighted != isLighted) {
        _isLighted = isLighted;
    }
    
    if (_isLighted) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = self.logoColor.CGColor;
        self.textColor = self.logoColor;
    }
    else{
        self.backgroundColor = self.logoColor;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.textColor = [UIColor whiteColor];
    }
}

-(void)setLogoTitle:(NSString *)logoTitle
{
    if (_logoTitle != logoTitle) {
        _logoTitle = logoTitle;
    }
    self.text = _logoTitle;
}

-(UIColor *)logoColor
{
    if (!_logoColor) {
        _logoColor = [UIColor blueColor];
    }
    return _logoColor;
}

-(void)setLogoColor:(UIColor *)logoColor
{
    if (_logoColor != logoColor) {
        _logoColor = logoColor;
    }
    [self setIsLighted:_isLighted];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
