//
//  HotInformationViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "HotInformationViewController.h"
#import "HotInformationBaseView.h"

@interface HotInformationViewController () <UITextFieldDelegate>

@end

@implementation HotInformationViewController
{
    HotInformationBaseView *m_BaseView;
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
    [self setLeftItemWithContentName:@"返回"];
    [self createSearchView];
    [self.navigationItem setTitleView:m_SearchView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[HotInformationBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setSelectChannelBlock:^{
            DIF_StrongSelf
            SelectChannelViewController *vc = [strongSelf loadViewController:@"SelectChannelViewController"];
            [vc setNavTarBarTitle:@"我的频道"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < strongSelf->m_BaseView.channelArray.count; i++)
            {
                NSDictionary *channelDic = strongSelf->m_BaseView.channelArray[i];
                [dic setObject:channelDic[@"menuName"] forKey:[@(i) stringValue]];
            }
            vc.channelData = dic;
        }];
    }
    [self httpRequestGetMenuList];
}

#pragma mark - Search Event Object

- (void)createSearchView
{
    m_SearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-100, 29)];
    [m_SearchView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    
    UIView *backView = [[UIView alloc] initWithFrame:m_SearchView.frame];
    [backView setBackgroundColor:DIF_HEXCOLOR(@"f2f2f3")];
    [backView.layer setCornerRadius:5];
    [backView.layer setMasksToBounds:YES];
    [m_SearchView addSubview:backView];
    
    m_SearchTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, backView.width-24, backView.height)];
    [m_SearchTextField setFont:DIF_UIFONTOFSIZE(14)];
    [m_SearchTextField setDelegate:self];
    [m_SearchTextField setClearButtonMode:UITextFieldViewModeUnlessEditing|UITextFieldViewModeWhileEditing];
    [backView addSubview:m_SearchTextField];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"  输入关键字进行搜索"];
    [placeholder FontAttributeNameWithFont:DIF_UIFONTOFSIZE(14) Range:NSMakeRange(0, placeholder.length)];
    [placeholder ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"cccccc") Range:NSMakeRange(0, placeholder.length)];
    [placeholder attatchImage:[UIImage imageNamed:@"椭圆1"]
                   imageFrame:CGRectMake(0, -(m_SearchTextField.height-18)/2, 18, 18)
                        Range:NSMakeRange(0, 0)];
    [m_SearchTextField setAttributedPlaceholder:placeholder];
}

- (void)cleanSearchText
{
    [m_SearchTextField setText:nil];
}

- (void)rightBarButtonItemAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    [m_SearchTextField resignFirstResponder];
    if ([CommonVerify isContainsEmoji:m_SearchTextField.text])
    {
        [self.view makeToast:@"关键字不能包含表情"
                    duration:2 position:CSToastPositionCenter];
        return;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
    if (string && [other rangeOfString:string].location == NSNotFound && ([string isEqualToString:@" "] || [CommonVerify isContainsEmoji:string]))
    {
        return NO;
    }
    if (!string || string.isNull)
    {
        if (textField.text.length == 1)
        {
        }
        return YES;
    }
    if (textField.text.length + string.length > 18)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [m_SearchTextField resignFirstResponder];
    return YES;
}

#pragma mark - Http Request

- (void)httpRequestGetMenuList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestGetMenuListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            DIF_StrongSelf
            [CommonHUD hideHUD];
            [strongSelf->m_BaseView setChannelArray:responseModel[@"data"]];
            [strongSelf httpRequestGetTopicListByMenuId];
        }
        else
        {
            [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
        }
    } FailedBlcok:^(NSError *error) {
        [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
    }];
}

- (void)httpRequestGetTopicListByMenuId
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestGetTopicListByMenuIdWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
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
