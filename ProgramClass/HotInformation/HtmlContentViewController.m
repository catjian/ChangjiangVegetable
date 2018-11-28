//
//  HtmlContentViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/22.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "HtmlContentViewController.h"
#import "IMInpuerView.h"
#import "AllCommentViewController.h"

@interface HtmlContentViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *commentNumLab;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *sharedBtn;

@end

@implementation HtmlContentViewController
{
    UIScrollView *m_BackView;
    UILabel *m_TitleLab;
    UILabel *m_DateLab;
    UILabel *m_ReadLab;
    UILabel *m_ContentLab;
    NSMutableDictionary *m_Result;
    UIView *m_RecommondView;
    NSArray *m_CommentList;
    IMInpuerView *m_InputView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_HideTabBarAnimation(NO);
    // Do any additional setup after loading the view from its nib.
    [self setNavTarBarTitle:@"文章详情"];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [m_InputView HideSendButton:YES];
    [m_InputView setInputWidth:DIF_PX(250)];
    [self.sharedBtn setHidden:NO];
    [self.collectBtn setHidden:NO];
    [self.commentNumLab setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BackView)
    {
        m_BackView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [m_BackView setDelegate:self];
        [self.view addSubview:m_BackView];
        m_TitleLab = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(6), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(30))];
        [m_TitleLab setLineBreakMode:NSLineBreakByCharWrapping];
        [m_TitleLab setNumberOfLines:0];
        [m_TitleLab setFont:DIF_DIFONTOFSIZE(20)];
        [m_TitleLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [m_BackView addSubview:m_TitleLab];
        
        m_DateLab =  [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), m_TitleLab.bottom+DIF_PX(16), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(20))];
        [m_DateLab setLineBreakMode:NSLineBreakByCharWrapping];
        [m_DateLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_DateLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [m_BackView addSubview:m_DateLab];
        
        m_ReadLab =  [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), m_DateLab.bottom+DIF_PX(6), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(20))];
        [m_ReadLab setLineBreakMode:NSLineBreakByCharWrapping];
        [m_ReadLab setTextAlignment:NSTextAlignmentRight];
        [m_ReadLab setRight:DIF_SCREEN_WIDTH-DIF_PX(6)];
        [m_ReadLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_ReadLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [m_BackView addSubview:m_ReadLab];
        
        m_ContentLab =  [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), m_ReadLab.bottom+DIF_PX(1), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(30))];
        [m_ContentLab setLineBreakMode:NSLineBreakByCharWrapping];
        [m_ContentLab setNumberOfLines:0];
        [m_ContentLab setFont:DIF_DIFONTOFSIZE(14)];
        [m_ContentLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [m_BackView addSubview:m_ContentLab];
        
        [self createCommentAndRecommond];
        
        [self createInputView];
        [self httpRequestGetDetail];
    }
}

