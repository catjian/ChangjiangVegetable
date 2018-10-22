//
//  RootViewLoanCell.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/8/29.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RootViewLoanCell.h"

@implementation RootViewLoanCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(174), DIF_PX(116))];
        [self.imageView setCenterX:DIF_SCREEN_WIDTH/2/2];
        [self.contentView addSubview:self.imageView];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom-DIF_PX(24), self.imageView.width, DIF_PX(24))];
        [grayView setBackgroundColor:DIF_HEXCOLOR_ALPHA(@"000000", .57)];
        [self.contentView addSubview:grayView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(20), 0, grayView.width-DIF_PX(20), DIF_PX(24))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#ffffff")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(13)];
        [grayView addSubview:self.titleLab];
    }
    return self;
}

@end
