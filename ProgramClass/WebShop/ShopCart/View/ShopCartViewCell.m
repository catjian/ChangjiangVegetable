//
//  ShopCartViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/2.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopCartViewCell.h"

@implementation ShopCartViewCell
{
    UIImageView *m_ImageView;
    UILabel *m_TitleLab;
    UILabel *m_MoneyLab;
    UILabel *m_CountLab;
    NSDictionary *m_DetailDic;
    UIButton *m_SelectBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.height = DIF_PX(90);
        [self setBackgroundColor:DIF_HEXCOLOR(@"f5f5f5")];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(77))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        m_SelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_SelectBtn setFrame:CGRectMake(0, 0, DIF_PX(14+14+16), backView.height)];
        [m_SelectBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        [m_SelectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        [m_SelectBtn addTarget:self action:@selector(selectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [m_SelectBtn setSelected:NO];
        [backView addSubview:m_SelectBtn];
        
        m_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(m_SelectBtn.right, DIF_PX(8), DIF_PX(60), DIF_PX(60))];
        [backView addSubview:m_ImageView];
        
        m_TitleLab = [[UILabel alloc] initWithFrame:CGRectMake(m_ImageView.right+DIF_PX(12), m_ImageView.top, DIF_SCREEN_WIDTH-DIF_PX(130), DIF_PX(30))];
        [m_TitleLab setFont:DIF_DIFONTOFSIZE(16)];
        [m_TitleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [backView addSubview:m_TitleLab];
        
        m_MoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(m_TitleLab.left, 0, DIF_PX(120), DIF_PX(23))];
        [m_MoneyLab setBottom:m_ImageView.bottom];
        [m_MoneyLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_MoneyLab setTextColor:DIF_HEXCOLOR(@"ff5555")];
        [backView addSubview:m_MoneyLab];
        
        m_CountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, m_MoneyLab.top, DIF_PX(30), DIF_PX(23))];
        [m_CountLab setRight:backView.width-DIF_PX(22)];
        [m_CountLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_CountLab setTextColor:DIF_HEXCOLOR(@"101010")];
        [m_CountLab setTextAlignment:NSTextAlignmentCenter];
        [backView addSubview:m_CountLab];
        
        UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setFrame:CGRectMake(0, m_CountLab.top, 22, m_CountLab.height)];
        [minusBtn setRight:m_CountLab.left];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:DIF_HEXCOLOR(@"101010") forState:UIControlStateNormal];
        [minusBtn.titleLabel setFont:DIF_DIFONTOFSIZE(16)];
        [minusBtn addTarget:self action:@selector(minusButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:minusBtn];
        
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusBtn setFrame:CGRectMake(m_CountLab.right, m_CountLab.top, DIF_PX(22), m_CountLab.height)];
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleColor:DIF_HEXCOLOR(@"101010") forState:UIControlStateNormal];
        [plusBtn.titleLabel setFont:DIF_DIFONTOFSIZE(16)];
        [plusBtn addTarget:self action:@selector(plusButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:plusBtn];
    }
    return self;
}

- (void)selectButtonEvent:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(self.selectBlock)
    {
        self.selectBlock(btn.selected);
    }
}

- (void)minusButtonEvent:(UIButton *)btn
{
    NSInteger count = m_CountLab.text.integerValue;
    count = count-1<0?0:count-1;
    [m_CountLab setText:[@(count) stringValue]];
    [m_MoneyLab setText:[NSString stringWithFormat:@"￥%.2f", [m_DetailDic[@"Price"] floatValue]*count]];
    if(self.countBlock)
    {
        self.countBlock(count, [m_DetailDic[@"Price"] floatValue]*count);
    }
}

- (void)plusButtonEvent:(UIButton *)btn
{
    NSInteger count = m_CountLab.text.integerValue;
    count++;
    [m_CountLab setText:[@(count) stringValue]];
    [m_MoneyLab setText:[NSString stringWithFormat:@"￥%.2f", [m_DetailDic[@"Price"] floatValue]*count]];
    if(self.countBlock)
    {
        self.countBlock(count, [m_DetailDic[@"Price"] floatValue]*count);
    }
}

- (void)loadData:(id)model
{
    m_DetailDic = model;
    [m_SelectBtn setSelected:[m_DetailDic[@"selected"] boolValue]];
    [m_ImageView setImage:[UIImage imageNamed:m_DetailDic[@"imageName"]]];
    [m_TitleLab setText:m_DetailDic[@"name"]];
    [m_MoneyLab setText:[NSString stringWithFormat:@"￥%@", m_DetailDic[@"money"]]];
    [m_CountLab setText:m_DetailDic[@"count"]];
}

@end
