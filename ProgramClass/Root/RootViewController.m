//
//  RootViewController.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/10.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RootViewController.h"
#import "RootBaseView.h"
#import "SpecialNewsDetailViewController.h"
#import "WebShopDetailXIBViewController.h"
#import "VideoPlayerViewController.h"

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
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (userAgent) {
        
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                
                userAgent = mutableUserAgent;
                
            }
            
        }
        
        [[SDWebImageDownloader sharedDownloader] setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
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
                            [strongSelf loadViewController:@"HotInformationViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 1:
                            [strongSelf loadViewController:@"BookStoreViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 2:
                            [strongSelf loadViewController:@"OnlineDoctorViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        case 3:
                            [strongSelf loadViewController:@"ShopInformationViewController" hidesBottomBarWhenPushed:NO];
                            break;
                        default:
                            [strongSelf loadViewController:@"SubmissionNotifyViewController" hidesBottomBarWhenPushed:NO];
                            break;
                    }
                }
                    break;
                case 1:
                {
                }
                    break;
                case 2:
                {
                    NSArray<NSDictionary *> *recommendGoodsList = strongSelf->m_BaseView.allDataDic[@"list"][@"newGoodsList"];
                    WebShopDetailXIBViewController *vc = [strongSelf loadViewController:@"WebShopDetailXIBViewController" hidesBottomBarWhenPushed:NO];
                    vc.shopDetailDic = recommendGoodsList[indexPath.row];
                }
                    break;
                case 3:
                {
                    NSArray<NSDictionary *> *recommendGoodsList = strongSelf->m_BaseView.allDataDic[@"list"][@"discountGoodsList"];
                    WebShopDetailXIBViewController *vc = [strongSelf loadViewController:@"WebShopDetailXIBViewController" hidesBottomBarWhenPushed:NO];
                    vc.shopDetailDic = recommendGoodsList[indexPath.row];
                }
                    break;
                case 4:
                {
                    HtmlContentViewController *vc = [strongSelf loadViewController:@"HtmlContentViewController"];
                    NSArray<NSDictionary *> *hotTopicsList = strongSelf->m_BaseView.allDataDic[@"list"][@"hotTopicsList"];
                    vc.tradeId = [NSString stringWithFormat:@"%@", hotTopicsList[indexPath.row][@"id"]];
                    vc.tradeInfo = hotTopicsList[indexPath.row];
                }
                    break;
                case 5:
                {
                    VideoPlayerViewController *vc = [strongSelf loadViewController:@"VideoPlayerViewController" hidesBottomBarWhenPushed:NO];
                    NSArray<NSDictionary *> *newVideoList = strongSelf->m_BaseView.allDataDic[@"list"][@"newVideoList"];
                    vc.videoDic = newVideoList[indexPath.row];
                    vc.videoList = newVideoList;
                }
                default:
                    break;
            }
        }];
        [m_BaseView setHeaderBlock:^(NSInteger index) {
            DIF_StrongSelf
            if(index == 4)
            {
                [strongSelf loadViewController:@"HotInformationViewController" hidesBottomBarWhenPushed:NO];
            }
            else
            {
                [DIF_TabBar setSelectedIndex:1];
            }
        }];
    }
    if(DIF_CommonHttpAdapter.access_token)
    {
        if (m_BaseView.allDataDic.count <= 0)
            [self httpRequestGetMainData];
    }
    else
    {
        [self loadViewController:@"LoginViewController" hidesBottomBarWhenPushed:NO];
    }
}

#pragma mark - Search Event Object

- (void)createSearchView
{
    m_SearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-10, 29)];
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
    [m_SearchTextField setReturnKeyType:UIReturnKeySearch];
    [backView addSubview:m_SearchTextField];
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"  输入关键字进行搜索"];
    [placeholder FontAttributeNameWithFont:DIF_UIFONTOFSIZE(14) Range:NSMakeRange(0, placeholder.length)];
    [placeholder ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"cccccc") Range:NSMakeRange(0, placeholder.length)];
    [placeholder attatchImage:[UIImage imageNamed:@"椭圆1"]
                   imageFrame:CGRectMake(0, -4, 18, 18)
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{    
    [m_SearchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_SearchTextField resignFirstResponder];
    return YES;
}

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

- (void)httpRequestGetMainData
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestGetMainDataWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
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
