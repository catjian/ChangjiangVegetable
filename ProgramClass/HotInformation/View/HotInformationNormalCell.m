//
//  HotInformationNormalCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "HotInformationNormalCell.h"

@implementation HotInformationNormalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(6),DIF_PX(114), DIF_PX(74))];
        [self.imageView setRight:DIF_SCREEN_WIDTH-DIF_PX(12)];
        [self.contentView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.imageView.top, self.imageView.left-DIF_PX(24), DIF_PX(44))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setFont:DIF_UIFONTOFSIZE(14)];
        [self.titleLab setNumberOfLines:2];
        [self.titleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.titleLab];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(self.imageView.left-DIF_PX(12*3), self.titleLab.bottom, DIF_PX(12*3), DIF_PX(32))];
        [closeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [closeBtn setImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
        [closeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:closeBtn];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.titleLab.bottom+DIF_PX(12), closeBtn.left-DIF_PX(12), DIF_PX(16))];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.detailLab setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:self.detailLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(90), DIF_SCREEN_WIDTH, DIF_PX(2))];
        [line setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
