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
//        [playView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2502/25021573/raw_1536714038.png"]];
        [playView setImage:[UIImage imageNamed:@"播放"]];
        [self.imageView addSubview:playView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom+DIF_PX(3), self.imageView.width, DIF_PX(20))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.contentView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom+DIF_PX(4), 75-self.titleLab.left, 16)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"#999999")];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.contentView addSubview:self.detailLab];
        
        self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zanBtn setFrame:CGRectMake(self.detailLab.right+DIF_PX(5), self.detailLab.top, self.detailLab.width,16)];
        [self.zanBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [self.zanBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
        [self.zanBtn setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateSelected];
        [self.zanBtn setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateHighlighted];
        [self.zanBtn setTitle:@"888" forState:UIControlStateNormal];
        [self.zanBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
        [self.zanBtn.titleLabel setFont:DIF_UIFONTOFSIZE(12)];
        self.zanBtn.selected = NO;
        [self.zanBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:5];
        [self.zanBtn addTarget:self action:@selector(zanButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.zanBtn];
        
        UIButton *subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [subscribeBtn setTag:10001];
        [subscribeBtn setFrame:CGRectMake(self.imageView.right-DIF_PX(16), self.detailLab.top, 16,16)];
        [subscribeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [subscribeBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
        [subscribeBtn setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateSelected];
        [subscribeBtn addTarget:self action:@selector(subscribeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        subscribeBtn.selected = NO;
        [self.contentView addSubview:subscribeBtn];
    }
    return self;
}

- (void)zanButtonEvent:(UIButton *)btn
{
    btn.selected = YES;
}

- (void)subscribeButtonEvent:(UIButton *)btn
{
    btn.selected = YES;
}

- (void)setLikeFlag:(BOOL)likeFlag
{
    UIButton *subscribeBtn = [self.contentView viewWithTag:10001];
    subscribeBtn.selected = likeFlag;
}

@end
