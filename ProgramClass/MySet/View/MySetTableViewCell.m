//
//  MySetTableViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/22.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "MySetTableViewCell.h"

@implementation MySetTableViewCell
{
    UILabel *m_TitleLab;
    UIView *m_RedPoint;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        self.cellHeight = 50;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, self.cellHeight)];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:backView];
        m_TitleLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, DIF_SCREEN_WIDTH-12-30, self.cellHeight)];
        [m_TitleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [m_TitleLab setFont:DIF_UIFONTOFSIZE(14)];
        [self.contentView addSubview:m_TitleLab];
        
        m_RedPoint = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 10, 10)];
        [m_RedPoint setCenterY:self.cellHeight/2];
        [m_RedPoint setBackgroundColor:DIF_HEXCOLOR(@"e51c23")];
        [m_RedPoint.layer setCornerRadius:5];
        [m_RedPoint setHidden:YES];
        [self.contentView addSubview:m_RedPoint];
        
        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_SCREEN_WIDTH-13, 0, 7, 14)];
        [rightIcon setCenterY:self.cellHeight/2];
        [rightIcon setImage:[UIImage imageNamed:@"向右"]];
        [self.contentView addSubview:rightIcon];
    }
    return self;
}

- (void)loadData:(NSDictionary *)model
{
    [m_TitleLab setText:model[@"title"]];
}

@end
