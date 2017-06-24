//
//  WeakProxy.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "WeakProxy.h"

@implementation WeakProxy

+(instancetype)proxyWithTarget:(id)target
{
    return [[self alloc] initWithTarget:target];
}

-(instancetype)initWithTarget:(id)target
{
    _target = target;
    return self;
}

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

@end
