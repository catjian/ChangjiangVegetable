//
//  WebShowRightTypeListView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/4.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShowRightTypeListView.h"

@implementation WebShowRightTypeListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self setDataSource:self];
        [self setDelegate:self];
        [self.layer setBorderColor:DIF_HEXCOLOR(@"bbbbbb").CGColor];
        [self.layer setBorderWidth:1];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(32);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DIF_PX(48);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(DIF_PX(14), 0, self.width-DIF_PX(14*2), DIF_PX(25))];
        [backView.layer setBorderWidth:1];
        [backView.layer setBorderColor:DIF_HEXCOLOR(@"ffba00").CGColor];
        [cell.contentView addSubview:backView];
        UILabel *lab = [[UILabel alloc] initWithFrame:backView.frame];
        [lab setTag:9901];
        [cell.contentView addSubview:lab];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [lab setFont:DIF_DIFONTOFSIZE(14)];
        [lab setTextColor:DIF_HEXCOLOR(@"3e3e3e")];
    }
    UILabel *contentLab = [cell.contentView viewWithTag:9901];
    [contentLab setText:@"小类"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, DIF_PX(48))];
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(25), DIF_PX(20), DIF_PX(10))];
    [rightIcon setRight:view.width-DIF_PX(14)];
    [rightIcon setImage:[UIImage imageNamed:@"向下"]];
    [view addSubview:rightIcon];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(14), DIF_PX(11), rightIcon.left-DIF_PX(14), DIF_PX(26))];
    [lab setTextColor:DIF_HEXCOLOR(@"101010")];
    [lab setFont:DIF_DIFONTOFSIZE(18)];
    [lab setText:@"大类"];

    [view addSubview:lab];
    
    return view;
}

@end
