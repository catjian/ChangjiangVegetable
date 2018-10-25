//
//  HotInformationBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "HotInformationBaseView.h"
#import "HotInformationNormalCell.h"
#import "HotInformationThreePictureCell.h"

@interface HotInformationBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation HotInformationBaseView
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
                                                                            titles:@[@"热门新闻",@"品种导航",@"栽培技术",@"庄稼医生"]
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
    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 90, 0)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%5 != 0)
    {
        static NSString *cellIdentifier = @"HotInformationNormalCell_CELLIDENTIFIER";
        [m_ContentView registerClass:[HotInformationNormalCell class] forCellWithReuseIdentifier:cellIdentifier];
        HotInformationNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2513/25139904/raw_1536893891.jpeg"]];
        [cell.titleLab setText:@"罕见！多地大棚被狂风暴雨击垮！台风致山东河南等地农业损失惨重."];
        [cell.detailLab setText:@"2018年8月10日    阅读量：8888"];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"HotInformationThreePictureCell_CELLIDENTIFIER";
        [m_ContentView registerClass:[HotInformationThreePictureCell class] forCellWithReuseIdentifier:cellIdentifier];
        HotInformationThreePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2513/25138479/raw_1536893021.jpeg"]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2513/25138505/raw_1536893038.jpeg"]];
        [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2513/25138534/raw_1536893068.jpeg"]];
        [cell.titleLab setText:@"科研编织“致富梦”，品质打赢“市场牌”—长阳火烧坪高山蔬菜基地调研实录"];
        [cell.detailLab setText:@"2018年8月10日    阅读量：8888"];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
    return CGSizeMake(DIF_SCREEN_WIDTH, indexPath.row%5!=0? DIF_PX(92):DIF_PX(164));
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
    return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(0));
}

@end


