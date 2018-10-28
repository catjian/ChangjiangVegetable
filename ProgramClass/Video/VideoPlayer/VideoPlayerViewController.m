//
//  VideoPlayerViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/29.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "VideoPlayerBaseView.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController
{
    VideoPlayerBaseView *m_BaseView;
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
    [self setLeftItemWithContentName:@"返回"];    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[VideoPlayerBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
    }
}

@end
