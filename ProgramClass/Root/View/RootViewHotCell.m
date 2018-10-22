//
//  RootViewHotCell.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/17.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RootViewHotCell.h"

@implementation RootViewHotCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(88), DIF_PX(140))];
        [grayView setBackgroundColor:DIF_HEXCOLOR_ALPHA(@"#F9F9F9", 1)];
        [grayView setCenterX:DIF_SCREEN_WIDTH/4/2];
        [self.contentView addSubview:grayView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, DIF_PX(14), grayView.width, DIF_PX(27))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#FC7940")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        [grayView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom, self.titleLab.width, DIF_PX(20))];
        [self.detailLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.detailLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.detailLab setTextAlignment:NSTextAlignmentCenter];
        [grayView addSubview:self.detailLab];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.detailLab.bottom+DIF_PX(5), DIF_PX(74), DIF_PX(68))];
        [self.imageView setCenterX:grayView.width/2];
        [grayView addSubview:self.imageView];
    }
    return self;
}

@end
