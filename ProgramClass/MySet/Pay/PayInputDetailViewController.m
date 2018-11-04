//
//  PayInputDetailViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/5.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "PayInputDetailViewController.h"

@interface PayInputDetailViewController ()

@end

@implementation PayInputDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    DIF_HideTabBarAnimation(YES);
    [self setNavTarBarTitle:@"我要付款"];
}

@end
