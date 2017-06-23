//
//  JYWaveView.h
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

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
