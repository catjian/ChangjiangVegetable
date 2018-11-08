//
//  ShopInformationViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ShopInformationViewCell.h"

@implementation ShopInformationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(158);
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(DIF_PX(0), DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(150))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(8), DIF_PX(218), DIF_PX(44))];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setText:@"气球打农药，直接秒杀无人机！农民的智慧惊呆所有人！"];
        [self.titleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.titleLab setNumberOfLines:2];
        [backView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.titleLab.bottom+DIF_PX(2), DIF_PX(218), DIF_PX(48))];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.detailLab setText:@"气球打农药，直接秒杀无人机！农民的智慧惊呆所有人！气球打农药，直接秒杀无人机！农民的智慧惊呆所有人！气"];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.detailLab setNumberOfLines:3];
        [backView addSubview:self.detailLab];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.detailLab.right+DIF_PX(2), DIF_PX(7),DIF_PX(132),DIF_PX(96))];
        [self.imgView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.imgView];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(12), self.detailLab.bottom+DIF_PX(18), DIF_PX(24), DIF_PX(24))];
        [self.iconView.layer setCornerRadius:DIF_PX(24/2)];
        [self.iconView.layer setMasksToBounds:YES];
        [self.iconView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.iconView];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+DIF_PX(7), self.iconView.top, DIF_PX(100), self.iconView.height)];
        [self.nameLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.nameLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.nameLab setText:@"蘑菇小鬼头"];
        [backView addSubview:self.nameLab];
        
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",8888]];
        [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                       imageFrame:CGRectMake(0, 0, 20, 11)
                            Range:NSMakeRange(0, 0)];
        self.readNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.right+DIF_PX(10), self.iconView.top, DIF_PX(64), self.iconView.height)];
        [self.readNumLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.readNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.readNumLab setAttributedText:placeholder];
        [backView addSubview:self.readNumLab];
        
        placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",8888]];
        [placeholder attatchImage:[UIImage imageNamed:@"消息"]
                       imageFrame:CGRectMake(0, -(self.iconView.height-18)/2, 18, 18)
                            Range:NSMakeRange(0, 0)];
        self.commentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.readNumLab.right+DIF_PX(10), self.readNumLab.top, self.readNumLab.width, self.readNumLab.height)];
        [self.commentNumLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.commentNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.commentNumLab setAttributedText:placeholder];
        [backView addSubview:self.commentNumLab];
        
        placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",8888]];
        [placeholder attatchImage:[UIImage imageNamed:@"点赞3"]
                       imageFrame:CGRectMake(0, -2, 16, 16)
                            Range:NSMakeRange(0, 0)];
        self.zanNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.commentNumLab.right+DIF_PX(10), self.readNumLab.top, self.readNumLab.width, self.readNumLab.height)];
        [self.zanNumLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.zanNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.zanNumLab setAttributedText:placeholder];
        [backView addSubview:self.zanNumLab];
    }
    return self;
}

- (void)loadData:(NSDictionary *)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model[@"userPortraitUrl"]]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model[@"imgUrl"]]];
    [self.nameLab setText:model[@"userName"]];
    [self.titleLab setText:model[@"title"]];
    [self.detailLab setText:model[@"content"]];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[model[@"watchNum"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                   imageFrame:CGRectMake(0, 0, 20, 11)
                        Range:NSMakeRange(0, 0)];
    [self.readNumLab setAttributedText:placeholder];
    placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[model[@"feedbackNum"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"消息"]
                   imageFrame:CGRectMake(0, -(self.iconView.height-18)/2, 18, 18)
                        Range:NSMakeRange(0, 0)];
    [self.commentNumLab setAttributedText:placeholder];
    placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[model[@"likeNum"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"点赞3"]
                   imageFrame:CGRectMake(0, -2, 16, 16)
                        Range:NSMakeRange(0, 0)];
    [self.zanNumLab setAttributedText:placeholder];
}

@end
