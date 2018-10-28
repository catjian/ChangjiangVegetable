//
//  BookCoverCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BookCoverCell.h"

@implementation BookCoverCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, DIF_PX(96), DIF_PX(130))];
        [self.imageView setCenterX:self.width/2];
        [self.contentView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom, self.imageView.width, DIF_PX(20))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#999999")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

@end
