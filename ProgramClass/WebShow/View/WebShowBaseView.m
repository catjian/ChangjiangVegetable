//
//  WebShowBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/21.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShowBaseView.h"
#import "WebShowViewCell.h"

@interface WebShowBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation WebShowBaseView
{
    BaseCollectionView *m_ContentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCollectionView];
        [self setBackgroundColor:DIF_HEXCOLOR(@"f6f6f6")];
    }
    return self;
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)
                                              ScrollDirection:UICollectionViewScrollDirectionVertical
                                                CellClassName:@"RootViewCell"];
    [m_ContentView registerClass:[UICollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderView"];
    [self addSubview:m_ContentView];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"")];
}

- (void)setAllDataDic:(NSDictionary *)allDataDic
{
    _allDataDic = allDataDic;
    [m_ContentView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *list = self.allDataDic[@"list"];
    return list&&list[@"onlineList"]?[list[@"onlineList"] count]:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *list = self.allDataDic[@"list"];
    NSArray<NSDictionary *> *onlineList = list[@"onlineList"];
    static NSString *cellIdentifier = @"WebShowViewCell_CELLIDENTIFIER";
    [m_ContentView registerClass:[WebShowViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    WebShowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:onlineList[indexPath.row][@"videoFirstFrameUrl"]]];
    [cell.imageViewRightT sd_setImageWithURL:[NSURL URLWithString:onlineList[indexPath.row][@"imgUrl1"]]];
    [cell.imageViewRightB sd_setImageWithURL:[NSURL URLWithString:onlineList[indexPath.row][@"imgUrl2"]]];
    [cell.titleLab setText:onlineList[indexPath.row][@"title"]];
    NSString *date = [CommonDate dateToString:[NSDate dateWithTimeIntervalSince1970:[onlineList[indexPath.row][@"createDate"] integerValue]/1000]
                                      Formate:@"yyyy年MM月dd日"];
    [cell.detailLab setText:date];
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
        if (!titleView)
        {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
            [titleView setTag:1000+indexPath.section];
            [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
            [reusableview addSubview:titleView];
            
            CommonADAutoView *adView = [[CommonADAutoView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
            [adView setTag:10001];
            [adView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
            [titleView addSubview:adView];
            [adView setSelectBlock:^(NSInteger page) {
            }];
        }
        CommonADAutoView *adView = [titleView viewWithTag:10001];
        NSMutableArray *picArr = [NSMutableArray array];
        [picArr addObject:@"https://free.modao.cc/uploads3/images/2504/25041835/raw_1536733080.jpeg"];
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
    return reusableview;
}

- (void)headerViewMoreButtonEvent:(UIButton *)btn
{
}

#pragma mark - UICollecrtionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(145));
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
    return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(150));
}

@end



