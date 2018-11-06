//
//  MyCommentViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MyCommentViewCell.h"

@implementation MyCommentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(182);
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(180))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(12), DIF_PX(34), DIF_PX(34))];
        [self.iconView.layer setCornerRadius:DIF_PX(34/2)];
        [self.iconView.layer setMasksToBounds:YES];
        [self.iconView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.iconView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+DIF_PX(10), self.iconView.top, DIF_SCREEN_WIDTH-self.iconView.right-DIF_PX(22), self.iconView.height)];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setText:@"蘑菇小鬼头"];
        [backView addSubview:self.titleLab];
        
        self.subtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.left, self.iconView.bottom+DIF_PX(8), DIF_SCREEN_WIDTH-DIF_PX(22), DIF_PX(20))];
        [self.subtitleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.subtitleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.subtitleLab setText:@"一千万个赞，一千万个赞，一千万个赞！"];
        [backView addSubview:self.subtitleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.left, self.subtitleLab.bottom+DIF_PX(18), DIF_PX(221), DIF_PX(44))];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.detailLab setText:@"科研编织“致富梦”，品质打赢“市场牌”—长阳火烧坪高山蔬菜基地"];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.detailLab setNumberOfLines:2];
        [backView addSubview:self.detailLab];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.detailLab.right+DIF_PX(16), self.subtitleLab.bottom+DIF_PX(14),DIF_PX(114),DIF_PX(74))];
        [self.imgView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.imgView];
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.left, self.detailLab.bottom+DIF_PX(10), self.detailLab.width-DIF_PX(22), DIF_PX(16))];
        [self.dateLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.dateLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.dateLab setText:@"2018年8月10日"];
        [backView addSubview:self.dateLab];
        
        self.readNumLab = [[UILabel alloc] initWithFrame:self.dateLab.frame];
        [self.readNumLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.readNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.readNumLab setText:@"阅读量：8888"];
        [self.readNumLab setTextAlignment:NSTextAlignmentRight];
        [backView addSubview:self.readNumLab];
     
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(0, self.dateLab.top, DIF_PX(12), DIF_PX(12))];
        [closeBtn setRight:self.detailLab.right];
        [closeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [closeBtn setImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
        [backView addSubview:closeBtn];
    }
    return self;
}

@end
