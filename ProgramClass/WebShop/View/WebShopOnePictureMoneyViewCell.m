//
//  WebShopOnePictureMoneyViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/23.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShopOnePictureMoneyViewCell.h"

@implementation WebShopOnePictureMoneyViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1, 0, DIF_SCREEN_WIDTH/2-2, DIF_PX(260))];
        [bgView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:bgView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_PX(162), DIF_PX(162))];
        [self.imageView setCenterX:bgView.width/2];
        [bgView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.left, self.imageView.bottom+DIF_PX(8), self.imageView.width, DIF_PX(20))];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        [bgView addSubview:self.titleLab];
        
        UILabel *selfLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, self.titleLab.bottom+DIF_PX(16), 31, 14)];
        [selfLab setText:@"自营"];
        [selfLab setFont:DIF_DIFONTOFSIZE(10)];
        [selfLab setTextColor:DIF_HEXCOLOR(@"#FD6A6A")];
        [selfLab setTextAlignment:NSTextAlignmentCenter];
        [selfLab.layer setBorderWidth:1];
        [selfLab.layer setBorderColor:DIF_HEXCOLOR(@"FD6A6A").CGColor];
        [selfLab.layer setCornerRadius:2];
        [bgView addSubview:selfLab];
        
        UILabel *sendLab = [[UILabel alloc] initWithFrame:CGRectMake(selfLab.right+DIF_PX(12), selfLab.top, 31, 14)];
        [sendLab setText:@"包邮"];
        [sendLab setFont:DIF_DIFONTOFSIZE(10)];
        [sendLab setTextColor:DIF_HEXCOLOR(@"#FFAE1C")];
        [sendLab setTextAlignment:NSTextAlignmentCenter];
        [sendLab.layer setBorderWidth:1];
        [sendLab.layer setBorderColor:DIF_HEXCOLOR(@"FFAE1C").CGColor];
        [sendLab.layer setCornerRadius:2];
        [bgView addSubview:sendLab];
        
//        UILabel *moreLab = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.right-38, 0, 38, self.titleLab.height)];
//        [moreLab setText:@"∙ ∙ ∙"];
//        [moreLab setTextColor:DIF_HEXCOLOR(@"#838383")];
//        [moreLab setTextAlignment:NSTextAlignmentRight];
//        [bgView addSubview:moreLab];
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.right-26, 0, 26, 6)];
        [moreImage setImage:[UIImage imageNamed:@"更多2"]];
        [bgView addSubview:moreImage];
        
        self.moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.left, selfLab.bottom+DIF_PX(3), moreImage.left-DIF_PX(4)-self.titleLab.left, self.titleLab.height)];
        [self.moneyLab setTextColor:DIF_HEXCOLOR(@"#FF5555")];
        [self.moneyLab setFont:DIF_DIFONTOFSIZE(14)];
        [bgView addSubview:self.moneyLab];
        [moreImage setCenterY:self.moneyLab.centerY];
    }
    return self;
}

@end
