//
//  HotInformationThreePictureCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "HotInformationThreePictureCell.h"

@implementation HotInformationThreePictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(6), DIF_SCREEN_WIDTH-DIF_PX(24), DIF_PX(50))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [self.titleLab setFont:DIF_UIFONTOFSIZE(14)];
        [self.titleLab setNumberOfLines:2];
        [self.titleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.titleLab];
        
        CGFloat screenWidth = (DIF_SCREEN_WIDTH-12*2-4*2)/3;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(12), self.titleLab.bottom, screenWidth, DIF_PX(74))];
        [self.contentView addSubview:self.imageView];
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.right+DIF_PX(4), self.imageView.top, self.imageView.width, self.imageView.height)];
        [self.contentView addSubview:self.imageView2];
        self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView2.right+DIF_PX(4),  self.imageView.top, self.imageView.width, self.imageView.height)];
        [self.contentView addSubview:self.imageView3];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(DIF_SCREEN_WIDTH-DIF_PX(12*3), self.imageView.bottom, DIF_PX(12*3), DIF_PX(32))];
        [closeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [closeBtn setImage:[UIImage imageNamed:@"叉叉"] forState:UIControlStateNormal];
        [closeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:closeBtn];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), closeBtn.top, closeBtn.left-DIF_PX(12), closeBtn.height)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [self.detailLab setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:self.detailLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(162), DIF_SCREEN_WIDTH, DIF_PX(2))];
        [line setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
        [self.contentView addSubview:line];
    }
    return self;
}

@end
