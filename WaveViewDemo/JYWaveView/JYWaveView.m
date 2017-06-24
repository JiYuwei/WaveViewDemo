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
@property(nonatomic,strong)CAShapeLayer *frontWaveLayer;
@property(nonatomic,strong)CAShapeLayer *insideWaveLayer;

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
    CGFloat waveSpeedF; // 外层波形移动速度
    CGFloat waveSpeedS; // 内层波形移动速度
    
    WaveDirectionType direction; //移动方向
}

/*
 y = Asin(ωx+φ)+k
 A表示振幅，使用这个变量来调整波浪的高度
 ω表示频率，使用这个变量来调整波浪密集度
 φ表示初相，使用这个变量来调整波浪初始位置
 k表示高度，使用这个变量来调整波浪在屏幕中y轴的位置。
 */

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _proxy = [WeakProxy proxyWithTarget:self];
        
        [self configWaveProperties];
        [self createWaves];
    }
    
    return self;
}

-(void)configWaveProperties
{
    _frontColor    = [UIColor blackColor];
    _insideColor   = [UIColor grayColor];
    _frontSpeed    = 0.01;
    _insideSpeed   = 0.01 * 1.2;
    _waveOffset    = M_PI;
    _directionType = WaveDirectionTypeBackWard;
}

-(void)createWaves
{
    waveWidth   = self.frame.size.width;
    waveHeight  = self.frame.size.height;
    
    waveA       = waveHeight / 2;
    waveW       = (M_PI * 2 / waveWidth) / 1.5;
    offsetF     = 0;
    offsetS     = offsetF + _waveOffset;
    currentK    = waveHeight / 2;
    waveSpeedF  = _frontSpeed;
    waveSpeedS  = _insideSpeed;
    direction   = _directionType;
    
    _frontWaveLayer = [CAShapeLayer layer];
    _frontWaveLayer.fillColor = _frontColor.CGColor;
    [self.layer addSublayer:_frontWaveLayer];
    
    _insideWaveLayer = [CAShapeLayer layer];
    _insideWaveLayer.fillColor = _insideColor.CGColor;
    [self.layer insertSublayer:_insideWaveLayer below:_frontWaveLayer];
    
    
    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:self.proxy selector:@selector(refreshCurrentWave:)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//    [self refreshCurrentWave:nil];
}

-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offsetF += waveSpeedF * direction;
    offsetS += waveSpeedS * direction;
    
    [self drawCurrentWaveWithLayer:_frontWaveLayer offset:offsetF];
    [self drawCurrentWaveWithLayer:_insideWaveLayer offset:offsetS];
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


#pragma mark - WaveProperties Setter Methods

-(void)setFrontColor:(UIColor *)frontColor
{
    if (_frontColor != frontColor) {
        _frontColor = frontColor;
        _frontWaveLayer.fillColor = _frontColor.CGColor;
    }
}

-(void)setInsideColor:(UIColor *)insideColor
{
    if (_insideColor != insideColor) {
        _insideColor = insideColor;
        _insideWaveLayer.fillColor = _insideColor.CGColor;
    }
}

-(void)setFrontSpeed:(CGFloat)frontSpeed
{
    if (_frontSpeed != frontSpeed) {
        _frontSpeed = frontSpeed;
        waveSpeedF = _frontSpeed;
    }
}

-(void)setInsideSpeed:(CGFloat)insideSpeed
{
    if (_insideSpeed != insideSpeed) {
        _insideSpeed = insideSpeed;
        waveSpeedS = _insideSpeed;
    }
}

-(void)setWaveOffset:(CGFloat)waveOffset
{
    if (_waveOffset != waveOffset) {
        _waveOffset = waveOffset;
        offsetS = offsetF + _waveOffset;
    }
}

-(void)setDirectionType:(WaveDirectionType)directionType
{
    if (_directionType != directionType) {
        _directionType = directionType;
        direction = _directionType;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
