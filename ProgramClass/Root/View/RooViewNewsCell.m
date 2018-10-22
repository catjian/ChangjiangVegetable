//
//  RooViewNewsCell.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/17.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RooViewNewsCell.h"

@implementation RooViewNewsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(4),DIF_PX(112), DIF_PX(84))];
        [self.imageView setRight:DIF_SCREEN_WIDTH-DIF_PX(12)];
        [self.contentView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.imageView.top, self.imageView.left-DIF_PX(24), DIF_PX(60))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setFont:DIF_UIFONTOFSIZE(16)];
        [self.titleLab setNumberOfLines:0];
        [self.titleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.titleLab];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(self.imageView.left-DIF_PX(24), self.titleLab.bottom, DIF_PX(12), DIF_PX(15))];
        [closeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [closeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:closeBtn];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.titleLab.bottom, closeBtn.left-DIF_PX(24), DIF_PX(16))];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.detailLab setFont:DIF_UIFONTOFSIZE(12)];
        [self.detailLab setNumberOfLines:0];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.detailLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 93, DIF_SCREEN_WIDTH, 2)];
        [line setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
