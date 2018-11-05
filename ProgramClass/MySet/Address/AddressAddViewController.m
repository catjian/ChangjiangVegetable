//
//  AddressAddViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "AddressAddViewController.h"

@interface AddressAddViewController ()

@end

@implementation AddressAddViewController

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
    [self setNavTarBarTitle:@"添加收货地址"];
    UIButton *rightBtn = [self setRightItemWithContentName:@"保存"];
    [rightBtn setTitleColor:DIF_HEXCOLOR(@"fd763c") forState:UIControlStateNormal];
}

@end
