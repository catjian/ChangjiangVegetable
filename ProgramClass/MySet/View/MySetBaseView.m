//
//  MySetBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/21.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MySetBaseView.h"

@implementation MySetBaseView
{
    NSArray *m_DataSource;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self)
    {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
        m_DataSource = @[@"消息通知",@"我的评论",@"我的收藏",@"历史记录",
                         @"收货地址",@"广告招商",@"关于我们",@"设置"];
    }
    return self;
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger) numberOfSections
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_DataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 270;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySetTableViewCell *cell = [MySetTableViewCell cellClassName:@"MySetTableViewCell" InTableView:tableView forContenteMode:@{@"title":m_DataSource[indexPath.row]}];
    return cell;
}

#pragma mark - TableView HeaderView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, 270)];
    
    UIView *userDetailView = [self createUserDetailViewWithContent:nil];
    [headerView addSubview:userDetailView];
    
    UIView *functionView = [self createFunctionViewWithFrame:CGRectMake(0, userDetailView.bottom+2, DIF_SCREEN_WIDTH, 250-150-4)];
    [headerView addSubview:functionView];
    
    return  headerView;
}

- (UIView *)createUserDetailViewWithContent:(NSDictionary *)content
{
    UIView *userDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, DIF_SCREEN_WIDTH, 150)];
    [userDetailView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    
    UIButton *camaraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [camaraBtn setFrame:CGRectMake(0, 8, 20, 20)];
    [camaraBtn setRight:DIF_SCREEN_WIDTH-6];
    [camaraBtn setBackgroundColor:DIF_HEXCOLOR(@"ffbb42")];
    [camaraBtn setTitle:@"相机" forState:UIControlStateNormal];
    [userDetailView addSubview:camaraBtn];
    
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 98, 98)];
    [userIcon.layer setCornerRadius:userIcon.width/2];
    [userIcon setBackgroundColor:DIF_HEXCOLOR(@"ffbb42")];
    [userIcon sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2506/25060666/raw_1536743782.jpeg"]];
    [userDetailView addSubview:userIcon];
    
    UILabel *pointsLab = [[UILabel alloc] initWithFrame:CGRectMake(userIcon.left, userIcon.bottom+1, userIcon.width, 22)];
    [pointsLab setFont:DIF_UIFONTOFSIZE(14)];
    [pointsLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [pointsLab setTextAlignment:NSTextAlignmentCenter];
    [pointsLab setText:[NSString stringWithFormat:@"积分: %@",@"888"]];
    [userDetailView addSubview:pointsLab];
    
    UILabel *vipLab = [[UILabel alloc] initWithFrame:CGRectMake(userIcon.right+10, 48, 22, 24)];
    [vipLab setText:@"VIP"];
    [vipLab setTextColor:DIF_HEXCOLOR(@"e51c23")];
    [vipLab setTextAlignment:NSTextAlignmentCenter];
    [vipLab setFont:DIF_UIFONTOFSIZE(14)];
    [userDetailView addSubview:vipLab];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(vipLab.right+2, vipLab.top, DIF_SCREEN_WIDTH-vipLab.right-4-36, vipLab.height)];
    [nameLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [nameLab setFont:DIF_UIFONTOFSIZE(16)];
    [nameLab setText:@"蘑菇小鬼头"];
    [userDetailView addSubview:nameLab];
    
    UILabel *levelLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.right+2, nameLab.top, 30, nameLab.height)];
    [levelLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [levelLab setFont:DIF_UIFONTOFSIZE(12)];
    [levelLab setText:@"70级"];
    [userDetailView addSubview:levelLab];
    
    UIProgressView * progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progress setFrame:CGRectMake(vipLab.left, vipLab.bottom+3, DIF_SCREEN_WIDTH-vipLab.left-6, 6)];
    [progress setProgress:0.5];
    [progress setProgressTintColor:DIF_HEXCOLOR(@"ffbb42")];
    [progress setTrackTintColor:DIF_HEXCOLOR(@"9d9d9d")];
    [userDetailView addSubview:progress];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signBtn setFrame:CGRectMake(0, pointsLab.top, 66, 26)];
    [signBtn setRight:DIF_SCREEN_WIDTH-6];
    [signBtn setBackgroundColor:DIF_HEXCOLOR(@"ffbb42")];
    [signBtn setTitle:@"签到 +10" forState:UIControlStateNormal];
    [signBtn setTitleColor:DIF_HEXCOLOR(@"ffffff") forState:UIControlStateNormal];
    [signBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
    [signBtn.layer setCornerRadius:13];
    [signBtn.layer setMasksToBounds:YES];
    [userDetailView addSubview:signBtn];
    
    return userDetailView;
}

- (UIView *)createFunctionViewWithFrame:(CGRect)frame
{
    UIView *functionView = [[UIView alloc] initWithFrame:frame];
    [functionView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    
    CGFloat offset_width = DIF_SCREEN_WIDTH/4;
    NSArray *titles = @[@"我要读刊",@"我要投稿",@"我要付款",@"我的订单"];
    for (NSInteger i = 0; i < titles.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*offset_width, 0, offset_width, frame.size.height)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:DIF_UIFONTOFSIZE(14)];
        [btn setTitleColor:DIF_HEXCOLOR(@"666666") forState:UIControlStateNormal];
        [functionView addSubview:btn];
    }
    return functionView;
}

@end
