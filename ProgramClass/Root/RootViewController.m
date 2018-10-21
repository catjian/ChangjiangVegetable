//
//  RootViewController.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/10.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RootViewController.h"
#import "RootBaseView.h"
#import "InsuranceDetailViewController.h"
#import "SpecialNewsDetailViewController.h"
#import "MessageDetailViewController.h"
#import "LoanDetailViewController.h"
#import "LoanViewController.h"

@interface RootViewController () <UITextFieldDelegate>

@end

@implementation RootViewController
{
    UIView *m_SearchView;
    UITextField *m_SearchTextField;
    NSArray *m_Articleclassify;
    
    RootBaseView *m_BaseView;
    NSArray *m_MovePictures;
    NSArray *m_NoticeListArr;
    NSArray *m_ArticleListArr;
    NSArray *m_InsuranceListArr;
    NSArray *m_LoanListArr;
    NSArray *m_LoanSpeciesList;
    RootNoticeListModel *m_NoticeListModel;
    RootMovePictureModel *m_MovePictureModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_ShowTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    self.ShowBackButton = NO;
    [super viewDidLoad];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self createSearchView];
    [self.navigationItem setTitleView:m_SearchView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[RootBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setSelectBlock:^(NSIndexPath *indexPath, id model) {
            DIF_StrongSelf
            if (!indexPath)
            {
                return;
            }
            switch (indexPath.section)
            {
                case 0:
                {
                    switch (indexPath.row)
                    {
                        case 0:
                        {                            
                            [strongSelf loadViewController:@"LoanViewController" hidesBottomBarWhenPushed:NO];
                        }
                            break;
                        case 1:
                        {
                            [strongSelf loadViewController:@"InsuranceViewController" hidesBottomBarWhenPushed:NO];
                        }
                            break;
                        case 2:
                        {
                            [strongSelf loadViewController:@"CarInsuranceViewController" hidesBottomBarWhenPushed:NO];
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1:
                {
                    LoanViewController *vc = [strongSelf loadViewController:@"LoanViewController" hidesBottomBarWhenPushed:NO];
                    vc.speciesId = [strongSelf->m_LoanSpeciesList[indexPath.row] objectForKey:@"speciesId"];
                }
                    break;
                case 2:
                {
                }
                    break;
                case 3:
                {
                }
                    break;
                case 4:
                {
                }
                    break;
                case 9:
                {
                }
                default:
                    break;
            }
        }];
    }
}

#pragma mark - Search Event Object

- (void)createSearchView
{
    m_SearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 29)];
    [m_SearchView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 90, 29)];
    [titleLab setBackgroundColor:DIF_HEXCOLOR(@"")];
    [titleLab setTextColor:DIF_HEXCOLOR(@"101010")];
    [titleLab setFont:DIF_UIFONTOFSIZE(20)];
    [titleLab setText:@"长江蔬菜"];
    [m_SearchView addSubview:titleLab];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(titleLab.right+16, 0, self.view.width-titleLab.right-30, 29)];
    [backView setBackgroundColor:DIF_HEXCOLOR(@"f2f2f3")];
    [backView.layer setCornerRadius:5];
    [backView.layer setMasksToBounds:YES];
    [m_SearchView addSubview:backView];
    
    m_SearchTextField = [[UITextField alloc] initWithFrame:CGRectMake(7, 0, backView.width-14, backView.height)];
    [m_SearchTextField setFont:DIF_UIFONTOFSIZE(14)];
    [m_SearchTextField setDelegate:self];
    [m_SearchTextField setClearButtonMode:UITextFieldViewModeUnlessEditing|UITextFieldViewModeWhileEditing];
    [backView addSubview:m_SearchTextField];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"  请输入文字关键字"];
    [placeholder FontAttributeNameWithFont:DIF_UIFONTOFSIZE(14) Range:NSMakeRange(0, placeholder.length)];
    [placeholder ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"cccccc") Range:NSMakeRange(0, placeholder.length)];
    [placeholder attatchImage:[UIImage imageNamed:@"搜索"]
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
@end
