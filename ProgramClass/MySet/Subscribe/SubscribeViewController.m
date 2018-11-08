
//
//  SubscribeViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeViewCell.h"

@interface SubscribeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *collectionList;

@end

@implementation SubscribeViewController
{
    BaseTableView *m_ContentView;
    NSArray *m_ChannelArray;
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
    [self setNavTarBarTitle:@"收藏"];
    UIButton *rightBtn = [self setRightItemWithContentName:@"删除"];
    [rightBtn setTitleColor:DIF_HEXCOLOR(@"333333") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:DIF_DIFONTOFSIZE(16)];
    m_ChannelArray = @[@{@"menuName":@"资讯"},@{@"menuName":@"视频"},@{@"menuName":@"店铺"},@{@"menuName":@"商品"},@{@"menuName":@"网展"},@{@"menuName":@"远程问诊"}];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createPageController];
    [self createCollectionView];
    switch (self.conType) {
        case SubscribeViewControllerType_Collection:
            [self httpRequestPostGetCollectionList];
            break;
        default:
            [self httpRequestPostGetHistoryList];
            break;
    }
}

- (void)createPageController
{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in m_ChannelArray)
    {
        [titles addObject:dic[@"menuName"]];
    }
    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(40))
                                                                            titles:titles];
    [self.view addSubview:pageView];
    DIF_WeakSelf(self)
    [pageView setSelectBlock:^(NSInteger page) {
        DIF_StrongSelf
    }];
}

- (void)createCollectionView
{
    m_ContentView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, DIF_PX(40), self.view.width, self.view.height-DIF_PX(40)) style:UITableViewStylePlain];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
    [self.view addSubview:m_ContentView];
}

#pragma mark - UITableView Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(90);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DIF_PX(2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeViewCell *cell = [SubscribeViewCell cellClassName:@"SubscribeViewCell"
                                                   InTableView:tableView
                                               forContenteMode:self.collectionList[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(2))];
    [view setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
    return view;
}

#pragma mark - Http Request

- (void)httpRequestPostGetCollectionList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGetCollectionListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        DIF_StrongSelf
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            [CommonHUD hideHUD];
            strongSelf.collectionList = responseModel[@"data"][@"list"];
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

- (void)httpRequestPostGetHistoryList
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGetHistoryListWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        DIF_StrongSelf
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            [CommonHUD hideHUD];
            strongSelf.collectionList = responseModel[@"data"][@"list"];
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
