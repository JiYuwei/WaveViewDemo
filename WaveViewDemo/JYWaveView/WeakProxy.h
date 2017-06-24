//
//  WeakProxy.h
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakProxy : NSProxy

@property(nonatomic, weak, readonly) id target;

+(instancetype)proxyWithTarget:(id)target;

@end
