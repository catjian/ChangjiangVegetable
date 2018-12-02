//
//  ShopInformationViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopInformationViewController.h"
#import "ShopInformationViewCell.h"

@interface ShopInformationViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *supportInfoList;

@end

@implementation ShopInformationViewController
{
    BaseTableView *m_ContentView;
    UIView *m_SearchView;
    UITextField *m_SearchTextField;
    NSArray *m_MenuList;
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
    [self httpRequestTradeInfoGetMenuList];
    [self createCollectionView];
}

- (void)rightBarButtonItemAction:(UIButton *)btn
{
    [self.view endEditing:YES];
//    [self loadViewController:@"ShopCartViewController" hidesBottomBarWhenPushed:YES isNowPush:YES];
}

- (void)createPageController:(NSArray *)titleArr
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(32))];
    [backView setTag:887];
    [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self.view addSubview:backView];
    for (int i = 0; i < titleArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(DIF_SCREEN_WIDTH/2), 0, DIF_SCREEN_WIDTH/2, DIF_PX(32))];
        [btn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [btn setTitle:titleArr[i][@"menuName"] forState:UIControlStateNormal];
        [btn setTitleColor:DIF_HEXCOLOR(@"101010") forState:UIControlStateNormal];
        [btn setTitleColor:DIF_HEXCOLOR(@"ffae1c") forState:UIControlStateHighlighted];
        [btn setTitleColor:DIF_HEXCOLOR(@"ffae1c") forState:UIControlStateSelected];
        [btn.titleLabel setFont:DIF_DIFONTOFSIZE(16)];
        if (i == 0) btn.selected = YES;
        [btn setTag:888+i];
        [btn addTarget:self action:@selector(buyOrShopButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
    }
}

- (void)buyOrShopButtonEvent:(UIButton *)btn
{
    UIView *backView = [self.view viewWithTag:887];
    for (int i =0; i < m_MenuList.count; i++)
    {
        UIButton *subBtn = [backView viewWithTag:888+i];
        [subBtn setSelected:NO];
    }
    [btn setSelected:YES];
    [self httpRequestTradeInfoGetListWithMenuId:[NSString stringWithFormat:@"%@",m_MenuList[btn.tag-888][@"menuId"]]];
}

- (void)createCollectionView
{
    m_ContentView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, DIF_PX(32), self.view.width, self.view.height-DIF_PX(32)) style:UITableViewStylePlain];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
//    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    [self.view addSubview:m_ContentView];
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

#pragma mark - UITableView Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.supportInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(158);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DIF_PX(8);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopInformationViewCell *cell = [ShopInformationViewCell cellClassName:@"ShopInformationViewCell"
                                                               InTableView:tableView
                                                           forContenteMode:self.supportInfoList[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(8))];
    [view setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
    return view;
}

#pragma mark - Http Request

- (void)httpRequestTradeInfoGetMenuList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestTradeInfoGetMenuListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         DIF_StrongSelf
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD hideHUD];
             strongSelf->m_MenuList = responseModel[@"data"];
             [strongSelf createPageController:strongSelf->m_MenuList];
             [strongSelf->m_ContentView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
             [strongSelf httpRequestTradeInfoGetListWithMenuId:[NSString stringWithFormat:@"%@",responseModel[@"data"][0][@"menuId"]]];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     } FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

- (void)httpRequestTradeInfoGetListWithMenuId:(NSString *)menuId
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestTradeInfoGetListWithMenuId:menuId
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         DIF_StrongSelf
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD hideHUD];
             strongSelf.supportInfoList = responseModel[@"data"][@"list"];
             [strongSelf->m_ContentView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
