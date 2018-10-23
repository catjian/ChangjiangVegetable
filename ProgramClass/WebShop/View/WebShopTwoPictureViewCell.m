//
//  WebShopTwoPictureViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/23.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShopTwoPictureViewCell.h"

@implementation WebShopTwoPictureViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, DIF_SCREEN_WIDTH/2-2, DIF_PX(82))];
        [bgView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:bgView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(10), DIF_PX(4), DIF_PX(80), DIF_PX(70))];
        [bgView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.right+DIF_PX(4), self.imageView.top+DIF_PX(15), bgView.width-self.imageView.right-DIF_PX(8), DIF_PX(24))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        [bgView addSubview:self.titleLab];
        
        self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom, self.titleLab.width, self.titleLab.height)];
        [self.moneyLab setTextColor:DIF_HEXCOLOR(@"#FF5555")];
        [self.moneyLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.moneyLab setTextAlignment:NSTextAlignmentCenter];
        [bgView addSubview:self.moneyLab];
        
        self.imageViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.right+DIF_PX(4), self.imageView.top, DIF_PX(80), DIF_PX(70))];
        [bgView addSubview:self.imageViewRight];
    }
    return self;
}

- (void)setShowRightPicture:(BOOL)isShow
{
    [self.imageViewRight setHidden:!isShow];
    [self.titleLab setHidden:isShow];
    [self.moneyLab setHidden:isShow];
    if (isShow)
    {
        [self.imageView setWidth:(DIF_SCREEN_WIDTH/2-2-24)/2];
        [self.imageViewRight setWidth:(DIF_SCREEN_WIDTH/2-2-24)/2];
    }
    else
    {
        [self.imageView setWidth:DIF_PX(80)];
        [self.imageViewRight setWidth:DIF_PX(80)];
    }
    [self.imageViewRight setLeft:self.imageView.right+DIF_PX(4)];
}

@end
