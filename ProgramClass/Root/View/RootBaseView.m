//
//  RootBaseView.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/10.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "RootBaseView.h"

@interface RootBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation RootBaseView
{
    UIButton *m_NoticeBtn;
    UILabel *m_NoticeLab;
    BaseCollectionView *m_ContentView;
    NSArray *m_ContentArr;
    UIView *m_NoticeView;
    NSInteger m_noticeIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_noticeIndex = 0;
        m_ContentArr = @[@"热门资讯",@"我要读刊",@"远程问诊",@"供求信息",@"我的投稿"];
        [self createCollectionView];
    }
    return self;
}

#pragma mark - notice Lable View
- (UIButton *)noticeLabWithleft:(CGFloat)left
{
    if (!m_NoticeBtn)
    {
        m_NoticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_NoticeBtn setFrame:CGRectMake(left+DIF_PX(10), 0, self.width-DIF_PX(14*2), DIF_PX(50))];
        [m_NoticeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [m_NoticeBtn setTitle:@"" forState:UIControlStateNormal];
        
        m_NoticeLab = [[UILabel alloc] initWithFrame:CGRectMake(left+DIF_PX(10), 0, self.width-DIF_PX(14*2), DIF_PX(50))];
        [m_NoticeLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [m_NoticeLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_NoticeLab setTextColor:DIF_HEXCOLOR(@"666666") ];
        [m_NoticeLab setText:@"" ];
    }
    return m_NoticeBtn;
}

- (void)runNoticeLab
{
    [m_NoticeLab setAlpha:0];
    [m_NoticeLab setText:@"这次的黑锅，农药表示不背！木耳打药视频"];
    NSDictionary *list = self.allDataDic[@"list"];
    NSArray *noticeList = list[@"noticeList"];
    [m_NoticeLab setText:noticeList[m_noticeIndex]];
    m_noticeIndex = ++m_noticeIndex >= noticeList.count?0:m_noticeIndex;
    DIF_WeakSelf(self)
    [UIView animateWithDuration:2 animations:^{
        DIF_StrongSelf
        [strongSelf->m_NoticeLab setAlpha:1];
        [strongSelf->m_NoticeLab setTop:DIF_PX(0)];
    } completion:^(BOOL finished) {
        if (!finished)
        {
            return ;
        }
        [UIView animateWithDuration:2
                              delay:4
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             DIF_StrongSelf
                             [strongSelf->m_NoticeLab setAlpha:0];
                             [strongSelf->m_NoticeLab setTop:-DIF_PX(12)];
                         } completion:^(BOOL finished) {
                             DIF_StrongSelf
                             [strongSelf->m_NoticeLab setText:@""];
                             [strongSelf->m_NoticeLab setTop:DIF_PX(12)];
                             if (finished)
                             {
                                 [strongSelf runNoticeLab];
                             }
                         }];
    }];
}

- (UIView *)createNoticeView
{
    if (!m_NoticeView)
    {
        m_NoticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, DIF_PX(50))];
        [m_NoticeView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(0), DIF_PX(100), DIF_PX(50))];
        [titleLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [titleLab setFont:DIF_DIFONTOFSIZE(16)];
        [titleLab setTextColor:DIF_HEXCOLOR(@"666666") ];
        [titleLab setText:@"最新资讯" ];
        [m_NoticeView addSubview:titleLab];
        [m_NoticeView addSubview:[self noticeLabWithleft:titleLab.right]];
        [m_NoticeView addSubview:m_NoticeLab];
    }
    
    return m_NoticeView;
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
//    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 30, 0)];
}

