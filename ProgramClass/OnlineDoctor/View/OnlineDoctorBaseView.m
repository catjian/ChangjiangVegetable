//
//  OnlineDoctorBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "OnlineDoctorBaseView.h"
#import "OnlineDoctorViewCell.h"

@implementation OnlineDoctorBaseView
{
    
    BaseTableView *m_ContentView;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (UIView *)createHeaderView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
    
    UILabel *warnLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(30))];
    [warnLab setBackgroundColor:DIF_HEXCOLOR(@"f2432a")];
    [warnLab setTextColor:DIF_HEXCOLOR(@"ffffff")];
    [warnLab setFont:DIF_DIFONTOFSIZE(14)];
    [warnLab setText:self.doctorDic[@"noticfaction"]];
    [warnLab setTextAlignment:NSTextAlignmentCenter];
    [backView addSubview:warnLab];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DIF_PX(30), DIF_SCREEN_WIDTH, DIF_PX(112))];
    [backView addSubview:scrollView];
    for (int i = 0; i < [self.doctorDic[@"doctorList"] count]; i++)
    {
        NSDictionary *dic = [self.doctorDic[@"doctorList"] objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(DIF_PX(12)+i*DIF_PX(58+12), 0, DIF_PX(58), scrollView.height)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(btn.left, DIF_PX(16), DIF_PX(58), DIF_PX(58))];
        [icon sd_setImageWithURL:[NSURL URLWithString:dic[@"doctorPortraitUrl"]]];
        [icon.layer setCornerRadius:DIF_PX(58/2)];
        [icon.layer setMasksToBounds:YES];
        [scrollView addSubview:icon];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(icon.left, icon.bottom+DIF_PX(9), icon.width, DIF_PX(20))];
        [name setTextColor:DIF_HEXCOLOR(@"101010")];
        [name setTextAlignment:NSTextAlignmentCenter];
        [name setFont:DIF_DIFONTOFSIZE(14)];
        [name setText:dic[@"doctorName"]];
        [btn setTag:9990+i];
        [scrollView addSubview:name];
        [scrollView addSubview:btn];
        [btn addTarget:self action:@selector(selectDoctorButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [scrollView setContentSize:CGSizeMake(DIF_PX(58+12)*[self.doctorDic[@"doctorList"] count], DIF_PX(112))];
    return backView;
}

- (void)selectDoctorButtonEvent:(UIButton *)btn
{
    if(self.selectDoctorBlock)
    {
        self.selectDoctorBlock(btn.tag-9990);
    }
}

- (void)createCollectionView
{
    m_ContentView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
//    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    [self addSubview:m_ContentView];
    [m_ContentView setRefreshBlock:self.refreshBlock];
    [m_ContentView setLoadMoreBlock:self.loadMoreBlock];
}

- (void)endRefresh
{
    [m_ContentView endRefresh];
    [m_ContentView setContentOffset:CGPointMake(0, 0)];
}

-(void)setArticleList:(NSArray *)articleList
{
    _articleList  = articleList;
    [m_ContentView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - UITableView Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(184);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DIF_PX(150);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnlineDoctorViewCell *cell = [OnlineDoctorViewCell cellClassName:@"OnlineDoctorViewCell" InTableView:tableView forContenteMode:nil];
    NSDictionary *dic = self.articleList[indexPath.row];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    [cell.nameLab setText:dic[@"createByName"]];
    [cell.dateLab setText:dic[@"createTime"]];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[dic[@"readNumber"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                   imageFrame:CGRectMake(0, 0, 20, 11)
                        Range:NSMakeRange(0, 0)];
    [cell.readNumLab setAttributedText:placeholder];
    [cell.titleLab setText:dic[@"title"]];
    if (dic[@"image"])
    {
        [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    }
    if (dic[@"image2"])
    {
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:dic[@"image2"]]];
    }
    if (dic[@"image3"])
    {
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:dic[@"image3"]]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock)
    {
        NSDictionary *dic = self.articleList[indexPath.row];
        self.selectBlock(indexPath, dic);
    }
}

@end
