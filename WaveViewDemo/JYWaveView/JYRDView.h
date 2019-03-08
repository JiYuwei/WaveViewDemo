//
//  JYRDView.h
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYRDView : UIView

@property(nonatomic,strong) UIColor *logoColor;              //主题颜色
@property(nonatomic,copy)   NSString *logoTitle;             //logo文字
@property(nonatomic,assign) CGFloat waveSpped;               //波形速度
@property(nonatomic,assign) WaveDirectionType waveDirType;   //波形方向

@end

NS_ASSUME_NONNULL_END
