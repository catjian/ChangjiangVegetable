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
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    DIF_HideTabBarAnimation(YES);
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
        DIF_WeakSelf(self)
        [m_BaseView setSelectBlock:^(NSIndexPath *indexPath, id model) {
           DIF_StrongSelf
            if (indexPath.row == strongSelf->m_BaseView.bookListArr.count){
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    [self httpRequestPostGetMyBookList];
}

#pragma mark - Http Request

- (void)httpRequestPostGetMyBookList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGetMyBookListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        DIF_StrongSelf
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            [CommonHUD hideHUD];
            [strongSelf->m_BaseView setBookListArr:responseModel[@"data"]];
        }
        else
        {
            [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
        }        
    } FailedBlcok:^(NSError *error) {
        DIF_StrongSelf
        [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
    }];
}

@end
