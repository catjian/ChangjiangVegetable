//
//  ShopCartViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/1.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShopCartBaseView.h"

@interface ShopCartViewController ()

@end

@implementation ShopCartViewController
{
    ShopCartBaseView *m_BaseView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_HideTabBarAnimation(NO);
    [self setRightItemWithContentName:@"删除"];
    [self setNavTarBarTitle:@"购物车"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[ShopCartBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
    }
}
@end
