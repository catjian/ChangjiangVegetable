//
//  HotVideoListViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "HotVideoListViewController.h"
#import "HotVideoListBaseView.h"

@interface HotVideoListViewController ()

@end

@implementation HotVideoListViewController
{
    HotVideoListBaseView *m_BaseView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_ShowTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_ShowTabBarAnimation(YES);
    [self setLeftItemWithContentName:@"返回"];
    [self setNavTarBarTitle:@"热门推荐"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[HotVideoListBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
    }
    else
    {
        //        [m_BaseView loadScrollView];
    }
}

@end