- (void)setAllDataDic:(NSDictionary *)allDataDic
{
    _allDataDic = allDataDic;
    [m_ContentView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *list = self.allDataDic[@"list"];
    switch (section)
    {
        case 0:
            return m_ContentArr.count;
        case 1:
            return 1;
        case 2:
            return list&&list[@"newGoodsList"]?[list[@"newGoodsList"] count]:0;
        case 3:
            return list&&list[@"discountGoodsList"]?[list[@"discountGoodsList"] count]:0;
        case 4:
            return list&&list[@"hotTopicsList"]?[list[@"hotTopicsList"] count]:0;
        default:
            return list&&list[@"newVideoList"]?[list[@"newVideoList"] count]:0;
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
            static NSString *cellIdentifier = @"RootOnlyPictureCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootOnlyPictureCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootOnlyPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }
        case 2:
        {
            static NSString *cellIdentifier = @"RootViewLoanCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootViewLoanCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootViewLoanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *newGoodsList = list[@"newGoodsList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:newGoodsList[indexPath.row][@"imgUrl"]]];
            [cell.titleLab setText:newGoodsList[indexPath.row][@"name"]];
            return cell;
        }
        case 3:
        {
            static NSString *cellIdentifier = @"RootViewHotCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootViewHotCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootViewHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *discountGoodsList = list[@"discountGoodsList"];
            [cell.titleLab setText:discountGoodsList[indexPath.row][@"discountTitle"]];
            [cell.detailLab setText:discountGoodsList[indexPath.row][@"discountSubTtitle"]];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:discountGoodsList[indexPath.row][@"imgUrl"]]];
            return cell;
        }
        case 4:
        {
            static NSString *cellIdentifier = @"RooViewNewsCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RooViewNewsCell class] forCellWithReuseIdentifier:cellIdentifier];
            RooViewNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *hotTopicsList = list[@"hotTopicsList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:hotTopicsList[indexPath.row][@"imgUrl"]]];
            [cell.titleLab setText:hotTopicsList[indexPath.row][@"title"]];
            NSString *date = [CommonDate dateToString:[NSDate dateWithTimeIntervalSince1970:[hotTopicsList[indexPath.row][@"createDate"] integerValue]/1000]
                                              Formate:@"yyyy年MM月dd日"];
            [cell.detailLab setText:[NSString stringWithFormat:@"%@    阅读量：%d@",date,[hotTopicsList[indexPath.row][@"readNums"] intValue]]];
            return cell;
        }
            break;
        default:
        {
            static NSString *cellIdentifier = @"RootVideoViewCell_CELLIDENTIFIER";
            [m_ContentView registerClass:[RootVideoViewCell class] forCellWithReuseIdentifier:cellIdentifier];
            RootVideoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
            NSArray<NSDictionary *> *newVideoList = list[@"newVideoList"];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:newVideoList[indexPath.row][@"videoFirstFrameUrl"]]];
            [cell.titleLab setText:newVideoList[indexPath.row][@"title"]];
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
                    [reusableview addSubview:titleView];;
                    
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
                break;
            case 1:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [titleView addSubview:contentView];
                    
                    [m_NoticeView removeFromSuperview];
                    m_NoticeView = nil;
                    [contentView addSubview:[self createNoticeView]];
                    [m_NoticeLab.layer removeAllAnimations];
                    [self runNoticeLab];
                }
            }
                break;
            case 2:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [titleView addSubview:contentView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, contentView.width-24, DIF_PX(50))];
                    [title setText:@"新品上新"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [title setTextAlignment:NSTextAlignmentCenter];
                    [contentView addSubview:title];
                }
            }
                break;
            case 3:
            {
                [[reusableview viewWithTag:1000+3] removeFromSuperview];
            }
                break;
            case 4:
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
                    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2496/24967896/raw_1536655865.jpeg"]];
                    [contentView addSubview:headerImageView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, headerImageView.bottom, contentView.width-12*3-40, DIF_PX(60))];
                    [title setText:@"新品上新"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [contentView addSubview:title];
                    
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
            default:
            {
                if (!titleView)
                {
                    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
                    [titleView setTag:1000+indexPath.section];
                    [titleView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [reusableview addSubview:titleView];
                    
                    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
                    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
                    [titleView addSubview:contentView];
                    
                    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, contentView.width-24, contentView.height)];
                    [title setText:@"最新视频"];
                    [title setFont:DIF_UIFONTOFSIZE(18)];
                    [title setTextColor:DIF_HEXCOLOR(@"fc7940")];
                    [contentView addSubview:title];
                    
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
            CGFloat widht = (DIF_SCREEN_WIDTH)/5;
            return CGSizeMake(widht, DIF_PX(100));
        }
        case 1:
        {
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(80));
        }
        case 2:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/2;
            return CGSizeMake(widht, DIF_PX(116));
        }
        case 3:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/4;
            return CGSizeMake(widht, DIF_PX(140));
        }
        case 4:
        {
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(95));
        }
        default:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/2;
            return CGSizeMake(widht, DIF_PX(130));
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
        case 3:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(0));
        case 4:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(150));
        case 5:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
        default:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
    }
}

@end
