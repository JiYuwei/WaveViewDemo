//
//  MaskView.h
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WaveDirectionType){
    WaveDirectionTypeFoward   = -1,   //从左到右
    WaveDirectionTypeBackWard = 1     //从右到左
};

@interface MaskView : UIView

@property(nonatomic,assign) CGFloat waveSpeed;
@property(nonatomic,assign) WaveDirectionType waveDirType;

@end

NS_ASSUME_NONNULL_END
