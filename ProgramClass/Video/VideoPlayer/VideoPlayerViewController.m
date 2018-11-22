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
    //        [self setLeftItemWithContentName::@"返回"];
    [self setNavTarBarTitle:@"视频详情"];
}

- (void)backBarButtonItemAction:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[VideoPlayerBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setMoreBlock:^(NSInteger index) {
            DIF_StrongSelf
            VideoPlayerViewController *vc = [strongSelf loadViewController:@"VideoPlayerViewController" hidesBottomBarWhenPushed:NO];
            vc.videoDic = strongSelf.videoList[index];
            vc.videoList = strongSelf.videoList;
        }];
    }
    m_BaseView.videoDic = self.videoDic;
    m_BaseView.videoList = self.videoList;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [m_BaseView.playerCon pause];
    [m_BaseView.playerCon stop];
    [m_BaseView.playerCon dismiss];
    [super viewWillDisappear:animated];
}

@end
