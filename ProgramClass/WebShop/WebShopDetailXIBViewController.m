//
//  WebShopDetailXIBViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/12/2.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "WebShopDetailXIBViewController.h"
#import "WebShopOnePictureMoneyViewCell.h"

@interface WebShopDetailXIBViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopDanjia;
@property (weak, nonatomic) IBOutlet UILabel *kuaiDifeiyong;
@property (weak, nonatomic) IBOutlet UILabel *canDi;

@property (weak, nonatomic) IBOutlet UIView *maiJiaView;
@property (weak, nonatomic) IBOutlet UIImageView *maiJiaIcon;
@property (weak, nonatomic) IBOutlet UILabel *maiJiaName;
@property (weak, nonatomic) IBOutlet UILabel *maiJiaDetail;

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@property (weak, nonatomic) IBOutlet UIImageView *kefuImage;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *dianpuImage;
@property (weak, nonatomic) IBOutlet UIButton *dianpuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shoucangImage;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
@end

@implementation WebShopDetailXIBViewController
{
    BaseCollectionView *m_ContentView;
    NSArray *m_recommendGoodsList;
    NSDictionary *m_responseData;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView setContentSize:CGSizeMake(DIF_SCREEN_WIDTH, DIF_SCREEN_HEIGHT*2)];
}

- (IBAction)backButtonEvent:(id)sender {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gouwucheRightButtonEvent:(id)sender
{
    [self loadViewController:@"ShopCartViewController" hidesBottomBarWhenPushed:YES isNowPush:YES];
}


- (void)setShopDetailDic:(NSDictionary *)shopDetailDic
{
    _shopDetailDic = shopDetailDic;
    [self httpRequestGetGoodsDetailWithID];
}

- (IBAction)shoucangButtonEvent:(id)sender
{
    [self httpRequestPublicGoodsAddCollectWithTopicId];
}

- (IBAction)dianpuButtonEvent:(id)sender {
}

- (IBAction)kefuButtonEvent:(id)sender
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"总客服 QQ：12345678" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]] ;
    [alertCon addAction:[UIAlertAction actionWithTitle:@"商家 QQ：12345678910" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]] ;
    [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertCon dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (IBAction)jiaRuGouWuCheButtonEvent:(id)sender {
    [self httpRequestCartAddWithTopicId];
}

- (IBAction)liJiGouMaiButtonEvent:(id)sender {
}

- (void)createTopADImage:(NSArray *)images
{
    CommonADAutoView *adView = [[CommonADAutoView alloc] initWithFrame:CGRectMake(0, 0, self.topImage.width, self.topImage.height)];
    [adView setTag:10001];
    [adView setBackgroundColor:DIF_HEXCOLOR(@"017aff")];
    [self.topImage addSubview:adView];
    adView.picArr = images;
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    m_ContentView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, self.contentWebView.bottom, DIF_SCREEN_WIDTH, DIF_SCREEN_HEIGHT)
                                              ScrollDirection:UICollectionViewScrollDirectionVertical
                                                CellClassName:@"RootViewCell"];
    [m_ContentView registerClass:[UICollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"HeaderView"];
    [self.scrollView addSubview:m_ContentView];
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
    return m_recommendGoodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WebShopOnePictureMoneyViewCell_CELLIDENTIFIER";
    [m_ContentView registerClass:[WebShopOnePictureMoneyViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    WebShopOnePictureMoneyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:m_recommendGoodsList[indexPath.row][@"list_pic_url"]]];
    [cell.titleLab setText:m_recommendGoodsList[indexPath.row][@"name"]];
    [cell.moneyLab setText:[NSString stringWithFormat:@"￥ %@",m_recommendGoodsList[indexPath.row][@"retail_price"]]];
    [cell.selfOperated setHidden:![m_recommendGoodsList[indexPath.row][@"selfOperated"] boolValue]];
    [cell.Shipping setHidden:![m_recommendGoodsList[indexPath.row][@"Shipping"] boolValue]];
    [cell.Shipping setLeft:cell.selfOperated.right+DIF_PX(12)];
    if (cell.selfOperated.hidden)
    {
        [cell.Shipping setLeft:cell.selfOperated.left];
    }
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
            titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(60))];
            [titleView setTag:1000+indexPath.section];
            [titleView setBackgroundColor:DIF_HEXCOLOR(@"")];
            [reusableview addSubview:titleView];
            
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(10), DIF_SCREEN_WIDTH, DIF_PX(50))];
            [contentView setBackgroundColor:DIF_HEXCOLOR(@"")];
            [titleView addSubview:contentView];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, contentView.width-24, DIF_PX(50))];
            [title setText:@"为你推荐"];
            [title setFont:DIF_UIFONTOFSIZE(18)];
            [title setTextColor:DIF_HEXCOLOR(@"333333")];
            [title setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:title];
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
    WebShopDetailXIBViewController *vc = [self loadViewController:@"WebShopDetailXIBViewController" hidesBottomBarWhenPushed:NO];
    vc.shopDetailDic = m_recommendGoodsList[indexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat widht = (m_ContentView.width)/2;
    return CGSizeMake(widht, DIF_PX(276));
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
    return CGSizeMake(DIF_SCREEN_WIDTH, DIF_PX(60));
}

