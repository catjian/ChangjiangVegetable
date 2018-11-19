//
//  WebShopDetailViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/19.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "WebShopDetailViewController.h"

@interface WebShopDetailViewController ()

@end

@implementation WebShopDetailViewController
{
    UIWebView *m_WebView;
}

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
    // Do any additional setup after loading the view.
    [self setNavTarBarTitle:@"商品详情"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_WebView)
    {
        m_WebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_WebView];
        [m_WebView loadHTMLString:self.shopDetailDic[@"goods_desc"] baseURL:nil];
    }
}

@end
