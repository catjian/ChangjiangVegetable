//
//  WebShopLeftOnePictureViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/23.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShopLeftOnePictureViewCell.h"

@implementation WebShopLeftOnePictureViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, DIF_SCREEN_WIDTH/2-2, DIF_PX(80))];
        [bgView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:bgView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(8), DIF_PX(12), DIF_PX(72), DIF_PX(68))];
        [bgView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.right+DIF_PX(8), self.imageView.top, bgView.width-self.imageView.right-DIF_PX(10), DIF_PX(24))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(16)];
        [bgView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom, self.titleLab.width, self.imageView.height-self.titleLab.height)];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(10)];
        [self.detailLab setNumberOfLines:0];
        [self.detailLab setLineBreakMode:NSLineBreakByCharWrapping];
        [bgView addSubview:self.detailLab];
    }
    return self;
}

@end
