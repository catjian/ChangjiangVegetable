//
//  SettingViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingViewController
{
    BaseTableView *m_BaseView;
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
    DIF_HideTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:NO];
    [self setLeftItemWithContentName:@"返回"];
    [self setNavTarBarTitle:@"设置"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!m_BaseView)
    {
        m_BaseView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [m_BaseView setBackgroundColor:DIF_HEXCOLOR(@"#F1F1F1")];
        [m_BaseView setDelegate:self];
        [m_BaseView setDataSource:self];
        [m_BaseView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:m_BaseView];
    }
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 4?55:49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingViewCell *cell = [SettingViewCell cellClassName:@"SettingViewCell" InTableView:tableView forContenteMode:nil];
    NSArray *arr = @[@"隐私政策", @"意见反馈", @"客服热线", @"内存清理", @"退出登录"];
    [cell.titleLab setText:arr[indexPath.row]];
    [cell.rightIcon setHidden:NO];
    [cell.titleLab setTextAlignment:NSTextAlignmentLeft];
    [cell.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
    [cell.titleLab setFont:DIF_DIFONTOFSIZE(14)];
    cell.cellHeight = 49;
    if (indexPath.row == 4){
        [cell.rightIcon setHidden:YES];
        [cell.titleLab setTextAlignment:NSTextAlignmentCenter];
        [cell.titleLab setTextColor:DIF_HEXCOLOR(@"#101010")];
        [cell.titleLab setFont:DIF_DIFONTOFSIZE(16)];
        cell.cellHeight = 55;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
