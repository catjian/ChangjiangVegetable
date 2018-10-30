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
        [self setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    }
    return self;
}

- (void)createPageController
{
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in self.channelArray)
    {
        [titles addObject:dic[@"menuName"]];
    }
    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH-34, 40)
                                                                            titles:titles
                                                                          oneWidth:(DIF_SCREEN_WIDTH-34)/4-12];
    [self addSubview:pageView];
    DIF_WeakSelf(self)
    [pageView setSelectBlock:^(NSInteger page) {
        DIF_StrongSelf
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [btn setFrame:CGRectMake(pageView.right+6, 0, 22, 40)];
    [btn setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
//    [btn setTitle:@"E" forState:UIControlStateNormal];
    [btn setTitleColor:DIF_HEXCOLOR(@"808080") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pageControlSelectChannelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [self createCollectionView];
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
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 40, self.width, self.height)
                                              ScrollDirection:UICollectionViewScrollDirectionVertical
                                                CellClassName:@"RootViewCell"];
    [m_ContentView registerClass:[UICollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderView"];
    [self addSubview:m_ContentView];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
//    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 90, 0)];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *list = self.allDataDic[@"list"];
    return list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *videoList = self.allDataDic[@"list"];
    NSDictionary *videoDic = videoList[indexPath.row];
    NSArray *imgUrlList = videoDic[@"imgUrlList"];
    if (imgUrlList.count <= 1)
    {
        static NSString *cellIdentifier = @"HotInformationNormalCell_CELLIDENTIFIER";
        [m_ContentView registerClass:[HotInformationNormalCell class] forCellWithReuseIdentifier:cellIdentifier];
        HotInformationNormalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrlList.firstObject]];
        [cell.titleLab setText:videoDic[@"title"]];
//        NSString *date = [CommonDate dateToString:[NSDate dateWithTimeIntervalSince1970:[videoDic[@"createDate"] integerValue]/1000]
//                                          Formate:@"yyyy年MM月dd日"];
        [cell.detailLab setText:[NSString stringWithFormat:@"%@    阅读量：%d@",videoDic[@"createDate"],[videoDic[@"readNum"] intValue]]];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"HotInformationThreePictureCell_CELLIDENTIFIER";
        [m_ContentView registerClass:[HotInformationThreePictureCell class] forCellWithReuseIdentifier:cellIdentifier];
        HotInformationThreePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrlList[0]]];
        [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:imgUrlList[1]]];
        if (imgUrlList.count > 2) {
            [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:imgUrlList[2]]];
        }
        [cell.titleLab setText:videoDic[@"title"]];
        //        NSString *date = [CommonDate dateToString:[NSDate dateWithTimeIntervalSince1970:[videoDic[@"createDate"] integerValue]/1000]
        //                                          Formate:@"yyyy年MM月dd日"];
        [cell.detailLab setText:[NSString stringWithFormat:@"%@    阅读量：%d@",videoDic[@"createDate"],[videoDic[@"readNum"] intValue]]];
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
    NSArray *videoList = self.allDataDic[@"list"];
    NSDictionary *videoDic = videoList[indexPath.row];
    NSArray *imgUrlList = videoDic[@"imgUrlList"];
    return CGSizeMake(DIF_SCREEN_WIDTH, imgUrlList.count <= 1? DIF_PX(92):DIF_PX(164));
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


