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
            if (index == -2)
            {
                [strongSelf gotoAllCommentView];
            }
            else
            {
                VideoPlayerViewController *vc = [strongSelf loadViewController:@"VideoPlayerViewController" hidesBottomBarWhenPushed:NO];
                vc.videoDic = strongSelf.videoList[index];
                vc.videoList = strongSelf.videoList;
            }
        }];
        [self httpRequestGetVideoDataByMenuId:self.videoDic[@"id"]?self.videoDic[@"id"]:self.videoDic[@"videoId"]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [m_BaseView.playerCon pause];
    [m_BaseView.playerCon stop];
    [m_BaseView.playerCon dismiss];
    [super viewWillDisappear:animated];
}

- (void)gotoAllCommentView
{
    NSDictionary *video = m_BaseView.videoDic[@"video"];
    AllCommentViewController *vc = [self loadViewController:@"AllCommentViewController"];
    vc.tradeId = video[@"id"]?video[@"id"]:video[@"videoId"];
}

#pragma mark - Http Request
- (void)httpRequestGetVideoDataByMenuId:(NSString *)menuId
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetVideoInfoWithTopicId:menuId
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             NSDictionary *data = responseModel[@"data"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 strongSelf->m_BaseView.videoDic = data;
                 strongSelf->m_BaseView.videoList = data[@"relateVideoList"];                 
             });
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     } FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

@end
