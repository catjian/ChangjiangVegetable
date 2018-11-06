//
//  ShopTypeListViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopTypeListViewCell.h"

@implementation ShopTypeListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(110);
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(DIF_PX(0), DIF_PX(2), DIF_SCREEN_WIDTH, DIF_PX(108))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];        
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(12), DIF_PX(98), DIF_PX(86))];
        [self.imgView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.imgView];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imgView.right+DIF_PX(10), self.imgView.top, backView.width-self.imgView.right-DIF_PX(15), DIF_PX(45))];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"101010")];
        [self.detailLab setText:@"包邮现摘山东特产烟台新鲜大樱桃红灯车厘子现发水果5斤空运"];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.detailLab setNumberOfLines:2];
        [backView addSubview:self.detailLab];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentBtn setFrame:CGRectMake(self.detailLab.left, self.detailLab.bottom+DIF_PX(4), DIF_PX(31), DIF_PX(14))];
        [commentBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [commentBtn setTitle:@"自营" forState:UIControlStateNormal];
        [commentBtn setTitleColor:DIF_HEXCOLOR(@"ff3737") forState:UIControlStateNormal];
        [commentBtn.titleLabel setFont:DIF_DIFONTOFSIZE(10)];
        [commentBtn.layer setBorderColor:DIF_HEXCOLOR(@"ff3737").CGColor];
        [commentBtn.layer setBorderWidth:1];
        [commentBtn.layer setCornerRadius:DIF_PX(1)];
        [commentBtn.layer setMasksToBounds:YES];
        [backView addSubview:commentBtn];
        
        UIButton *checkRun = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkRun setFrame:CGRectMake(commentBtn.right+DIF_PX(12), commentBtn.top, DIF_PX(31), DIF_PX(14))];
        [checkRun setBackgroundColor:DIF_HEXCOLOR(@"")];
        [checkRun setTitle:@"包邮" forState:UIControlStateNormal];
        [checkRun setTitleColor:DIF_HEXCOLOR(@"ffae1c") forState:UIControlStateNormal];
        [checkRun.titleLabel setFont:DIF_DIFONTOFSIZE(10)];
        [checkRun.layer setBorderColor:DIF_HEXCOLOR(@"ffae1c").CGColor];
        [checkRun.layer setBorderWidth:1];
        [checkRun.layer setCornerRadius:DIF_PX(1)];
        [checkRun.layer setMasksToBounds:YES];
        [backView addSubview:checkRun];
        
        self.singleMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(self.detailLab.left, commentBtn.bottom+DIF_PX(3), self.detailLab.width, DIF_PX(23))];
        [self.singleMoneyLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self.singleMoneyLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.singleMoneyLab setTextColor:DIF_HEXCOLOR(@"ff5555")];
        [self.singleMoneyLab setText:@"￥888.99"];
        [backView addSubview:self.singleMoneyLab];
        
        self.addressLab = [[UILabel alloc] initWithFrame:self.singleMoneyLab.frame];
        [self.addressLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.addressLab setTextColor:DIF_HEXCOLOR(@"8c8c8c")];
        [self.addressLab setText:@"长江蔬菜 武汉 >"];
        [self.addressLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self.addressLab setTextAlignment:NSTextAlignmentRight];
        [backView addSubview:self.addressLab];        
    }
    return self;
}

@end
