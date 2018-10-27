//
//  SelectChannelViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/27.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SelectChannelViewCell.h"

@implementation SelectChannelViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(6), DIF_SCREEN_WIDTH/4-12, DIF_PX(25))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#ffffff")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        [self.titleLab.layer setCornerRadius:5];
        [self.titleLab setBackgroundColor:DIF_HEXCOLOR(@"FF9E00")];
        [self.titleLab.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

@end