- (void)createCommentAndRecommond
{
    m_RecommondView = [[UIView alloc] initWithFrame:CGRectMake(0, m_ContentLab.bottom+DIF_PX(6), DIF_SCREEN_WIDTH, DIF_PX(150))];
    [m_RecommondView setHidden:YES];
    [m_BackView addSubview:m_RecommondView];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setFrame:CGRectMake(0, 0, DIF_PX(82), DIF_PX(30))];
    [likeBtn setCenterX:m_RecommondView.width/2];
    [likeBtn setImage:[UIImage imageNamed:@"点赞(1)"] forState:UIControlStateNormal];
    [likeBtn setTitle:@"0" forState:UIControlStateNormal];
    [likeBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:DIF_PX(5)];
    [likeBtn setTag:999];
    [likeBtn.layer setMasksToBounds:YES];
    [likeBtn.layer setCornerRadius:likeBtn.height/2];
    [likeBtn.layer setBorderWidth:1];
    [likeBtn.layer setBorderColor:DIF_HEXCOLOR(@"999999").CGColor];
    [likeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
    [likeBtn addTarget:self action:@selector(likeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [m_RecommondView addSubview:likeBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(0, 0, m_RecommondView.width, DIF_PX(30))];
    [moreBtn setCenterX:m_RecommondView.width/2];
    [moreBtn setTitle:@"更多精彩评论>>" forState:UIControlStateNormal];
    [moreBtn setTag:998];
    [moreBtn setTitleColor:DIF_HEXCOLOR(@"FC7940") forState:UIControlStateNormal];
    [moreBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
    [moreBtn addTarget:self action:@selector(gotoAllCommentView) forControlEvents:UIControlEventTouchUpInside];
    [m_RecommondView addSubview:moreBtn];
}

- (void)gotoAllCommentView
{
    AllCommentViewController *vc = [self loadViewController:@"AllCommentViewController"];
    vc.tradeId = self.tradeId;
}

- (void)createInputView
{
    __block CGFloat startHeigt = 0;
    m_InputView = [[IMInpuerView alloc] initWithFrame:CGRectMake(0, self.view.height-43, self.view.width, 43)];
    [m_InputView HideSendButton:YES];
    [m_InputView setInputWidth:DIF_PX(250)];
    [m_InputView setPlaceholderString:@"说两句"];
    [self.view addSubview:m_InputView];
    DIF_WeakSelf(self)
    [m_InputView setChangeBlock:^{
        DIF_StrongSelf
        CGFloat top = startHeigt;
        top  -= strongSelf->m_InputView.height - 43;
        [strongSelf->m_InputView setTop:top];
    }];
    [m_InputView setEditBlock:^(BOOL isStart, NSNotification* note) {
        DIF_StrongSelf
        if(isStart)
        {
            [strongSelf->m_InputView HideSendButton:NO];
            [strongSelf->m_InputView setInputWidth:DIF_SCREEN_WIDTH-7*3-69-18];
            [strongSelf.sharedBtn setHidden:YES];
            [strongSelf.collectBtn setHidden:YES];
            [strongSelf.commentNumLab setHidden:YES];
        }
        else
        {
//            [strongSelf->m_InputView setTop:strongSelf.view.height-strongSelf->m_InputView.height];
            [strongSelf->m_InputView HideSendButton:YES];
            [strongSelf->m_InputView setInputWidth:DIF_PX(250)];
        }
        startHeigt = strongSelf->m_InputView.top;
    }];
    [m_InputView setSendBlock:^(NSString * _Nonnull message) {
        DIF_StrongSelf
        [CommonHUD showHUDWithMessage:@"发表中..."];
        [DIF_CommonHttpAdapter
         httpRequestPublicSaveCommentWithTopicId:strongSelf.tradeId
         comment:@{@"content":message}
         ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
             if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
             {
                 [CommonHUD delayShowHUDWithMessage:@"发表成功"];
             }
             else
             {
                 [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
             }
         }
         FailedBlcok:^(NSError *error) {
             [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
         }];
    }];
    
    self.sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sharedBtn setFrame:CGRectMake(0, 0, DIF_PX(30), DIF_PX(30))];
    [self.sharedBtn setRight:m_InputView.width-7];
    [self.sharedBtn setCenterY:m_InputView.height/2];
    [self.sharedBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [m_InputView addSubview:self.sharedBtn];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectBtn setFrame:CGRectMake(0, 0, DIF_PX(30), DIF_PX(30))];
    [self.collectBtn setRight:self.sharedBtn.left-7];
    [self.collectBtn setCenterY:m_InputView.height/2];
    [self.collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [self.collectBtn setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateSelected];
    [self.collectBtn addTarget:self action:@selector(collectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [m_InputView addSubview:self.collectBtn];
    
    self.commentNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.collectBtn.top,DIF_PX(60),
                                                                   self.collectBtn.height)];
    [self.commentNumLab setRight:self.collectBtn.left-7];
    [self.commentNumLab setFont:DIF_DIFONTOFSIZE(14)];
    [self.commentNumLab setTextColor:DIF_HEXCOLOR(@"999999")];
    [self.commentNumLab setTextAlignment:NSTextAlignmentRight];
    [m_InputView addSubview:self.commentNumLab];
}

- (void)likeButtonEvent:(UIButton *)btn
{
    DIF_WeakSelf(self)
    [CommonHUD showHUDWithMessage:[m_Result[@"likeStatus"] integerValue]==1?@"取消点赞":@"点赞"];
    [DIF_CommonHttpAdapter
     httpRequestGetPublicLikeWithTopicId:self.tradeId
     Status:[m_Result[@"likeStatus"] integerValue]==1?@"-1":@"1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD delayShowHUDWithMessage:[strongSelf->m_Result[@"likeStatus"] integerValue]==1?@"取消点赞成功":@"点赞成功"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIButton *likeBtn = [strongSelf->m_RecommondView viewWithTag:999];
                 if ([strongSelf->m_Result[@"likeStatus"] integerValue]!=1)
                 {
                     [likeBtn setImage:[UIImage imageNamed:@"点赞(1)"] forState:UIControlStateNormal];
                     [likeBtn setBackgroundColor:DIF_HEXCOLOR(@"ba1212")];
                     [likeBtn setTitleColor:DIF_HEXCOLOR(@"ffffff") forState:UIControlStateNormal];
                     [strongSelf->m_Result setValue:[NSString stringWithFormat:@" %d",[strongSelf->m_Result[@"likeNumber"] intValue]+1]
                                             forKey:@"likeNumber"];
                 }
                 else
                 {
                     [likeBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
                     [likeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
                     [likeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
                     [strongSelf->m_Result setValue:[NSString stringWithFormat:@" %d",[strongSelf->m_Result[@"likeNumber"] intValue]-1]
                                             forKey:@"likeNumber"];
                 }
                 [strongSelf->m_Result setValue:[strongSelf->m_Result[@"likeStatus"] integerValue]==1?@"-1":@"1"
                                         forKey:@"likeStatus"];
                 [likeBtn setTitle:[NSString stringWithFormat:@" %d",[strongSelf->m_Result[@"likeNumber"] intValue]] forState:UIControlStateNormal];
             });
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

- (void)collectButtonEvent:(UIButton *)btn
{
    DIF_WeakSelf(self)
    [CommonHUD showHUDWithMessage:[m_Result[@"collectionStatus"] integerValue]==1?@"取消收藏":@"收藏"];
    [DIF_CommonHttpAdapter
     httpRequestPublicAddCollectWithTopicId:self.tradeId
     Status:[m_Result[@"collectionStatus"] integerValue]==1?@"-1":@"1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD delayShowHUDWithMessage:[strongSelf->m_Result[@"collectionStatus"] integerValue]==1?@"取消收藏成功":@"收藏成功"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [strongSelf->m_Result setValue:[strongSelf->m_Result[@"collectionStatus"] integerValue]==1?@"0":@"1"
                                         forKey:@"collectionStatus"];
                 [strongSelf.collectBtn setSelected:([m_Result[@"collectionStatus"] intValue]==1)];
             });
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

- (UIView *)createCommentView:(NSDictionary *)commentDic
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_RecommondView.width, DIF_PX(132))];
    [view setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(2), view.width, DIF_PX(130))];
    [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [view addSubview:backView];
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(5), DIF_PX(40), DIF_PX(40))];
    [iconImage.layer setMasksToBounds:YES];
    [iconImage.layer setCornerRadius:iconImage.height/2];
    [iconImage setImage:[UIImage imageNamed:@"normalUserIcon"]];
    [backView addSubview:iconImage];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right+DIF_PX(5), iconImage.top,
                                                                 m_RecommondView.width-iconImage.right-DIF_PX(12), DIF_PX(30))];
    [nameLab setFont:DIF_DIFONTOFSIZE(16)];
    [nameLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [nameLab setText:commentDic[@"createByName"]];
    [backView addSubview:nameLab];
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.left, nameLab.bottom+DIF_PX(5), nameLab.width, DIF_PX(20))];
    [dateLab setFont:DIF_DIFONTOFSIZE(12)];
    [dateLab setTextColor:DIF_HEXCOLOR(@"999999")];
    [dateLab setText:commentDic[@"createTime"]];
    [backView addSubview:dateLab];
    
    UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.left, dateLab.bottom+DIF_PX(5), backView.width-DIF_PX(12), DIF_PX(30))];
    [commentLab setFont:DIF_DIFONTOFSIZE(16)];
    [commentLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [commentLab setText:commentDic[@"content"]];
    CGFloat contentHegiht = [CommonTool getSpaceLabelHeight:commentLab.text withFont:commentLab.font withWidth:commentLab.width];
    if (contentHegiht > commentLab.height){
        [commentLab setHeight:contentHegiht];
    }
    [backView addSubview:commentLab];
    
    UIButton *reciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reciveBtn setFrame:CGRectMake(commentLab.left, commentLab.bottom+DIF_PX(8), DIF_PX(82), DIF_PX(30))];
    [reciveBtn setTitle:@"回复" forState:UIControlStateNormal];
    [reciveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [reciveBtn setTitleColor:DIF_HEXCOLOR(@"#FC7940") forState:UIControlStateNormal];
    [reciveBtn addTarget:self action:@selector(reciveButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:reciveBtn];
    return view;
}

- (void)reciveButtonEvent:(UIButton *)btn
{
    
}


- (void)loadContent
{
    [m_TitleLab setText:m_Result[@"title"]];
    CGFloat height = [CommonTool getSpaceLabelHeight:m_TitleLab.text withFont:m_TitleLab.font withWidth:m_TitleLab.width];
    if (height > m_TitleLab.height)
    {
        [m_TitleLab setHeight:height];
        [m_DateLab setTop:m_TitleLab.bottom+DIF_PX(16)];
        [m_ReadLab setTop:m_DateLab.bottom+DIF_PX(6)];
        [m_ContentLab setTop:m_ReadLab.bottom+DIF_PX(16)];
    }
    [m_DateLab setText:m_Result[@"categoryList"][0][@"updateTime"]];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[m_Result[@"readNumber"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"浏览"]
                   imageFrame:CGRectMake(0, 0, 20, 11)
                        Range:NSMakeRange(0, 0)];
    [m_ReadLab setAttributedText:placeholder];
    NSString *content = m_Result[@"content"];
    content = [content htmlEntityDecode];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:[content attributedStringWithHTMLString]];
    CGSize attSize = [attributeStr AttributedSizeWithBaseWidth:m_ContentLab.width];
    if (attSize.height > m_ContentLab.height)
        [m_ContentLab setHeight:attSize.height];
    [m_ContentLab setAttributedText:attributeStr];
    
    [m_BackView setContentSize:CGSizeMake(DIF_SCREEN_WIDTH, m_ContentLab.bottom+DIF_PX(50))];
    
    placeholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d",[m_Result[@"commentNumber"] intValue]]];
    [placeholder attatchImage:[UIImage imageNamed:@"消息"]
                   imageFrame:CGRectMake(0, -(self.sharedBtn.height-DIF_PX(20))/2, DIF_PX(20), DIF_PX(20))
                        Range:NSMakeRange(0, 0)];
    [self.commentNumLab setAttributedText:placeholder];
    [self.collectBtn setSelected:([m_Result[@"collectionStatus"] intValue]==1)];
    
    [self httRequestGetComment];
}

