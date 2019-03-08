//
//  JYRDView.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import "JYRDView.h"

#import "RDLabel.h"

#define LOGO_COLOR   [UIColor colorWithRed:0.33 green:0.62 blue:0.91 alpha:1]

@interface JYRDView ()

@property(nonatomic,strong) RDLabel *groundLabel;
@property(nonatomic,strong) MaskView *maskView;
@property(nonatomic,strong) RDLabel *frountLabel;

@end


@implementation JYRDView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpViews];

    }
    return self;
}

-(void)setUpViews
{
    _groundLabel = [[RDLabel alloc] initWithFrame:self.bounds];
    _groundLabel.isLighted = YES;
    [self addSubview:_groundLabel];
    
    _maskView = [[MaskView alloc] initWithFrame:self.bounds];
    [self addSubview:_maskView];
    
    _frountLabel = [[RDLabel alloc] initWithFrame:self.bounds];
    _frountLabel.isLighted = NO;
    [_maskView addSubview:_frountLabel];
}

//OverWrite

-(void)setLogoColor:(UIColor *)logoColor
{
    if (_logoColor != logoColor) {
        _logoColor = logoColor;
    }
    
    _groundLabel.logoColor = _logoColor;
    _frountLabel.logoColor = _logoColor;
}

-(void)setLogoTitle:(NSString *)logoTitle
{
    if (_logoTitle != logoTitle) {
        _logoTitle = logoTitle;
    }
    
    _groundLabel.logoTitle = _logoTitle;
    _frountLabel.logoTitle = _logoTitle;
}

-(void)setWaveSpped:(CGFloat)waveSpped
{
    if (_waveSpped != waveSpped) {
        _waveSpped = waveSpped;
    }
    _maskView.waveSpeed = _waveSpped;
}

-(void)setWaveDirType:(WaveDirectionType)waveDirType
{
    if (_waveDirType != waveDirType) {
        _waveDirType = waveDirType;
    }
    _maskView.waveDirType = _waveDirType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
