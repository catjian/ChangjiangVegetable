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
    DIF_HideTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_HideTabBarAnimation(YES);
    //        [self setLeftItemWithContentName::@"返回"];
    [self setNavTarBarTitle:@"热门推荐"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[HotVideoListBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setSelectBlock:^(NSIndexPath *indexPath, id model) {
            DIF_StrongSelf
            [strongSelf loadViewController:@"VideoPlayerViewController" hidesBottomBarWhenPushed:NO];
        }];
    }
    [self httpRequestPostGeHotVideoList];
}

#pragma mark - Http Request

- (void)httpRequestPostGeHotVideoList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGeHotVideoListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            DIF_StrongSelf
            [CommonHUD hideHUD];
            [strongSelf->m_BaseView setAllDataDic:responseModel[@"data"]];
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
