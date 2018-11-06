//
//  MySetViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/21.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MySetViewController.h"
#import "MySetBaseView.h"

@interface MySetViewController ()

@end

@implementation MySetViewController
{
    MySetBaseView *m_BaseView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_ShowTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[MySetBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setSelectBlock:^(NSIndexPath *indexPath, id model) {
            DIF_StrongSelf
            switch (indexPath.section)
            {
                case -2:
                    [strongSelf loadViewController:@"LoginViewController" hidesBottomBarWhenPushed:NO];
                    break;
                case -1:
                {
                    switch (indexPath.row)
                    {
                        case 0:
                            [strongSelf loadViewController:@"BookShelfViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 1:
                            [strongSelf loadViewController:@"SubmissionNotifyViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 2:
                            [strongSelf loadViewController:@"PayInputDetailViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        default:
                            [strongSelf loadViewController:@"MyOrderViewController" hidesBottomBarWhenPushed:NO];
                            break;
                    }
                }
                    break;
                case 0:
                {
                    switch (indexPath.row)
                    {
                        case 1:
                            [strongSelf loadViewController:@"MyCommentViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 2:
                        case 3:
                            [strongSelf loadViewController:@"SubscribeViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 4:
                            [strongSelf loadViewController:@"AddressAddViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 6:
                            [strongSelf loadViewController:@"AboutOurViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 7:
                            [strongSelf loadViewController:@"SettingViewController" hidesBottomBarWhenPushed:NO];
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

@end
