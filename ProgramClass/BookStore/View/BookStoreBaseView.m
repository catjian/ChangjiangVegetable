//
//  BookStoreBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BookStoreBaseView.h"
#import "BookCoverCell.h"

@interface BookStoreBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation BookStoreBaseView
{
    BaseCollectionView *m_ContentView;
    UIWebView *m_webView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        [self createTopButtonsView];
//        [self createCollectionView];
        [self createWebView];
        [self setBackgroundColor:DIF_HEXCOLOR(@"f6f6f6")];
    }
    return self;
}

- (void)createTopButtonsView
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(0), DIF_SCREEN_WIDTH, DIF_PX(150))];
    [contentView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [contentView setTag:1000];
    [self addSubview:contentView];
    
    CommonADAutoView *headerImageView = [[CommonADAutoView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(100))];
    [headerImageView setTag:10001];
    [headerImageView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
    [contentView addSubview:headerImageView];
    [headerImageView setSelectBlock:^(NSInteger page) {
    }];
    NSMutableArray *picArr = [NSMutableArray array];
    [picArr addObject:@"https://free.modao.cc/uploads3/images/2504/25041835/raw_1536733080.jpeg"];
    headerImageView.picArr = picArr;
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.bottom, DIF_SCREEN_WIDTH, DIF_PX(50))];
    [contentView addSubview:buttonsView];
    
    UIButton *musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [musicBtn setFrame:CGRectMake(12, 0, 30, 30)];
    [musicBtn setCenterY:buttonsView.height/2];
    [musicBtn setTitle:@"🎵" forState:UIControlStateNormal];
    [musicBtn.layer setMasksToBounds:YES];
    [musicBtn.layer setCornerRadius:15];
    [buttonsView addSubview:musicBtn];
    
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [questionBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [questionBtn setCenterY:buttonsView.height/2];
    [questionBtn setRight:buttonsView.width-12];
    [questionBtn setTitle:@"?" forState:UIControlStateNormal];
    [questionBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [questionBtn.layer setMasksToBounds:YES];
    [questionBtn.layer setCornerRadius:15];
    [buttonsView addSubview:questionBtn];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"上半月刊", @"下半月刊", @"名企画册"]];
    [segment setFrame:CGRectMake(0, 0, 180, 38)];
    [segment setCenterY:buttonsView.height/2];
    [segment setCenterX:buttonsView.width/2];
    [segment setTintColor:[UIColor greenColor]];
    [segment setSelectedSegmentIndex:0];
    [buttonsView addSubview:segment];
}

- (void)createWebView
{
    m_webView = [[UIWebView alloc] initWithFrame:self.bounds];
    [m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wk.creativesky.cn/ctxf"]]];
    [self addSubview:m_webView];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(30, [self viewWithTag:1000].bottom, self.width-60, self.height-[self viewWithTag:1000].bottom)
                                              ScrollDirection:UICollectionViewScrollDirectionVertical
                                                CellClassName:@"BookCoverCell"];
    [m_ContentView registerClass:[UICollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderView"];
    [self addSubview:m_ContentView];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [m_ContentView setBackgroundColor:DIF_HEXCOLOR(@"")];
}

- (void)setBannerArr:(NSArray *)bannerArr
{
    _bannerArr = bannerArr;
    CommonADAutoView *adView = [[self viewWithTag:1000] viewWithTag:10001];
    if (self.bannerArr.count > 0)
    {
        adView.picArr = bannerArr;
    }
}

- (void)setBookListArr:(NSArray *)bookListArr
{
    _bookListArr = bookListArr;
    [m_ContentView performSelectorOnMainThread:@selector(reloadData)
                                    withObject:nil
                                 waitUntilDone:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIDENTIFIER";
    BookCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *bookDic = self.bookListArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bookDic[@"bookImgUrl"]]];
    [cell.titleLab setText:bookDic[@"bookName"]];
    return cell;
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
    return CGSizeMake(m_ContentView.width/3, DIF_PX(160));
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

@end
