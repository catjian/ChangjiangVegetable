//
//  OnlineDoctorViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "OnlineDoctorViewController.h"
#import "OnlineDoctorBaseView.h"

@interface OnlineDoctorViewController () <UITextFieldDelegate>

@end

@implementation OnlineDoctorViewController
{
    OnlineDoctorBaseView *m_BaseView;
    UIView *m_SearchView;
    UITextField *m_SearchTextField;
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
    [self setRightItemWithContentName:@"发布"];
    [self createSearchView];
    [self.navigationItem setTitleView:m_SearchView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[OnlineDoctorBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
    }
    [self httpRequestGetOnlineDoctorData];
}

- (void)rightBarButtonItemAction:(UIButton *)btn
{
    [self.view endEditing:YES];
}


#pragma mark - Search Event Object

- (void)createSearchView
{
    m_SearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-120, 29)];
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

- (void)httpRequestGetOnlineDoctorData
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestGetOnlineDoctorDataWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        DIF_StrongSelf
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            [CommonHUD hideHUD];
            [strongSelf->m_BaseView setDoctorDic:responseModel[@"data"]];
        }
        else
        {
            [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
        }
        [strongSelf httpRequestPostgGetOnlineDoctorArticleList];
    } FailedBlcok:^(NSError *error) {
        DIF_StrongSelf
        [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
        [strongSelf httpRequestPostgGetOnlineDoctorArticleList];
    }];
}

- (void)httpRequestPostgGetOnlineDoctorArticleList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGetOnlineDoctorArticleListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            DIF_StrongSelf
            [CommonHUD hideHUD];
            [strongSelf->m_BaseView setArticleList:responseModel[@"data"][@"list"]];
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
