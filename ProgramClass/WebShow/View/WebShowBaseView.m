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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WebShowViewCell_CELLIDENTIFIER";
    [m_ContentView registerClass:[WebShowViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    WebShowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *imageArr = @[@"https://free.modao.cc/uploads3/images/2506/25060719/raw_1536743823.jpeg",
                          @"https://free.modao.cc/uploads3/images/2506/25063607/raw_1536745900.jpeg",
                          @"https://free.modao.cc/uploads3/images/2506/25063635/raw_1536745924.jpeg",
                          @"https://free.modao.cc/uploads3/images/2506/25063635/raw_1536745924.jpeg"];
    NSArray *imageRightArr = @[@[@"https://free.modao.cc/uploads3/images/2506/25063890/raw_1536746128.jpeg",
                                 @"https://free.modao.cc/uploads3/images/2506/25063881/raw_1536746118.jpeg"],
                               @[@"https://free.modao.cc/uploads3/images/2506/25063866/raw_1536746106.jpeg",
                                 @"https://free.modao.cc/uploads3/images/2506/25063382/raw_1536745768.jpeg"],
                               @[@"https://free.modao.cc/uploads3/images/2506/25060690/raw_1536743799.jpeg",
                                 @"https://free.modao.cc/uploads3/images/2506/25060666/raw_1536743782.jpeg"],
                               @[@"https://free.modao.cc/uploads3/images/2506/25060690/raw_1536743799.jpeg",
                                 @"https://free.modao.cc/uploads3/images/2506/25060666/raw_1536743782.jpeg"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[indexPath.row]]];
    [cell.imageViewRightT sd_setImageWithURL:[NSURL URLWithString:imageRightArr[indexPath.row][0]]];
    [cell.imageViewRightB sd_setImageWithURL:[NSURL URLWithString:imageRightArr[indexPath.row][0]]];
    NSArray *titleArr = @[@"现代化无土栽培技术，让蔬菜远离农药及重金属污染",
                          @"中国第二大蔬菜？规模2000万亩，它的信息全在这里了！",
                          @"胡春华:全面清理整治“大棚房” 遏制农地非农化",
                          @"胡春华:全面清理整治“大棚房” 遏制农地非农化"];
    [cell.titleLab setText:titleArr[indexPath.row]];
    [cell.detailLab setText:@"2018年9月12日"];
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
            
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(150))];
            [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
            [titleView addSubview:contentView];
            
            CommonADAutoView *adView = [[CommonADAutoView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
            [adView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
            [contentView addSubview:adView];
            [adView setSelectBlock:^(NSInteger page) {
            }];
            NSMutableArray *picArr = [NSMutableArray array];
            [picArr addObject:@"https://free.modao.cc/uploads3/images/2504/25041835/raw_1536733080.jpeg"];
            adView.picArr = picArr;
        }
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



