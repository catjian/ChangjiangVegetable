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
    CommonPageControlView *m_PageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    }
    return self;
}

- (void)createPageController
{
    if(!m_PageView)
    {
        NSMutableArray *titles = [NSMutableArray array];
        for (NSDictionary *dic in self.channelArray)
        {
            [titles addObject:dic[@"menuName"]];
        }
    //    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH-DIF_PX(34), DIF_PX(40))
    //                                                                            titles:titles
    //                                                                          oneWidth:(DIF_SCREEN_WIDTH-34)/4-12];
        m_PageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(40))
                                                                                titles:titles
                                                                              oneWidth:(DIF_SCREEN_WIDTH)/4-12];
        [self addSubview:m_PageView];
        [m_PageView setSelectBlock:self.pageSelectBlock];
        
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [btn setFrame:CGRectMake(pageView.right+DIF_PX(6), 0, DIF_PX(22), DIF_PX(40))];
    //    [btn setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    ////    [btn setTitle:@"E" forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
    //    [btn setTitleColor:DIF_HEXCOLOR(@"808080") forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(pageControlSelectChannelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:btn];
        [self createCollectionView];
    }
}

- (void)pageControlSelectChannelButtonEvent:(UIButton *)btn
{
    if (self.selectChannelBlock)
    {
        self.selectChannelBlock();
    }
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, DIF_PX(40), self.width, self.height)
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

- (void)setAllDataDic:(NSDictionary *)allDataDic
{
    _allDataDic = allDataDic;
    [self createPageController];
    [m_ContentView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *list = self.allDataDic[@"list"];
    switch (section)
    {
        case 0:
            return list&&list[@"hotData"]?[list[@"hotData"] count]:0;
        default:
            return list&&list[@"newData"]?[list[@"newData"] count]:0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"VideoListViewCell_CELLIDENTIFIER";
    [m_ContentView registerClass:[VideoListViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    VideoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *list = self.allDataDic[@"list"];
    NSArray *videoList = list[indexPath.section == 0?@"hotData":@"newData"];
    NSDictionary *videoDic = videoList[indexPath.row];    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:videoDic[@"videoFirstFrameUrl"]]];
    [cell.titleLab setText:videoDic[@"title"]];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[videoDic[@"watchNum"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                   imageFrame:CGRectMake(0, 0, 20, 11)
                        Range:NSMakeRange(0, 0)];
    [cell.detailLab setAttributedText:placeholder];
    [cell.zanBtn setTitle:[NSString stringWithFormat:@"%d",[videoDic[@"likeNum"] intValue]]
                 forState:UIControlStateNormal];
    [cell setLikeFlag:NO];
    [cell setLikeFlag:[videoDic[@"likeFlag"] boolValue]];
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
                    [adView setTag:10001];
                    [adView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
                    [titleView addSubview:adView];
                    [adView setSelectBlock:^(NSInteger page) {
                    }];                    
                    
                    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 24, 24)];
                    [titleImage sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2599/25992702/v2_pgf11t.png"]
                                  placeholderImage:[UIImage imageNamed:@"火"]];
//                    [titleImage setImage:[UIImage imageNamed:@"火"]];
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
                    [btn setTag:888+indexPath.section];
                    [btn addTarget:self action:@selector(headerViewMoreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [contentView addSubview:btn];
                }
                CommonADAutoView *adView = [titleView viewWithTag:10001];
                NSMutableArray *picArr = [NSMutableArray array];
                [picArr addObject:@{@"image_url":@"https://free.modao.cc/uploads3/images/2504/25041835/raw_1536733080.jpeg"}];
                if (self.allDataDic[@"banner"] && [self.allDataDic[@"banner"] count] > 0)
                {
                    [picArr removeAllObjects];
                    for (int i = 0; i < [self.allDataDic[@"banner"] count]; i++)
                    {
                        NSArray *banner = [self.allDataDic[@"banner"] objectForKey:[NSString stringWithFormat:@"banner%d",i+1]];
                        for (NSString *bannerUrl in banner)
                        {
                            [picArr addObject:bannerUrl];
                        }
                    }
                }
                adView.picArr = picArr;
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
                    [titleImage sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2599/25992803/v2_pgf14l.png"]
                                  placeholderImage:[UIImage imageNamed:@"时钟"]];
//                    [titleImage setImage:[UIImage imageNamed:@"时钟"]];
                    [contentView addSubview:titleImage];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.right+2, headerImageView.bottom, contentView.width-38-12-40, DIF_PX(60))];
                    [title setText:@"最新视频"];
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
                    [btn setTag:888+indexPath.section];
                    [btn addTarget:self action:@selector(headerViewMoreButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    if (self.selectBlock)
    {
        self.selectBlock(indexPath, nil);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat widht = (m_ContentView.width)/2;
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