- (void)loadCommentData
{
    [m_RecommondView setHidden:NO];
    [m_RecommondView setTop:m_ContentLab.bottom+DIF_PX(6)];
    UIButton *likeBtn = [m_RecommondView viewWithTag:999];
    [likeBtn setTitle:[NSString stringWithFormat:@" %d",[m_Result[@"likeNumber"] intValue]] forState:UIControlStateNormal];
    if ([m_Result[@"likeStatus"] integerValue]==1)
    {
        [likeBtn setImage:[UIImage imageNamed:@"点赞(1)"] forState:UIControlStateNormal];
        [likeBtn setBackgroundColor:DIF_HEXCOLOR(@"ba1212")];
        [likeBtn setTitleColor:DIF_HEXCOLOR(@"ffffff") forState:UIControlStateNormal];
    }
    else
    {
        [likeBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
        [likeBtn setBackgroundColor:DIF_HEXCOLOR(@"")];
        [likeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
    }
    
    CGFloat top = likeBtn.bottom+DIF_PX(12);
    for (NSInteger i = 0; i < m_CommentList.count; i++)
    {
        NSDictionary *commentDic = m_CommentList[i];
//        NSDictionary *children = commentDic[@"children"];
        NSDictionary *comment = commentDic[@"comment"];
        UIView *commentView = [self createCommentView:comment];
        [commentView setTag:1000+i];
        [commentView setTop:top];
        [m_RecommondView addSubview:commentView];
        top = commentView.bottom+DIF_PX(5);
    }
    
    
    UIButton *moreBtn = [m_RecommondView viewWithTag:998];
    [moreBtn setTop:top];
    
    m_RecommondView.height += top;
    [m_BackView setContentSize:CGSizeMake(DIF_SCREEN_WIDTH, m_RecommondView.bottom+DIF_PX(50))];
}

#pragma mark - httpRequest

- (void)httpRequestGetDetail
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetPublicDetailWithTopicId:self.tradeId
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             strongSelf->m_Result = [NSMutableDictionary dictionaryWithDictionary:responseModel[@"data"]];
             [strongSelf performSelectorOnMainThread:@selector(loadContent) withObject:nil waitUntilDone:NO];
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

- (void)httRequestGetComment
{
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetPublicCommentWithTopicId:self.tradeId
     PageNo:@"1"
     PageSize:@"5"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             strongSelf->m_CommentList = responseModel[@"data"][@"list"];
             [strongSelf performSelectorOnMainThread:@selector(loadCommentData) withObject:nil waitUntilDone:NO];
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
