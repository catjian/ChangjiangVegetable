//
//  BookShelfBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BookShelfBaseView.h"
#import "BookCoverCell.h"

@interface BookShelfBaseView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation BookShelfBaseView
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CELLIDENTIFIER";
    BookCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView setFrame:CGRectMake(0, 6, DIF_PX(96), DIF_PX(130))];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2532/25326440/raw_1537325759.jpeg"]];
    [cell.titleLab setText:@"2018年（上）"];
    [cell.titleLab setTop:cell.imageView.bottom];
    if (indexPath.row == 13)
    {
        UIImage *add = [UIImage imageNamed:@"加"];
        [cell.imageView setSize:add.size];
        [cell.imageView setCenterX:cell.width/2];
        [cell.imageView setCenterY:cell.height/2];
        [cell.imageView setImage:add];
        [cell.titleLab setText:@"逛书城"];
        [cell.titleLab setTop:cell.imageView.bottom];
    }
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
    return CGSizeMake((DIF_SCREEN_WIDTH-60)/3, DIF_PX(160));
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
