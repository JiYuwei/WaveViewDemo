//
//  BaseTabBarController.m
//  WaveViewDemo
//
//  Created by 纪宇伟 on 2017/6/22.
//  Copyright © 2017年 jyw. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "MeViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem.title = @"首页";
    homeNav.tabBarItem.image = [UIImage imageNamed:@"index_icn_inactive"];
    homeNav.tabBarItem.selectedImage = [UIImage imageNamed:@"index_icn_active"];

    
    MeViewController *meVC = [[MeViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];
    meNav.tabBarItem.title = @"我";
    meNav.tabBarItem.image = [UIImage imageNamed:@"mine_icn_inactive"];
    meNav.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_icn_active"];
    
    self.viewControllers = @[homeNav,meNav];
    
    self.tabBar.tintColor = MAIN_COLOR;
    self.tabBar.translucent = NO;
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
