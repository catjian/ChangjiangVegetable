//
//  BookShelfViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BookShelfViewController.h"
#import "BookShelfBaseView.h"

@interface BookShelfViewController () <UITextFieldDelegate>

@end

@implementation BookShelfViewController
{
    BookShelfBaseView *m_BaseView;
    UIView *m_SearchView;
    UITextField *m_SearchTextField;
    NSArray *m_Articleclassify;
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
    [self setNavTarBarTitle:@"书架"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[BookShelfBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
    }
}

@end
