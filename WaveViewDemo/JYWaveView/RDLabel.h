//
//  RDLabel.h
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2019/3/8.
//  Copyright © 2019 jyw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDLabel : UILabel

@property(nonatomic, assign) BOOL isLighted;
@property(nonatomic, copy) NSString *logoTitle;
@property(nonatomic, strong) UIColor *logoColor;

@end

NS_ASSUME_NONNULL_END
