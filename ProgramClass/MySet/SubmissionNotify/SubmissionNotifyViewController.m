//
//  SubmissionNotifyViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SubmissionNotifyViewController.h"

@interface SubmissionNotifyViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SubmissionNotifyViewController
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
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setBackgroundColor:DIF_HEXCOLOR(@"")];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, DIF_SCREEN_WIDTH, 39)];
        [bgView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [cell.contentView addSubview:bgView];
        
        UIView *redPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [redPoint setCenterY:bgView.height/2];
        [redPoint setRight:bgView.width-12];
        [redPoint setBackgroundColor:[UIColor redColor]];
        [redPoint.layer setCornerRadius:3];
        [bgView addSubview:redPoint];
    }
    [cell.textLabel setText:@"您的稿件进度有新的通知"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
