//
//  HomeViewController.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "HomeViewController.h"
#import "JYRDView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.rightBarButtonItem = item;
    
    JYRDView *rdView = [[JYRDView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    rdView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/3);
//    rdView.logoColor = [UIColor cyanColor];
//    rdView.logoTitle = @"NO";
//    rdView.waveSpped = 0.1;
//    rdView.waveDirType = WaveDirectionTypeBackWard;
    [self.view addSubview:rdView];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
//    label.center = CGPointMake(SCREENWIDTH / 2, SCREENHEIGHT / 2 - 40);
//    label.font =[UIFont systemFontOfSize:30];
//    label.textColor = MAIN_COLOR;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"这里是首页";
//
//    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
