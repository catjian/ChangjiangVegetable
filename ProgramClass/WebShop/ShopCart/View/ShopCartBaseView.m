//
//  ShopCartBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/2.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopCartBaseView.h"

@implementation ShopCartBaseView
{
    UIButton *m_SelectAllBtn;
    UILabel *m_AllMoney;
    UIButton *m_PayBtn;
    BaseTableView *m_TableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.dataArr = [NSMutableArray arrayWithArray:@[@{@"selected":@(NO),@"count":@"1",@"Price":@"50",
                                                          @"name":@"枝纯水果胡萝卜 袋装136g",
                                                          @"money":@"50.00", @"imageName":@"normalUserIcon"},
                                                        @{@"selected":@(NO),@"count":@"1",@"Price":@"100",
                                                          @"name":@"枝纯水果胡萝卜 袋装136g",
                                                          @"money":@"100.00", @"imageName":@"normalUserIcon"},
                                                        @{@"selected":@(NO),@"count":@"2",@"Price":@"20",
                                                          @"name":@"枝纯水果胡萝卜 袋装136g",
                                                          @"money":@"40.00", @"imageName":@"normalUserIcon"}]];
        
        
        m_TableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-DIF_PX(50)) style:UITableViewStylePlain];
        [m_TableView setDelegate:self];
        [m_TableView setDataSource:self];
        [m_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:m_TableView];
        [self createBottomView];
        [self addObserver:self forKeyPath:@"allMoneyNum" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)createBottomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-DIF_PX(50), DIF_SCREEN_WIDTH, DIF_PX(50))];
    [view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self addSubview:view];
    
    m_SelectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_SelectAllBtn setFrame:CGRectMake(0, 0, DIF_PX(88), DIF_PX(38))];
    [m_SelectAllBtn setCenterY:view.height/2];
    [m_SelectAllBtn setSelected:NO];
    [m_SelectAllBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [m_SelectAllBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [m_SelectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [m_SelectAllBtn setTitleColor:DIF_HEXCOLOR(@"101010") forState:UIControlStateNormal];
    [m_SelectAllBtn.titleLabel setFont:DIF_DIFONTOFSIZE(18)];
    [m_SelectAllBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:DIF_PX(8)];
    [m_SelectAllBtn addTarget:self action:@selector(selectAllButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:m_SelectAllBtn];
    
    m_PayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_PayBtn setFrame:CGRectMake(0, 0, DIF_PX(100), DIF_PX(38))];
    [m_PayBtn setCenterY:view.height/2];
    [m_PayBtn setRight:view.width-DIF_PX(12)];
    [m_PayBtn setBackgroundColor:DIF_HEXCOLOR(@"cd0505")];
    [m_PayBtn setTitle:@"结算 (0)" forState:UIControlStateNormal];
    [m_PayBtn setTitleColor:DIF_HEXCOLOR(@"ffffff") forState:UIControlStateNormal];
    [m_PayBtn.titleLabel setFont:DIF_DIFONTOFSIZE(18)];
    [m_PayBtn.layer setMasksToBounds:YES];
    [m_PayBtn.layer setCornerRadius:m_PayBtn.height/2];
    [view addSubview:m_PayBtn];
    
    m_AllMoney = [[UILabel alloc] initWithFrame:CGRectMake(m_SelectAllBtn.right, 0, m_PayBtn.left-m_SelectAllBtn.right, view.height)];
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:@"合计：0.00 元"];
    NSRange topRange = [moneyStr.string rangeOfString:@"合计："];
    [moneyStr ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"fc3c3c") Range:NSMakeRange(topRange.length, moneyStr.length-topRange.length-1)];
    [m_AllMoney setAttributedText:moneyStr];
    [m_AllMoney setFont:DIF_DIFONTOFSIZE(14)];
    [m_AllMoney setTextColor:DIF_HEXCOLOR(@"101010")];
    [view addSubview:m_AllMoney];
}

- (void)selectAllButtonEvent:(UIButton *)btn
{
    btn.selected = !btn.selected;
    for (NSInteger i = 0; i < self.dataArr.count; i++)
    {
        NSMutableDictionary *detailDic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[i]];
        [detailDic setObject:@(btn.selected) forKey:@"selected"];
        [self.dataArr replaceObjectAtIndex:i withObject:detailDic];
    }
    [m_PayBtn setTitle:[NSString stringWithFormat:@"结算 (%ld)",btn.selected?self.dataArr.count:0]
              forState:UIControlStateNormal];
    [m_TableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSMutableAttributedString *moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：%.2f 元",self.allMoneyNum]];
    NSRange topRange = [moneyStr.string rangeOfString:@"合计："];
    [moneyStr ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"fc3c3c") Range:NSMakeRange(topRange.length, moneyStr.length-topRange.length-1)];
    [m_AllMoney setAttributedText:moneyStr];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.allMoneyNum = 0;
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DIF_PX(90);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartViewCell *cell = [ShopCartViewCell cellClassName:@"ShopCartViewCell" InTableView:tableView forContenteMode:self.dataArr[indexPath.row]];
    if ([self.dataArr[indexPath.row][@"selected"] boolValue])
    {
        self.allMoneyNum += [self.dataArr[indexPath.row][@"money"] floatValue];
    }
    DIF_WeakSelf(self)
    [cell setSelectBlock:^(BOOL isSelected) {
        DIF_StrongSelf
        if (!isSelected)
        {
            strongSelf->m_SelectAllBtn.selected = NO;
            strongSelf.allMoneyNum -= [strongSelf.dataArr[indexPath.row][@"money"] floatValue];
        }
        else
        {
            strongSelf.allMoneyNum += [strongSelf.dataArr[indexPath.row][@"money"] floatValue];
        }
        
        NSMutableDictionary *detailDic = [NSMutableDictionary dictionaryWithDictionary:strongSelf.dataArr[indexPath.row]];
        [detailDic setObject:@(isSelected)  forKey:@"selected"];
        [strongSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:detailDic];
        NSInteger allNum = 0;
        for (NSInteger i = 0; i < strongSelf.dataArr.count; i++)
        {
            if ([strongSelf.dataArr[i][@"selected"] boolValue])
            {
                allNum++;
            }
        }
        [strongSelf->m_PayBtn setTitle:[NSString stringWithFormat:@"结算 (%ld)",allNum]
                              forState:UIControlStateNormal];
    }];
    [cell setCountBlock:^(NSInteger count, CGFloat money) {
        DIF_StrongSelf
        strongSelf.allMoneyNum -= [strongSelf.dataArr[indexPath.row][@"money"] floatValue];
        NSMutableDictionary *detailDic = [NSMutableDictionary dictionaryWithDictionary:strongSelf.dataArr[indexPath.row]];
        [detailDic setObject:[@(money) stringValue] forKey:@"money"];
        [strongSelf.dataArr replaceObjectAtIndex:indexPath.row withObject:detailDic];
        strongSelf.allMoneyNum += [strongSelf.dataArr[indexPath.row][@"money"] floatValue];
    }];
    return cell;
}

@end
