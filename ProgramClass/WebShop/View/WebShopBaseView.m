//
//  WebShopBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/21.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "WebShopBaseView.h"
#import "RootViewCell.h"
#import "WebShopLeftOnePictureViewCell.h"
#import "WebShopTwoPictureViewCell.h"
#import "WebShopOnePictureMoneyViewCell.h"

@interface WebShopBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation WebShopBaseView
{
    BaseCollectionView *m_ContentView;
    NSArray *m_ContentArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCollectionView];
        [self setBackgroundColor:DIF_HEXCOLOR(@"f6f6f6")];
        m_ContentArr = @[@"爆款",@"店铺",@"种子",@"农资",@"杂志",@"书籍",@"课程",@"我的订单"];
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
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *list = self.allDataDic[@"list"];
    switch (section)
    {
        case 0:
            return m_ContentArr.count;
        case 1:
            return list&&list[@"recommendShopList"]?[list[@"recommendShopList"] count]:0;
        case 2:
            return list&&list[@"recommendGoodsList"]?[list[@"recommendGoodsList"] count]:0;
        default:
            return list&&list[@"hotGoodsList"]?[list[@"hotGoodsList"] count]:0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *list = self.allDataDic[@"list"];
    switch (indexPath.section)
    {
        case 0:
        {
            static NSString *cellIdentifier = @"RootViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSString *contentTitle = m_ContentArr[indexPath.row];
            [cell.titleLab setText:contentTitle];
            [cell.imageView setImage:[UIImage imageNamed:contentTitle]];
            [cell.charLab setHidden:YES];
            return cell;
        }
        case 1:
        {
            static NSString *cellIdentifier = @"WebShopLeftOnePictureViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopLeftOnePictureViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopLeftOnePictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *recommendShopList = list[@"recommendShopList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:recommendShopList[indexPath.row][@"logo"]]];
            [cell.titleLab setText:recommendShopList[indexPath.row][@"name"]];
            [cell.detailLab setText:recommendShopList[indexPath.row][@"comment"]];
            return cell;
        }
        case 2:
        {
            static NSString *cellIdentifier = @"WebShopTwoPictureViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopTwoPictureViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopTwoPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *recommendGoodsList = list[@"recommendGoodsList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:recommendGoodsList[indexPath.row][@"primary_pic_url"]]];
            [cell.titleLab setText:recommendGoodsList[indexPath.row][@"name"]];
            [cell.moneyLab setText:[NSString stringWithFormat:@"￥ %@",recommendGoodsList[indexPath.row][@"retail_price"]]];
            [cell setShowRightPicture:NO];
//            if (indexPath.row > 1)
//            {
//                [cell setShowRightPicture:YES];
//                [cell.imageViewRight sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2504/25044439/raw_1536734636.jpeg"]];
//            }
            return cell;
        }
            break;
        default:
        {
            static NSString *cellIdentifier = @"WebShopOnePictureMoneyViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopOnePictureMoneyViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopOnePictureMoneyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *hotGoodsList = list[@"hotGoodsList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:hotGoodsList[indexPath.row][@"primary_pic_url"]]];
            [cell.titleLab setText:hotGoodsList[indexPath.row][@"name"]];
            [cell.moneyLab setText:[NSString stringWithFormat:@"￥ %@",hotGoodsList[indexPath.row][@"retail_price"]]];
            [cell.selfOperated setHidden:NO];//![hotGoodsList[indexPath.row][@"selfOperated"] boolValue]];
            [cell.Shipping setHidden:NO];//![hotGoodsList[indexPath.row][@"Shipping"] boolValue]];
            [cell.Shipping setLeft:cell.selfOperated.right+DIF_PX(12)];
            if (cell.selfOperated.hidden)
            {
                [cell.Shipping setLeft:cell.selfOperated.left];
            }
            return cell;
        }
    }
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
            case 1:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [titleView addSubview:contentView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, contentView.width-24, DIF_PX(50))];
                    [title setText:@"店铺推荐"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [title setTextAlignment:NSTextAlignmentCenter];
                    [contentView addSubview:title];
                }
            }
                break;
            case 2:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(150))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(140))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [titleView addSubview:contentView];
                    
                    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(80))];
                    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2504/25043337/raw_1536734004.jpeg"]];
                    [contentView addSubview:headerImageView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, headerImageView.bottom, contentView.width-24, DIF_PX(60))];
                    [title setText:@"商品推荐"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [title setTextAlignment:NSTextAlignmentCenter];
                    [contentView addSubview:title];
                }
            }
                break;
            default:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"")];
                    [titleView addSubview:contentView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, contentView.width-24, DIF_PX(50))];
                    [title setText:@"热销商品"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [title setTextAlignment:NSTextAlignmentCenter];
                    [contentView addSubview:title];
                }
            }
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
    if (self.selectBlock)
    {
        self.selectBlock(indexPath, nil);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            CGFloat widht = (m_ContentView.width)/4;
            return CGSizeMake(widht, DIF_PX(190/2));
        }
        case 1:
        {
            CGFloat widht = (m_ContentView.width)/2;
            return CGSizeMake(widht, DIF_PX(82));
        }
        case 2:
        {
            CGFloat widht = (m_ContentView.width)/2;
            return CGSizeMake(widht, DIF_PX(84));
        }
        default:
        {
            CGFloat widht = (m_ContentView.width)/2;
            return CGSizeMake(widht, DIF_PX(276));
        }
    }
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
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(150));
        case 1:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
        case 2:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(150));
        default:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
    }
}

@end


