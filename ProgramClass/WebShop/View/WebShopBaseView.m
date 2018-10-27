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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 8;
        case 1:
            return 4;
        case 2:
            return 4;
        default:
            return 6;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            static NSString *cellIdentifier = @"RootViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSString *contentTitle = m_ContentArr[indexPath.row];
            [cell.titleLab setText:contentTitle];
//            NSArray *imageArr = @[@"https://free.modao.cc/uploads3/images/2583/25839420/v2_pg9d3c.png",
//                                  @"https://free.modao.cc/uploads3/images/2584/25840711/v2_pg9e3i.png",
//                                  @"https://free.modao.cc/uploads3/images/2502/25027592/raw_1536719120.png",
//                                  @"https://free.modao.cc/uploads3/images/2502/25027526/raw_1536719071.png",
//                                  @"https://free.modao.cc/uploads3/images/2584/25840861/v2_pg9e7w.png",
//                                  @"https://free.modao.cc/uploads3/images/2502/25027760/raw_1536719241.png",
//                                  @"https://free.modao.cc/uploads3/images/2502/25027732/raw_1536719221.png",
//                                  @"https://free.modao.cc/uploads3/images/2584/25841049/v2_pg9eee.png"];
//            NSArray *imageColor = @[@"#FF8181", @"#FF8181", @"#7BB7F6", @"#FCCA2A",
//                                    @"#B6F6D5", @"#BEC4FD", @"#FFBA77", @"#80A9F3"];
            [cell.imageView setImage:[UIImage imageNamed:contentTitle]];
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[indexPath.row]]];
//            [cell.imageView setBackgroundColor:DIF_HEXCOLOR(imageColor[indexPath.row])];
            [cell.charLab setHidden:YES];
            return cell;
        }
        case 1:
        {
            static NSString *cellIdentifier = @"WebShopLeftOnePictureViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopLeftOnePictureViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopLeftOnePictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray *imageArr = @[@"https://free.modao.cc/uploads3/images/2504/25042186/raw_1536733305.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25042217/raw_1536733319.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25042243/raw_1536733336.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25042261/raw_1536733348.jpeg"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[indexPath.row]]];
            [cell.titleLab setText:@"寿光农业"];
            [cell.detailLab setText:@"农资、种子方面的开发、生产"];
            return cell;
        }
        case 2:
        {
            static NSString *cellIdentifier = @"WebShopTwoPictureViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopTwoPictureViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopTwoPictureViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray *imageArr = @[@"https://free.modao.cc/uploads3/images/2504/25044138/raw_1536734462.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2513/25136428/raw_1536891821.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2500/25004387/raw_1536656531.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25044470/raw_1536734652.png"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[indexPath.row]]];
            [cell.titleLab setText:@"果树盆栽"];
            [cell.moneyLab setText:@"￥888.99"];
            [cell setShowRightPicture:NO];
            if (indexPath.row > 1)
            {
                [cell setShowRightPicture:YES];
                [cell.imageViewRight sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2504/25044439/raw_1536734636.jpeg"]];
            }
            return cell;
        }
            break;
        default:
        {
            static NSString *cellIdentifier = @"WebShopOnePictureMoneyViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[WebShopOnePictureMoneyViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            WebShopOnePictureMoneyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray *imageArr = @[@"https://free.modao.cc/uploads3/images/2504/25044577/raw_1536734718.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25045876/raw_1536735416.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25042243/raw_1536733336.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25046024/raw_1536735488.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25046117/raw_1536735531.jpeg",
                                  @"https://free.modao.cc/uploads3/images/2504/25046168/raw_1536735555.jpeg"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageArr[indexPath.row]]];
            NSArray *titleArr = @[@"特色蔬菜种子 白芦笋种", @"皮薄质嫩辣椒优美薄皮"];
            [cell.titleLab setText:titleArr[indexPath.row%2]];
            [cell.moneyLab setText:@"￥888.99"];
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
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(150))];
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
                }
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
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/4;
            return CGSizeMake(widht, DIF_PX(190/2));
        }
        case 1:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/2;
            return CGSizeMake(widht, DIF_PX(82));
        }
        case 2:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/2;
            return CGSizeMake(widht, DIF_PX(84));
        }
        default:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/2;
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


