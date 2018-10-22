//
//  RootOnlyPictureCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/22.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "RootOnlyPictureCell.h"

@implementation RootOnlyPictureCell
{
    UIImageView *m_PicView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_PicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(80))];
        [m_PicView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2499/24991066/raw_1536658218.jpeg"]];
        [self.contentView addSubview:m_PicView];
    }
    return self;
}

@end
