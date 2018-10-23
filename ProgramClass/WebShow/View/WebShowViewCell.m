//
//  WebShowViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/24.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShowViewCell.h"

@implementation WebShowViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, DIF_SCREEN_WIDTH, DIF_PX(108+30))];
        [bgView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:bgView];
        
        self.imageViewRightT = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(15), DIF_PX(70), DIF_PX(50))];
        [self.imageViewRightT setRight:DIF_SCREEN_WIDTH-DIF_PX(12)];
        [self.contentView addSubview:self.imageViewRightT];
        
        self.imageViewRightB = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageViewRightT.left, self.imageViewRightT.bottom+DIF_PX(2), DIF_PX(70), DIF_PX(50))];
        [self.contentView addSubview:self.imageViewRightB];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.imageViewRightT.top, DIF_PX(108), DIF_PX(102))];
        [self.imageView setRight:self.imageViewRightT.left-DIF_PX(3)];
        [self.contentView addSubview:self.imageView];
        UIView *grayView = [[UIView alloc] initWithFrame:self.imageView.bounds];
        [grayView setBackgroundColor:DIF_HEXCOLOR_ALPHA(@"000000", .62)];
        [self.imageView addSubview:grayView];
        UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(36), DIF_PX(36))];
        [playView setCenterX:self.imageView.width/2];
        [playView setCenterY:self.imageView.height/2];
        [playView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2502/25021573/raw_1536714038.png"]];
        [self.imageView addSubview:playView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), self.imageView.top, self.imageView.left-DIF_PX(18), DIF_PX(64))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.titleLab setNumberOfLines:0];
        [self.titleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [self.contentView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.imageView.bottom-DIF_PX(18), self.titleLab.width, DIF_PX(17))];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"#999999")];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.contentView addSubview:self.detailLab];
        [self.titleLab setHeight:self.detailLab.top-self.imageView.top-DIF_PX(4)];
    }
    return self;
}

@end
