//
//  MyOrderViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderViewCell.h"

@interface MyOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyOrderViewController
{
    BaseTableView *m_ContentView;
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
    [self setNavTarBarTitle:@"我的订单"];
    [self createPageController];
    [self createCollectionView];
}

- (void)createPageController
{
    NSArray *titleArr = @[@"全部",@"待收货",@"待评价",@"已完成"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(30))];
    [backView setBackgroundColor:DIF_HEXCOLOR(@"f6f6f6")];
    [self.view addSubview:backView];
    for (int i = 0; i < titleArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(DIF_SCREEN_WIDTH/4), 0, DIF_SCREEN_WIDTH/4, DIF_PX(30))];
        [btn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:DIF_HEXCOLOR(@"666666") forState:UIControlStateNormal];
        [btn setTitleColor:DIF_HEXCOLOR(@"fc6060") forState:UIControlStateHighlighted];
        [btn setTitleColor:DIF_HEXCOLOR(@"fc6060") forState:UIControlStateSelected];
        [btn.titleLabel setFont:DIF_DIFONTOFSIZE(16)];
        [backView addSubview:btn];
    }
}

- (void)createCollectionView
{
    m_ContentView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 30, self.view.width, self.view.height) style:UITableViewStylePlain];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
    [self.view addSubview:m_ContentView];
}

#pragma mark - UITableView Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(173);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderViewCell *cell = [MyOrderViewCell cellClassName:@"MyOrderViewCell" InTableView:tableView forContenteMode:nil];
    return cell;
}

@end
