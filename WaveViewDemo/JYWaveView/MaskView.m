//
//  MaskView.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import "MaskView.h"
#import "WeakProxy.h"

@interface MaskView ()

@property(nonatomic,strong)CADisplayLink *waveDisplayLink;
@property(nonatomic,strong)CAShapeLayer *maskLayer;
@property(nonatomic,strong)WeakProxy *proxy;

@end

@implementation MaskView
{
    CGFloat waveWidth;
    CGFloat waveHeight;
    CGFloat offset;
    CGFloat waveA;      // A
    CGFloat waveW;      // ω
    CGFloat currentK;   // k
    CGFloat waveSpeedM;  // 波形移动速度
    WaveDirectionType direction; //移动方向
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _proxy = [WeakProxy proxyWithTarget:self];
        self.layer.masksToBounds =YES;
        [self createWaves];
    }
    return self;
}


-(void)createWaves
{
    waveWidth   = self.frame.size.width;
    waveHeight  = self.frame.size.height;
    
    waveA       = waveHeight / 5;
    waveW       = (M_PI * 2 / waveWidth) / 2;
    offset      = 0;
    currentK    = waveHeight / 2;
    waveSpeedM  = 0.03;
    direction   = WaveDirectionTypeBackWard;
    
    _maskLayer = [CAShapeLayer layer];
    self.layer.mask = _maskLayer;
    
    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:_proxy selector:@selector(refreshCurrentWave:)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offset += waveSpeedM * direction;
    
    [self drawCurrentWaveWithLayer:_maskLayer offset:offset];
}

-(void)drawCurrentWaveWithLayer:(CAShapeLayer *)waveLayer offset:(CGFloat)offset
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = currentK;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (NSInteger i = 0; i <= waveWidth; i++) {
        
        y = waveA * sin(waveW * i + offset) + currentK;
        
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    CGPathAddLineToPoint(path, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(path, nil, 0, waveHeight);
    
    CGPathCloseSubpath(path);
    
    waveLayer.path = path;
    
    CGPathRelease(path);
}

#pragma mark -
-(void)dealloc
{
    NSLog(@"WaveView dealloc");
    [_waveDisplayLink invalidate];
    _waveDisplayLink = nil;
}

//OverWrite
-(void)setWaveSpeed:(CGFloat)waveSpeed
{
    if (_waveSpeed != waveSpeed) {
        _waveSpeed = waveSpeed;
    }
    waveSpeedM = _waveSpeed;
}

-(void)setWaveDirType:(WaveDirectionType)waveDirType
{
    if (_waveDirType != waveDirType) {
        _waveDirType = waveDirType;
    }
    
    direction = _waveDirType;
}

@end
