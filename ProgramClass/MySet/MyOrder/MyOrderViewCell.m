//
//  MyOrderViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MyOrderViewCell.h"

@implementation MyOrderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(173);
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(0), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(168))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        
        self.addressLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(5), DIF_PX(8), backView.width-DIF_PX(10), DIF_PX(23))];
        [self.addressLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.addressLab setTextColor:DIF_HEXCOLOR(@"8c8c8c")];
        [self.addressLab setText:@"长江蔬菜 武汉 >"];
        [self.addressLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [backView addSubview:self.addressLab];
        
        self.statusLab = [[UILabel alloc] initWithFrame:self.addressLab.frame];
        [self.statusLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.statusLab setTextColor:DIF_HEXCOLOR(@"fc6060")];
        [self.statusLab setText:@"交易完成"];
        [self.statusLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self.statusLab setTextAlignment:NSTextAlignmentRight];
        [backView addSubview:self.statusLab];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(6), self.addressLab.bottom+DIF_PX(4), DIF_PX(104), DIF_PX(98))];
        [self.imgView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.imgView];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right+DIF_PX(8), self.addressLab.bottom+DIF_PX(5), backView.width-self.imgView.right-DIF_PX(13), DIF_PX(45))];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.detailLab setText:@"包邮现摘山东特产烟台新鲜大樱桃红灯车厘子现发水果5斤空运"];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.detailLab setNumberOfLines:2];
        [backView addSubview:self.detailLab];
        
        self.singleMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(self.detailLab.left, self.detailLab.bottom+DIF_PX(32), self.detailLab.width, DIF_PX(23))];
        [self.singleMoneyLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.singleMoneyLab setTextColor:DIF_HEXCOLOR(@"fc6060")];
        [self.singleMoneyLab setText:@"￥888.99"];
        [backView addSubview:self.singleMoneyLab];
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"共2件商品  合计： 1777.89 元"];
        NSRange range = [attStr.string rangeOfString:@"合计："];
        [attStr ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"fc6060") Range:NSMakeRange(range.location+range.length, attStr.string.length - range.length-range.location-1)];
        self.allMoneyLab = [[UILabel alloc] initWithFrame:self.singleMoneyLab.frame];
        [self.allMoneyLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.allMoneyLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.allMoneyLab setAttributedText:attStr];
        [self.allMoneyLab setTextAlignment:NSTextAlignmentRight];
        [backView addSubview:self.allMoneyLab];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(DIF_PX(9), self.imgView.bottom+DIF_PX(9), DIF_PX(28), DIF_PX(20))];
        [deleteBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:DIF_HEXCOLOR(@"666666") forState:UIControlStateNormal];
        [deleteBtn.titleLabel setFont:DIF_DIFONTOFSIZE(12)];
        [backView addSubview:deleteBtn];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setFrame:CGRectMake(0, deleteBtn.top, DIF_PX(48), DIF_PX(20))];
        [commentBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [commentBtn setRight:backView.width-DIF_PX(6)];
        [commentBtn setTitle:@"评价" forState:UIControlStateNormal];
        [commentBtn setTitleColor:DIF_HEXCOLOR(@"fc6060") forState:UIControlStateNormal];
        [commentBtn.titleLabel setFont:DIF_DIFONTOFSIZE(12)];
        [commentBtn.layer setBorderColor:DIF_HEXCOLOR(@"fc6060").CGColor];
        [commentBtn.layer setBorderWidth:1];
        [commentBtn.layer setCornerRadius:DIF_PX(10)];
        [commentBtn.layer setMasksToBounds:YES];
        [backView addSubview:commentBtn];
        
        UIButton *checkRun = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkRun setFrame:CGRectMake(0, deleteBtn.top, DIF_PX(66), DIF_PX(20))];
        [checkRun setBackgroundColor:DIF_HEXCOLOR(@"")];
        [checkRun setRight:commentBtn.left-DIF_PX(10)];
        [checkRun setTitle:@"查看物流" forState:UIControlStateNormal];
        [checkRun setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [checkRun.titleLabel setFont:DIF_DIFONTOFSIZE(12)];
        [checkRun.layer setBorderColor:DIF_HEXCOLOR(@"999999").CGColor];
        [checkRun.layer setBorderWidth:1];
        [checkRun.layer setCornerRadius:DIF_PX(10)];
        [checkRun.layer setMasksToBounds:YES];
        [backView addSubview:checkRun];
        
    }
    return self;
}

- (void)loadData:(NSDictionary *)model
{
    [self.addressLab setText:model[@"shopName"]];
    [self.statusLab setText:model[@"orderStatusName"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model[@"goodsImgUrl"]]];
    [self.detailLab setText:model[@"goodsName"]];
    [self.singleMoneyLab setText:[NSString stringWithFormat:@"￥%@",[model[@"goodsPrice"] stringValue]]];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%d件商品  合计： %@ 元",
                                                                                           [model[@"goodsNum"] intValue],[model[@"orderTotalPrice"] stringValue]]];
    NSRange range = [attStr.string rangeOfString:@"合计："];
    [attStr ForegroundColorAttributeNamWithColor:DIF_HEXCOLOR(@"fc6060")
                                           Range:NSMakeRange(range.location+range.length, attStr.string.length - range.length-range.location-1)];
    [self.allMoneyLab setAttributedText:attStr];
}

@end