#pragma mark - httpRequest

- (void)httpRequestGetGoodsDetailWithID
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetGoodsDetailWithID:[NSString stringWithFormat:@"%@",self.shopDetailDic[@"id"]]
     referrer:nil
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            DIF_StrongSelf
            [CommonHUD hideHUD];
            strongSelf->m_responseData = responseModel[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                DIF_StrongSelf
                if ([strongSelf->m_responseData[@"goodsPicsList"] count] == 1)
                {
                    [strongSelf.topImage sd_setImageWithURL:strongSelf->m_responseData[@"goodsPicsList"][0]];
                }
                else if ([strongSelf->m_responseData[@"goodsPicsList"] count] > 1)
                {
                    [strongSelf createTopADImage:strongSelf->m_responseData[@"goodsPicsList"]];
                }
                [strongSelf.shopName setText:strongSelf->m_responseData[@"name"]];
                [strongSelf.shopDanjia setText:[NSString stringWithFormat:@"￥ %@ %@",strongSelf->m_responseData[@"price"],strongSelf->m_responseData[@"unit"]]];
                [strongSelf.kuaiDifeiyong setText:[NSString stringWithFormat:@"快递：%@ 元",strongSelf->m_responseData[@"expressFee"]]];
                [strongSelf.canDi setText:@""];
                [strongSelf.contentWebView loadHTMLString:strongSelf->m_responseData[@"goodsDesc"] baseURL:nil];
                
                UITextView *m_TextView = [[UITextView alloc] initWithFrame:strongSelf.contentWebView.bounds];
                m_TextView.editable = NO;
                [strongSelf.contentWebView addSubview:m_TextView];
                NSString *htmlStr = strongSelf->m_responseData[@"goodsDesc"];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                [m_TextView setAttributedText:attributedString];
                CGSize htmlSize = [attributedString AttributedSizeWithBaseWidth:DIF_SCREEN_WIDTH];
                [m_TextView setHeight:htmlSize.height];
                [strongSelf.contentWebView setHeight:htmlSize.height];
                strongSelf->m_recommendGoodsList = strongSelf->m_responseData[@"recommendGoodsList"];
                [strongSelf createCollectionView];
                [strongSelf.scrollView setContentSize:CGSizeMake(DIF_SCREEN_WIDTH, DIF_SCREEN_HEIGHT*2+htmlSize.height)];
            });
        }
        else
        {
            [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
        }
    } FailedBlcok:^(NSError *error) {
        [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
    }];
}

- (void)httpRequestPublicGoodsAddCollectWithTopicId
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestPublicGoodsAddCollectWithTopicId:[NSString stringWithFormat:@"%@",m_responseData[@"id"]]
     ProductId:[NSString stringWithFormat:@"%@",m_responseData[@"productId"]]
     Status:self.shoucangImage.highlighted?@"1":@"-1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             strongSelf.shoucangImage.highlighted = !strongSelf.shoucangImage.highlighted;
             [CommonHUD delayShowHUDWithMessage:@"收藏成功"];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }
     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

- (void)httpRequestCartAddWithTopicId
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestCartAddWithTopicId:[NSString stringWithFormat:@"%@",m_responseData[@"id"]]
     ProductId:[NSString stringWithFormat:@"%@",m_responseData[@"productId"]]
     Number:@"1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             strongSelf.shoucangImage.highlighted = !strongSelf.shoucangImage.highlighted;
             [CommonHUD delayShowHUDWithMessage:@"加入成功"];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }
     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}


@end
