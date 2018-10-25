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
            switch (indexPath.row)
            {
                case -1:
                    [strongSelf loadViewController:@"LoginViewController" hidesBottomBarWhenPushed:NO];
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

@end
