//
//  SettingViewCell.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell
{
    UIView *m_BackView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"")];
        m_BackView = [[UIView alloc] initWithFrame:CGRectMake(0, 11, DIF_SCREEN_WIDTH, 38)];
        [m_BackView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [self.contentView addSubview:m_BackView];
        
        self.rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_SCREEN_WIDTH-13, 0, 7, 14)];
        [self.rightIcon setImage:[UIImage imageNamed:@"向下"]];
        [self.rightIcon setCenterY:m_BackView.height/2];
        [m_BackView addSubview:self.rightIcon];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(0), DIF_SCREEN_WIDTH-DIF_PX(12+30), m_BackView.height)];
        [self.titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
        [self.titleLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_BackView addSubview:self.titleLab];
    }
    return self;
}

- (void)setCellHeight:(CGFloat)cellHeight
{
    [m_BackView setFrame:CGRectMake(0, 11, DIF_SCREEN_WIDTH, cellHeight-11)];
    [self.rightIcon setCenterY:m_BackView.height/2];
    [self.titleLab setFrame:CGRectMake(DIF_PX(12), DIF_PX(0), DIF_SCREEN_WIDTH-DIF_PX(12+30), m_BackView.height)];
}

@end
