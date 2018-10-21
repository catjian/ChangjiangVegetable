//
//  VideoListBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/20.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "VideoListBaseView.h"

@interface VideoListBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation VideoListBaseView
{
    UIButton *m_NoticeBtn;
    UILabel *m_NoticeLab;
    BaseCollectionView *m_ContentView;
    NSArray *m_ContentArr;
    UIView *m_NoticeView;
    NSInteger m_noticeIndex;
    NSInteger m_SegmentIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_noticeIndex = 0;
    }
    return self;
}

- (void)createPageController
{
    NSMutableArray *titles = [NSMutableArray array];
//    for (NSDictionary *dic in self.classifyArr)
//    {
//        ArticleclassifyModel *model = [ArticleclassifyModel mj_objectWithKeyValues:dic];
//        [titles addObject:model.classifyName];
//    }
    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))
                                                                            titles:titles];
    [self addSubview:pageView];
    UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, 1)];
    [lineT setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
    [self addSubview:lineT];
    UIView *lineB = [[UIView alloc] initWithFrame:CGRectMake(0, pageView.height-1, DIF_SCREEN_WIDTH, 1)];
    [lineB setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
    [self addSubview:lineB];
    DIF_WeakSelf(self)
    [pageView setSelectBlock:^(NSInteger page) {
        DIF_StrongSelf
    }];
    [self createCollectionViewW];
}

- (UIButton *)noticeLabWithleft:(CGFloat)left
{
    if (!m_NoticeBtn)
    {
        m_NoticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_NoticeBtn setFrame:CGRectMake(left+DIF_PX(10), 0, self.width-DIF_PX(14*2), DIF_PX(42))];
        [m_NoticeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [m_NoticeBtn setTitle:@"" forState:UIControlStateNormal];
        [m_NoticeBtn addTarget:self action:@selector(noticeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        m_NoticeLab = [[UILabel alloc] initWithFrame:CGRectMake(left+DIF_PX(10), DIF_PX(12), self.width-DIF_PX(14*2), DIF_PX(42))];
        [m_NoticeLab setBackgroundColor:DIF_HEXCOLOR(@"")];
        [m_NoticeLab setFont:DIF_DIFONTOFSIZE(13)];
        [m_NoticeLab setTextColor:DIF_HEXCOLOR(@"333333") ];
        [m_NoticeLab setText:@"" ];
    }
    return m_NoticeBtn;
}

- (void)runNoticeLab
{
    [m_NoticeLab setAlpha:0];
//    RootNoticeListModel *model = [RootNoticeListModel mj_objectWithKeyValues:self.noticeListArr[m_noticeIndex]];
//    [m_NoticeLab setText:model.noticeTitle];
//    m_noticeIndex = ++m_noticeIndex >= self.noticeListArr.count?0:m_noticeIndex;
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

-(void)noticeButtonEvent:(UIButton *)btn
{
//    if (self.selectBlock && self.noticeListArr.count > 0)
//    {
//        RootNoticeListModel *model = [RootNoticeListModel mj_objectWithKeyValues:self.noticeListArr[m_noticeIndex]];
//        self.selectBlock([NSIndexPath indexPathForRow:9 inSection:9], model);
//    }
}

- (UIView *)createNoticeView
{
    if (!m_NoticeView)
    {
        m_NoticeView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(150), self.width, DIF_PX(42))];
        [m_NoticeView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [m_NoticeView setTag:999];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"消息喇叭"]];
        [imageView setLeft:DIF_PX(12)];
        [imageView setCenterY:m_NoticeView.height/2];
        [m_NoticeView addSubview:imageView];
        [m_NoticeView addSubview:[self noticeLabWithleft:imageView.right]];
        [m_NoticeView addSubview:m_NoticeLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, m_NoticeView.height-1, m_NoticeView.width, 1)];
        [line setBackgroundColor:DIF_HEXCOLOR(@"dedede")];
        [m_NoticeView addSubview:line];
    }
    
    return m_NoticeView;
}

- (void)createCollectionViewW
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0;
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"RooViewNewsTextCell_CELLIDENTIFIER";
//    [m_ContentView registerClass:[RooViewNewsTextCell class] forCellWithReuseIdentifier:cellIdentifier];
//    RooViewNewsTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    [cell.title setText:model.title];
//    [cell.detail setText:model.summary];
//    [cell.company setText:[NSString stringWithFormat:@"%@阅读",model.hits]];
//    return cell;
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    }
    return reusableview;
}

- (void)headerViewMoreButtonEvent:(UIButton *)btn
{
    UIView *titleView = btn.superview.superview;
    if (titleView.tag - 1000 == 4)
    {
        [DIF_TabBar setSelectedIndex:1];
    }
    if (titleView.tag -1000 == 1 || titleView.tag -1000 == 2 || titleView.tag -1000 == 3)
    {
    }
}

#pragma mark - UICollecrtionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                case 1:
                case 2:
                    break;
                default:
                    [CommonAlertView showAlertViewOneBtnWithTitle:@"温馨提示"
                                                          Message:@"功能还未开通\n敬请期待！"
                                                      ButtonTitle:nil];
                    break;
            }
        }
            break;
        default:
        {
        }
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            //            CGFloat widht = (DIF_SCREEN_WIDTH-6*DIF_PX(12))/5;
            CGFloat widht = (DIF_SCREEN_WIDTH)/5;
            return CGSizeMake(widht, DIF_PX(100));
        }
        case 1:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH)/5;
            return CGSizeMake(widht, DIF_PX(95));
        }
        case 2:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH-4*DIF_PX(12))/2;
            return CGSizeMake(widht, DIF_PX(70));
        }
        case 3:
        {
            CGFloat widht = (DIF_SCREEN_WIDTH-4*DIF_PX(12))/2;
            return CGSizeMake(widht, DIF_PX(190));
        }
        default:
        {
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(95));
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return UIEdgeInsetsMake(DIF_PX(0), DIF_PX(0), DIF_PX(0), DIF_PX(0));
        case 1:
            return UIEdgeInsetsMake(DIF_PX(0), DIF_PX(0), DIF_PX(0), DIF_PX(0));
        case 2:
        case 3:
            return UIEdgeInsetsMake(DIF_PX(0), DIF_PX(12), DIF_PX(0), DIF_PX(12));
        default:
            return UIEdgeInsetsMake(DIF_PX(0), DIF_PX(0), DIF_PX(0), DIF_PX(0));
    }
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
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(192));
        case 1:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(0));
        default:
            return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
    }
}

@end

