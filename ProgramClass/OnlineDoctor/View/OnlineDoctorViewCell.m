//
//  OnlineDoctorViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "OnlineDoctorViewCell.h"

@implementation OnlineDoctorViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(184);
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(180))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(10), DIF_PX(8), DIF_PX(48), DIF_PX(48))];
        [self.iconView.layer setCornerRadius:DIF_PX(48/2)];
        [self.iconView.layer setMasksToBounds:YES];
        [self.iconView setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.iconView];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+DIF_PX(8), DIF_PX(12), DIF_SCREEN_WIDTH-self.iconView.right-DIF_PX(20), DIF_PX(17))];
        [self.nameLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.nameLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [backView addSubview:self.nameLab];
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.left, self.nameLab.bottom+DIF_PX(5), DIF_PX(120), DIF_PX(17))];
        [self.dateLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.dateLab setFont:DIF_UIFONTOFSIZE(12)];
        [backView addSubview:self.dateLab];
        
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",0]];
        [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                       imageFrame:CGRectMake(0, 0, 20, 11)
                            Range:NSMakeRange(0, 0)];
        self.readNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.dateLab.top, backView.width-self.dateLab.right-DIF_PX(12), self.dateLab.height)];
        [self.readNumLab setRight:backView.width-DIF_PX(12)];
        [self.readNumLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.readNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.readNumLab setTextAlignment:NSTextAlignmentRight];
        [self.readNumLab setAttributedText:placeholder];
        [backView addSubview:self.readNumLab];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.iconView.bottom+DIF_PX(6), DIF_SCREEN_WIDTH-DIF_PX(24), DIF_PX(20))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setFont:DIF_UIFONTOFSIZE(14)];
        [backView addSubview:self.titleLab];
        
        CGFloat screenWidth = (DIF_SCREEN_WIDTH-DIF_PX(12*2+8*2))/3;
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(12), self.titleLab.bottom, screenWidth, DIF_PX(82))];
        [backView addSubview:self.imageView1];
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView1.right+DIF_PX(8), self.imageView1.top, self.imageView1.width, self.imageView1.height)];
        [backView addSubview:self.imageView2];
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView2.right+DIF_PX(8),  self.imageView1.top, self.imageView1.width, self.imageView1.height)];
        [backView addSubview:self.imageView3];
    }
    return self;
}

@end
