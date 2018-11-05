//
//  AboutOurViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController ()

@end

@implementation AboutOurViewController

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
    [self setNavTarBarTitle:@"关于我们"];
}

@end
