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
    [self.navigationController setNavigationBarHidden:NO];
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
        [self httpRequestGetCart];
        DIF_WeakSelf(self)
        [m_BaseView setUpdateBlock:^{
            DIF_StrongSelf
            [strongSelf httpRequestCartUpdat];
        }];
    }
}

#pragma mark - httpRequest
- (void)httpRequestGetCart
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetCartWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             strongSelf->m_BaseView.dataArr = [NSMutableArray arrayWithArray:responseModel[@"data"][@"cartList"]];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }
     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

- (void)httpRequestCartUpdat
{
    NSMutableArray *cartList = [NSMutableArray array];
    for(NSDictionary *dic in m_BaseView.dataArr)
    {
        [cartList addObject:@{@"id":[@([dic[@"id"] intValue]) stringValue], @"num":[@([dic[@"number"] intValue]) stringValue]}];
    }
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestCartUpdateWithCartList:cartList
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             [strongSelf httpRequestGetCart];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }
     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

@end
