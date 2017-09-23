# WaveViewDemo
a demo about  trigonometric function
#####基础概念

正弦函数公式：y = Asin(ωx+φ)+k

不知道各位同学还记不记得高中数学里学过的这个函数，它的图形是一条波浪线，它的参数含义如下：
```
/*
 y = Asin(ωx+φ)+k
 A表示振幅，使用这个变量来调整波浪的高度
 ω表示频率，使用这个变量来调整波浪密集度
 φ表示初相，使用这个变量来调整波浪初始位置
 k表示高度，使用这个变量来调整波浪在屏幕中y轴的位置。
 */
```
还有一个参数 T 表示周期，这个参数用来确定函数图像重复的最小单位；
T = 2π／ω
为了可以更加直观的理解，这里给出函数图像：


![正弦函数波形图（y=sinx）](http://upload-images.jianshu.io/upload_images/6363544-86f5dd82504d5e37.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

A = 1，ω = 1，φ = 0，k = 0 时，函数图像如上图所示（一个周期）。通过修改这4个参数，我们可以画出任意一条想要的波浪线。

#####CALayer坐标系

CALayer中，坐标系的原点在左上角，也就是说我们屏幕上任意一个视图的坐标系看起来是这样的：

![CALayer坐标系](http://upload-images.jianshu.io/upload_images/6363544-78541887d4b38f9a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

想要获得和预览图中一样的效果，我们的参数需要这样设置：
- A = 视图高度／2
- ω = 2π／视图宽度 （将周期设为宽度，可根据需要自行调整）
- φ = 0
- k = A

第二条波浪线参数只需要将 φ 增加或减少 π ，即可将两条曲线的峰顶与峰底错开，看起来就像这样：
![我的页面](http://upload-images.jianshu.io/upload_images/6363544-91dffcd180e9281e.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)
红色区域即为波浪视图的宽高

![双波浪曲线坐标](http://upload-images.jianshu.io/upload_images/6363544-07b5e8d4417a8465.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)


#####开始封装

理解了基础的概念，下面我们开始封装一个JYWaveView用来显示这个波形；首先我们先创建这样一个页面：

![我的页面](http://upload-images.jianshu.io/upload_images/6363544-16cacf5a58fbd6ac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

个人页面上方使用一个自定义View作为tableview的headerView，下面是cell。

创建一个JYWaveView类，继承于UIView：
```
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WaveDirectionType){
    WaveDirectionTypeFoward   = -1,   //从左到右
    WaveDirectionTypeBackWard = 1     //从右到左
};

@interface JYWaveView : UIView

@property (nonatomic, strong) UIColor *frontColor;          //外层波形颜色，默认黑色
@property (nonatomic, strong) UIColor *insideColor;         //内层波形颜色，默认灰色
@property (nonatomic, assign) CGFloat frontSpeed;           //外层波形移动速度，默认0.01;
@property (nonatomic, assign) CGFloat insideSpeed;          //内层波形移动速度，默认0.01 * 1.2;
@property (nonatomic, assign) CGFloat waveOffset;           //两层波形初相差值，默认M_PI;
@property (nonatomic, assign) WaveDirectionType directionType;  //移动方向，默认从右到左;

@end

```

我们在头文件中声明一些可以自定义的属性，如波形颜色、移动速度、移动方向等。

接下来是.m文件：
```
#import "JYWaveView.h"

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
```

由于并不是所有的属性都支持自定义，为防止出问题，我们在绘图过程中使用私有的成员变量，而不直接使用属性。当外部属性发生改变时，我们可以重写属性的setter方法对相应的成员变量进行修改。

```
-(void)configWaveProperties
{
    _frontColor    = [UIColor blackColor];
    _insideColor   = [UIColor grayColor];
    _frontSpeed    = 0.01;
    _insideSpeed   = 0.01 * 1.2;
    _waveOffset    = M_PI;
    _directionType = WaveDirectionTypeBackWard;
}
```
```
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
}
```

变量初始化完成，下面我们使用CAShapeLayer绘制波浪线。
#####CAShapeLayer
CAShapeLayer继承自CALayer，属于CoreAnimation框架，可以使用CALayer的所有属性值，其动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况。关于CAShaperLayer的详细介绍可以移步 [CAShapeLayer简单介绍](http://www.jianshu.com/p/fb739cf7a133)

首先创建两个waveLayer：
```
@property(nonatomic,strong)CAShapeLayer *frontWaveLayer;
@property(nonatomic,strong)CAShapeLayer *insideWaveLayer;
```
```
_frontWaveLayer = [CAShapeLayer layer];
_frontWaveLayer.fillColor = _frontColor.CGColor; //设置填充颜色
[self.layer addSublayer:_frontWaveLayer];
    
_insideWaveLayer = [CAShapeLayer layer];
_insideWaveLayer.fillColor = _insideColor.CGColor;
[self.layer insertSublayer:_insideWaveLayer below:_frontWaveLayer]; //将第二个放在第一个下面
```

然后我们根据正弦函数公式画出两个波形：
```
-(void)drawCurrentWaveWithLayer:(CAShapeLayer *)waveLayer offset:(CGFloat)offset
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = currentK;
    CGPathMoveToPoint(path, nil, 0, y); //将点移动到坐标（0,k）
    
    //以1个像素为单位，[0,视图宽度]为定义域，遍历函数中所有的点，将点连成线
    for (NSInteger i = 0; i <= waveWidth; i++) {

        y = waveA * sin(waveW * i + offset) + currentK;
        
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    CGPathAddLineToPoint(path, nil, waveWidth, waveHeight); //将函数末尾与视图右下角相连
    CGPathAddLineToPoint(path, nil, 0, waveHeight); //连线到视图左下角
    
    CGPathCloseSubpath(path); //将当前点与起点相连并关闭path
    
    waveLayer.path = path; //设置path
    
    CGPathRelease(path);
}
```

然后我们在初始化方法中调用一下方法，两条波形就画出来了：
```
[self drawCurrentWaveWithLayer:_frontWaveLayer offset:offsetF];
[self drawCurrentWaveWithLayer:_insideWaveLayer offset:offsetS];
```

在tableview的headerView中，创建一个JYWaveView的实例：

```
@property(nonatomic,strong)JYWaveView *doubleWaveView;
```

```
-(void)setUpWaveView
{
    _doubleWaveView = [[JYWaveView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10)];
    [self addSubview:_doubleWaveView];
}
```
效果如图：

![我的页面](http://upload-images.jianshu.io/upload_images/6363544-83f1ddd5337e4db5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

修改一下波形的颜色：

```
_doubleWaveView.frontColor = [UIColor whiteColor];
_doubleWaveView.insideColor = [UIColor colorWithRed:0.4 green:0.78 blue:0.68 alpha:1];
```
```
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
```

![我的页面](http://upload-images.jianshu.io/upload_images/6363544-1f63122ce07f5d75.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)


波形画好了，那我们如何让他动起来呢？

#####CADisplayLink

也许你不知道什么是CADisplayLink，但你应该知道NSTimer，CADisplayLink与NSTimer一样也是一个定时器，不过不同的是，这是一个可以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
使用方式与NSTimer类似，创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。
关于CADisplayLink的详细介绍可以移步 [什么是CADisplayLink](http://www.jianshu.com/p/c35a81c3b9eb)

我们让波形动起来的原理就是使用CADisplayLink定时调用一个方法，在这个方法里改变波形的初相（φ）后进行重绘，由于重绘频率非常快（CADisplayLink默认帧率为60fps，即每1/60秒重绘一次）看上去就像波形在以某个速度平滑移动。

在JYWaveView中，创建一个CADisplayLink

```
@property(nonatomic,strong)CADisplayLink *waveDisplayLink;
```

```
_waveDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshCurrentWave:)];
[_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
```

这里runloop的Mode选择NSRunLoopCommonModes以保证我们滑动屏幕时波形的移动不会被暂停，原因这里不作详细解释，想要了解的同学可以移步 [Runloop学习笔记](http://www.jianshu.com/p/e4ce740ec3d9)

然后我们实现-refreshCurrentWave:
```
-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offsetF += waveSpeedF * direction; //direction为枚举值，正向为-1，逆向为1，通过改变符号改变曲线的移动方向
    offsetS += waveSpeedS * direction;
    
    //将之前创建曲线的方法移到这里
    [self drawCurrentWaveWithLayer:_frontWaveLayer offset:offsetF];
    [self drawCurrentWaveWithLayer:_insideWaveLayer offset:offsetS];
}
```

好了，现在波浪线可以动起来了。当然我们还可以对速度和方向进行定制：

```
_doubleWaveView.frontSpeed = 0.01;
_doubleWaveView.insideSpeed = 0.01; //让两条曲线的速度保持一致
_doubleWaveView.waveOffset = M_PI / 2; //更改两条波形交错的距离
_doubleWaveView.directionType = WaveDirectionTypeFoward; //正向移动
```
```
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
```

效果图：

![我的页面](http://upload-images.jianshu.io/upload_images/6363544-8e02dfabb72fd0fc.gif?imageMogr2/auto-orient/strip)

#####针对定时器释放的问题进行优化

我们的波浪线UI已经实现，由于个人页面一般放在TabbarController中与首页平级，不会频繁的创建销毁，照理说不作优化也不会出什么问题。不过还是有必要提一下，因为app中很多地方都会用到定时器，由于定时器与控制器循环引用很容易导致释放不掉的问题，我们用一个例子来具体说明。

在刚才的demo中创建一个新的Controller，在Controller中创建一个tableview，将waveView添加为cell的子视图，看起来像这样：

![波形测试](http://upload-images.jianshu.io/upload_images/6363544-586e543ff8fd5c7a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

然后我们使用个人页面中的“波形测试”跳转到这个页面，再从这个页面返回个人页面，重复以上操作数次（先来个50次吧，=。=）

之后我们看看内存及CPU使用情况：

![跳转前](http://upload-images.jianshu.io/upload_images/6363544-f3ebe0922148005e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![跳转后](http://upload-images.jianshu.io/upload_images/6363544-6b82c2f026a82215.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

仅仅做了跳转没干别的，CPU占用率爆满，内存也出现了小幅增长（出现内存泄漏），页面滑动卡顿感严重，我们可以使用Instruments测试一下fps：
![fps测试](http://upload-images.jianshu.io/upload_images/6363544-07f3c6417c06123f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Why？因为每次回到个人页面时控制器都没有被正确释放，定时器仍然丢在runloop里没拿出来，重复多次后CPU吃不消了。。。那么如何解决这个问题？

有些同学可能会在使用定时器的视图或控制器里这样写：
```
-(void)dealloc
{
    NSLog(@"WaveView dealloc");
    [_waveDisplayLink invalidate];
    _waveDisplayLink = nil;
}
```

不过测试表明这样并不能解决问题，因为控制器没有被释放的原因就是dealloc方法没有被正确调用，而导致dealloc不调用的原因就是定时器与控制器之间的循环引用，具体就是这个地方出了问题：

![问题](http://upload-images.jianshu.io/upload_images/6363544-dd0815cd5b69c21f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 定时器添加到 Runloop 的时候，会被 Runloop 强引用，然后定时器又会有一个对 Target 的强引用（也就是 self ）也就是说 NSTimer 强引用了 self ，导致 self 一直不能被释放掉，所以 self 的 dealloc 方法也一直未被执行。

那么我们可以在viewWillDisappear:中释放定时器么？可行，不过会非常麻烦，就拿上面这个例子来说，首先不谈能否在Controller中获取到tableview的所有cell，就算可以获取到，还要对每个cell中的waveView中的定时器执行释放操作，而且如果波形测试页面还有下级页面，退回来的时候还要逐一在对每个cell启动定时器，不然波形就不动了。。。

定时器用起来很方便，但释放的确是一件麻烦的事情，这里给出一种比较简便的解决方案（同时适用于NSTimer和CADisplayLink），我们仍然可以在dealloc中释放定时器，只要我们可以打破循环引用，dealloc方法就可以正常调用。

#####NSProxy

NSProxy是一个虚类，你可以通过继承它，并重写这两个方法以实现消息转发到另一个实例
```
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel;
```

有关NSProxy的详细信息可以移步 [什么是NSProxy](http://www.jianshu.com/p/6c1c386898e7)

首先我们创建一个类WeakProxy继承于NSProxy，实现一个弱引用：
```
#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property(nonatomic, weak, readonly) id target;

+(instancetype)proxyWithTarget:(id)target;

@end
```
```
+(instancetype)proxyWithTarget:(id)target
{
    return [[self alloc] initWithTarget:target];
}

-(instancetype)initWithTarget:(id)target
{
    _target = target;
    return self;
}
```
重写上面的两个方法，将消息转发给真正的对象：

```
//获得目标对象的方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_target methodSignatureForSelector:sel];
}

//转发给目标对象
-(void)forwardInvocation:(NSInvocation *)invocation
{
    if ([_target respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_target];
    }
}
```

然后我们在JYWaveView中，添加一个属性：

```
@property(nonatomic,strong)WeakProxy *proxy;
```

```
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _proxy = [WeakProxy proxyWithTarget:self]; //proxy对self有一个弱引用
        
        [self configWaveProperties];
        [self createWaves];
    }
    
    return self;
}
```

在创建CADisPlayLink时，将target改为proxy：
```
_waveDisplayLink = [CADisplayLink displayLinkWithTarget:_proxy selector:@selector(refreshCurrentWave:)];
[_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
```

这样以来，定时器强引用proxy，proxy弱引用控制器(这里是JYWaveView)并将消息转发给控制器，控制器此时不被任何对象强引用，当控制器销毁时便可以调用dealloc释放定时器，将定时器从runloop中移除后，所有资源都可以正确地被释放了。
