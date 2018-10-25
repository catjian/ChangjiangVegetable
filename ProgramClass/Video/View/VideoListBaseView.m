//
//  VideoListBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/20.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "VideoListBaseView.h"
#import "VideoListViewCell.h"

@interface VideoListBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation VideoListBaseView
{
    BaseCollectionView *m_ContentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createPageController];
    }
    return self;
}

- (void)createPageController
{
    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH-34, 40)
                                                                            titles:@[@"品种导航",@"庄稼医生",@"菜园机械",@"栽培技术"]
                                                                          oneWidth:(DIF_SCREEN_WIDTH-34)/4-12];
    [self addSubview:pageView];
    DIF_WeakSelf(self)
    [pageView setSelectBlock:^(NSInteger page) {
        DIF_StrongSelf
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(pageView.right+6, 0, 22, 40)];
    [btn setTitle:@"E" forState:UIControlStateNormal];
    [btn setTitleColor:DIF_HEXCOLOR(@"808080") forState:UIControlStateNormal];
    [self addSubview:btn];
    [self createCollectionView];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height)
                                              ScrollDirection:UICollectionViewScrollDirectionVertical
                                                CellClassName:@"RootViewCell"];
    [m_ContentView registerClass:[UICollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderView"];
    [self addSubview:m_ContentView];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 4;
        default:
            return 6;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"VideoListViewCell_CELLIDENTIFIER";
    [m_ContentView registerClass:[VideoListViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    VideoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2527/25278364/raw_1537249493.jpeg"]];
    [cell.titleLab setText:@"农民种植茶叶，这位农民..."];
    [cell.detailLab setText:@"⚯ 888  👍 888"];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        for (int i = 0; i < 6; i++)
        {
            if ([reusableview viewWithTag:1000+i] && i != indexPath.section)
            {
                [[reusableview viewWithTag:1000+i] removeFromSuperview];
            }
        }
        UIView *titleView = nil;
        if ([reusableview viewWithTag:1000+indexPath.section])
        {
            titleView = [reusableview viewWithTag:1000+indexPath.section];
        }
        switch (indexPath.section)
        {
            case 0:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(200))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(200))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [titleView addSubview:contentView];
                    
                    CommonADAutoView *adView = [[CommonADAutoView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
                    [adView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
                    [contentView addSubview:adView];
                    [adView setSelectBlock:^(NSInteger page) {
                    }];
                    NSMutableArray *picArr = [NSMutableArray array];
                    [picArr addObject:@"https://free.modao.cc/uploads3/images/2498/24986507/raw_1536656385.jpeg"];
                    adView.picArr = picArr;
                    
                    
                    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 24, 24)];
                    [titleImage sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2599/25992702/v2_pgf11t.png"]];
                    [contentView addSubview:titleImage];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.right+2, adView.bottom, contentView.width-38-12-40, DIF_PX(50))];
                    [title setText:@"热门推荐"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [contentView addSubview:title];
                    [titleImage setCenterY:title.centerY];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(0, title.top, 40, DIF_PX(60))];
                    [btn setRight:contentView.width-DIF_PX(12)];
                    [btn setTitle:@"更多" forState:UIControlStateNormal];
                    [btn setTitleColor:DIF_HEXCOLOR(@"333333") forState:UIControlStateNormal];
                    [btn.titleLabel setFont:DIF_UIFONTOFSIZE(15)];
                    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    [btn addTarget:self action:@selector(headerViewMoreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [contentView addSubview:btn];
                }
            }
                break;
            default:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(140))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [titleView addSubview:contentView];
                    
                    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(80))];
                    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2499/24991066/raw_1536658218.jpeg"]];
                    [contentView addSubview:headerImageView];
                    
                    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 24, 24)];
                    [titleImage sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2599/25992803/v2_pgf14l.png"]];
                    [contentView addSubview:titleImage];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.right+2, headerImageView.bottom, contentView.width-38-12-40, DIF_PX(60))];
                    [title setText:@"新品上新"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [contentView addSubview:title];
                    [titleImage setCenterY:title.centerY];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(0, title.top, 40, DIF_PX(60))];
                    [btn setRight:contentView.width-DIF_PX(12)];
                    [btn setTitle:@"更多" forState:UIControlStateNormal];
                    [btn setTitleColor:DIF_HEXCOLOR(@"333333") forState:UIControlStateNormal];
                    [btn.titleLabel setFont:DIF_UIFONTOFSIZE(15)];
                    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    [contentView addSubview:btn];
                }
            }
                break;
        }
    }
    return reusableview;
}

- (void)headerViewMoreButtonEvent:(UIButton *)btn
{
    UIView *titleView = btn.superview.superview;
    if (self.selectBlock)
    {
        self.selectBlock([NSIndexPath indexPathForRow:-1 inSection:titleView.tag-1000], nil);
    }
}

#pragma mark - UICollecrtionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat widht = (DIF_SCREEN_WIDTH)/2;
    return CGSizeMake(widht, DIF_PX(160));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(DIF_PX(0), DIF_PX(0), DIF_PX(0), DIF_PX(0));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return DIF_PX(0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return DIF_PX(0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(200));
        default:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(150));
    }
}

@end

