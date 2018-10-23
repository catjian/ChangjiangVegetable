//
//  VideoListViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/23.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "VideoListViewCell.h"

@implementation VideoListViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(170), DIF_PX(103))];
        [self.imageView setCenterX:DIF_SCREEN_WIDTH/2/2];
        [self.imageView.layer setCornerRadius:5];
        [self.imageView.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.imageView];
        
        UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(36), DIF_PX(36))];
        [playView setCenterX:self.imageView.width/2];
        [playView setCenterY:self.imageView.height/2];
        [playView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2502/25021573/raw_1536714038.png"]];
        [self.imageView addSubview:playView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom+DIF_PX(3), self.imageView.width, DIF_PX(20))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.contentView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom+DIF_PX(4), self.titleLab.width-DIF_PX(20), 16)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.contentView addSubview:self.detailLab];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setFrame:CGRectMake(self.imageView.right-DIF_PX(16), self.detailLab.top, 16,16)];
        [closeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [closeBtn setTitle:@"♡" forState:UIControlStateNormal];
        [closeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
        [self.contentView addSubview:closeBtn];
    }
    return self;
}

@end
