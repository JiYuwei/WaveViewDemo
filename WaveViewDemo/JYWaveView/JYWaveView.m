//
//  JYWaveView.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "JYWaveView.h"
#import "WeakProxy.h"

@interface JYWaveView ()

@property(nonatomic,strong)CADisplayLink *waveDisplayLink;
@property(nonatomic,strong)CAShapeLayer *firstWaveLayer;
@property(nonatomic,strong)CAShapeLayer *secondWaveLayer;

@property(nonatomic,strong)WeakProxy *proxy;

@end

@implementation JYWaveView
{
    CGFloat waveWidth;
    CGFloat waveHeight;
    
    CGFloat waveA;      // A
    CGFloat waveW;      // ω
    CGFloat offsetF;    // φ firstLayer
    CGFloat offsetS;    // φ secondLayer
    CGFloat currentK;   // k
    CGFloat waveSpeed;  // 移动速度
}

/*
 y = Asin(ωx+φ)+k
 A表示振幅，使用这个变量来调整波浪的高度
 ω表示周期，使用这个变量来调整波浪密集度
 φ表示初相，使用这个变量来调整波浪初始位置
 k表示高度，使用这个变量来调整波浪在屏幕中y轴的位置。
 */

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _proxy = [WeakProxy alloc];
        _proxy.target = self;
        
        [self createWaves];
    }
    
    return self;
}

-(void)createWaves
{
    waveWidth  = self.frame.size.width;
    waveHeight = self.frame.size.height;
    
    waveA      = waveHeight / 2;
    waveW      = (M_PI * 2 / waveWidth) / 1.5;
    offsetF    = 0;
    offsetS    = M_PI;
    currentK   = waveHeight / 2;
    waveSpeed  = 0.01;
    
    
    _firstWaveLayer = [CAShapeLayer layer];
    _firstWaveLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:_firstWaveLayer];
    
    _secondWaveLayer = [CAShapeLayer layer];
    _secondWaveLayer.fillColor = [UIColor colorWithRed:0.4 green:0.78 blue:0.68 alpha:1].CGColor;
    [self.layer insertSublayer:_secondWaveLayer below:_firstWaveLayer];
    
    
    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:self.proxy selector:@selector(refreshCurrentWave:)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offsetF += waveSpeed;
    offsetS += waveSpeed * 1.2;
    
    [self drawCurrentWaveWithLayer:_firstWaveLayer offset:offsetF];
    [self drawCurrentWaveWithLayer:_secondWaveLayer offset:offsetS];
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
    CGPathAddLineToPoint(path, nil, 0, currentK);
    
    CGPathCloseSubpath(path);
    
    waveLayer.path = path;
    
    CGPathRelease(path);
}


-(void)dealloc
{
    NSLog(@"WaveView dealloc");
    [_waveDisplayLink invalidate];
    _waveDisplayLink = nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
