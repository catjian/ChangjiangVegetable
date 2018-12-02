//
//  VideoPlayerBaseView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/29.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "VideoPlayerBaseView.h"

@implementation VideoPlayerBaseView
{
    UIScrollView *m_ScrollView;
    UIView *m_NewsView;
    UITextView *m_TitelView;
    UITextView *m_DetailView;
    UILabel *m_DateLab;
    UIView *m_MoreView;
    UIButton *m_likeBtn;
    UIButton *m_collectBtn;
    UIButton *m_watchBtn;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_ScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:m_ScrollView];
        CGFloat bottomOffset = [self createVideoPlayerView];
        bottomOffset = [self createSharedViewWithBelowBottom:bottomOffset];
        bottomOffset = [self createNewsContentViewWithBelowBottom:bottomOffset];
        [m_ScrollView setContentSize:CGSizeMake(m_ScrollView.width, m_MoreView.bottom)];
    }
    return self;
}

- (void)setVideoDic:(NSDictionary *)videoDic
{
    _videoDic = videoDic;
    NSDictionary *video = videoDic[@"video"];
    NSString *videoPath = video[@"videoPath"];
    if (!videoPath)
        videoPath = videoDic[@"videoFirstFrameUrl"];
    [self.playerCon setContentURL:[NSURL URLWithString:videoPath]];
    [m_TitelView setText:video[@"title"]];
    NSString * content = [video[@"content"] htmlEntityDecode];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:[content attributedStringWithHTMLString]];
    [m_DetailView setAttributedText:attributeStr];
    [m_DateLab setText:video[@"createTime"]];
    [m_likeBtn setSelected:([video[@"likeFlag"] integerValue]==1)];
    [m_collectBtn setSelected:([video[@"collectFlag"] integerValue]==1)];
    [m_likeBtn setTitle:[@([video[@"likeNum"] intValue]) stringValue] forState:UIControlStateNormal];
    [m_watchBtn setTitle:[@([video[@"watchNum"] intValue]) stringValue] forState:UIControlStateNormal];
}

- (void)setVideoList:(NSArray *)videoList
{
    _videoList = videoList;
    [self createMoreViewWithBelowBottom:m_NewsView.bottom];
    [m_ScrollView setContentSize:CGSizeMake(m_ScrollView.width, m_MoreView.bottom+50)];
}

- (CGFloat)createVideoPlayerView
{
    self.playerCon = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, DIF_PX_Scale(375), DIF_PX_Scale(170))];
//    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
//    [self.playerCon setContentURL:videoURL];
    [m_ScrollView addSubview:self.playerCon.view];
    [self.playerCon stop];
    return self.playerCon.view.bottom;
}

- (CGFloat)createSharedViewWithBelowBottom:(CGFloat)bottom
{
    UIView *sharedViews = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, DIF_SCREEN_WIDTH, DIF_PX(38))];
    [sharedViews setBackgroundColor:DIF_HEXCOLOR(@"f1f1f1")];
    [m_ScrollView addSubview:sharedViews];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setFrame:CGRectMake(DIF_PX(6), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [downBtn setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [sharedViews addSubview:downBtn];
    
    m_collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_collectBtn setFrame:CGRectMake(downBtn.right+DIF_PX(6), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [m_collectBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [m_collectBtn setImage:[UIImage imageNamed:@"收藏2"] forState:UIControlStateSelected];
    [m_collectBtn addTarget:self action:@selector(collectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [sharedViews addSubview:m_collectBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(m_collectBtn.right+DIF_PX(6), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [sharedViews addSubview:shareBtn];
    
    m_watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_watchBtn setFrame:CGRectMake(0, DIF_PX(4), DIF_PX(70), DIF_PX(30))];
    [m_watchBtn setRight:sharedViews.width-DIF_PX(6)];
    [m_watchBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [m_watchBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
    [m_watchBtn.titleLabel setFont:DIF_DIFONTOFSIZE(14)];
    [m_watchBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:4];
    [m_watchBtn addTarget:self action:@selector(gotoAllCommentView) forControlEvents:UIControlEventTouchUpInside];
    [sharedViews addSubview:m_watchBtn];
    
    m_likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_likeBtn setFrame:CGRectMake(0, DIF_PX(4), DIF_PX(70), DIF_PX(30))];
    [m_likeBtn setRight:m_watchBtn.left-DIF_PX(6)];
    [m_likeBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
    [m_likeBtn setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateSelected];
    [m_likeBtn.titleLabel setFont:DIF_DIFONTOFSIZE(14)];
    [m_likeBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
    [m_likeBtn setTitleColor:DIF_HEXCOLOR(@"ba1212") forState:UIControlStateSelected];
    [m_likeBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:4];
    [m_likeBtn addTarget:self action:@selector(likeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [sharedViews addSubview:m_likeBtn];
    
    return sharedViews.bottom;
}

- (CGFloat)createNewsContentViewWithBelowBottom:(CGFloat)bottom
{
    m_NewsView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, DIF_SCREEN_WIDTH, DIF_PX(270))];
    [m_NewsView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [m_ScrollView addSubview:m_NewsView];
    
    m_TitelView = [[UITextView alloc] initWithFrame:CGRectMake(DIF_PX(12), DIF_PX(16), DIF_SCREEN_WIDTH-DIF_PX(24), DIF_PX(58))];
    [m_TitelView setEditable:NO];
    [m_TitelView setTintColor:DIF_HEXCOLOR(@"333333")];
    [m_TitelView setFont:DIF_DIFONTOFSIZE(18)];
//    [m_TitelView setText:@"农村种植露地辣椒，这位农民的高产方法，值得学习发展。"];
    [m_NewsView addSubview:m_TitelView];
    
    m_DetailView = [[UITextView alloc] initWithFrame:CGRectMake(m_TitelView.left, m_TitelView.bottom+DIF_PX(8), m_TitelView.width, DIF_PX(83))];
    [m_DetailView setEditable:NO];
    [m_DetailView setTintColor:DIF_HEXCOLOR(@"666666")];
    [m_DetailView setFont:DIF_DIFONTOFSIZE(14)];
    [m_DetailView setText:@""];
    [m_NewsView addSubview:m_DetailView];
    
    m_DateLab = [[UILabel alloc] initWithFrame:CGRectMake(m_DetailView.left, m_DetailView.bottom+DIF_PX(12), m_DetailView.width, DIF_PX(20))];
    [m_DateLab setTintColor:DIF_HEXCOLOR(@"999999")];
    [m_DateLab setFont:DIF_DIFONTOFSIZE(12)];
//    [m_DateLab setText:@"2018年9月12日"];
    [m_NewsView addSubview:m_DateLab];
    return m_NewsView.bottom;
}

- (void)createMoreViewWithBelowBottom:(CGFloat)bottom
{
    m_MoreView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, DIF_SCREEN_WIDTH, DIF_PX(220))];
    [m_MoreView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [m_ScrollView addSubview:m_MoreView];
    
    NSArray *banner = self.videoDic[@"banner"][@"banner1"];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(80))];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:banner.firstObject]];
    [m_MoreView addSubview:headerImageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(14), headerImageView.bottom+DIF_PX(10), m_MoreView.width-DIF_PX(14*2), DIF_PX(48))];
    [title setText:@"相关视频"];
    [title setFont:DIF_UIFONTOFSIZE(18)];
    [title setTextColor:DIF_HEXCOLOR(@"666666")];
    [m_MoreView addSubview:title];
    
    UIScrollView *moreVideos = [[UIScrollView alloc] initWithFrame:CGRectMake(0, title.bottom, m_MoreView.width, DIF_PX(80))];
    [moreVideos setShowsVerticalScrollIndicator:NO];
    [moreVideos setShowsHorizontalScrollIndicator:NO];
    [moreVideos setPagingEnabled:NO];
    [m_MoreView addSubview:moreVideos];
    
    for (int i = 0; i < self.videoList.count; i++)
    {
        NSDictionary *dic = self.videoList[i];
        UIView *videoView = [self createMoreVideoViewWithURLString:dic[@"videoFirstFrameUrl"]
                                                          TitleStr:dic[@"title"] index:i];
        [videoView setLeft:i*DIF_PX(112)];
        [moreVideos addSubview:videoView];
    }
    [moreVideos setContentSize:CGSizeMake(DIF_PX(112*10), DIF_PX(80))];
}

- (UIView *)createMoreVideoViewWithURLString:(NSString *)urlString TitleStr:(NSString *)titleStr index:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(112), DIF_PX(80))];
    [view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(102), DIF_PX(58))];
    [imageView.layer setCornerRadius:5];
    [imageView.layer setMasksToBounds:YES];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
//    dispatch_async(dispatch_queue_create("com.getVideoPreViewImage.queue", NULL), ^{
//        UIImage *image = [CommonTool getVideoPreViewImage:urlString];
//        while (1)
//        {
//            if (image)
//                break;
//            sleep(1);
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [imageView setImage:image];
//        });
//    });
    [view addSubview:imageView];
    
    UIImageView *playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_PX(30), DIF_PX(30))];
    [playView setCenterX:imageView.width/2];
    [playView setCenterY:imageView.height/2];
    [playView setImage:[UIImage imageNamed:@"播放"]];
    [imageView addSubview:playView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom+DIF_PX(6), imageView.width, DIF_PX(16))];
    [titleLab setTextColor:DIF_HEXCOLOR(@"#666666")];
    [titleLab setFont:DIF_DIFONTOFSIZE(14)];
    [titleLab setText:titleStr];
    [view addSubview:titleLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:imageView.frame];
    [btn setTag:9990+index];
    [btn addTarget:self action:@selector(moreVideoButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

- (void)moreVideoButtonEvent:(UIButton *)btn
{
    if(self.moreBlock)
    {
        self.moreBlock(btn.tag-9990);
    }
}

- (void)likeButtonEvent:(UIButton *)btn
{
    NSDictionary *video = self.videoDic[@"video"];
    DIF_WeakSelf(self)
    [CommonHUD showHUDWithMessage:m_likeBtn.selected?@"取消点赞":@"点赞"];
    [DIF_CommonHttpAdapter
     httpRequestGetPublicLikeWithTopicId:video[@"id"]?video[@"id"]:video[@"videoId"]
     Status:[video[@"collectFlag"] integerValue]==1?@"-1":@"1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD delayShowHUDWithMessage:strongSelf->m_likeBtn.selected?@"取消点赞成功":@"点赞成功"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 strongSelf->m_likeBtn.selected = !strongSelf->m_likeBtn.selected;
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
    NSDictionary *video = self.videoDic[@"video"];
    DIF_WeakSelf(self)
    [CommonHUD showHUDWithMessage:m_collectBtn.selected?@"取消收藏":@"收藏"];
    [DIF_CommonHttpAdapter
     httpRequestPublicAddCollectWithTopicId:video[@"id"]?video[@"id"]:video[@"videoId"]
     Status:m_collectBtn.selected?@"-1":@"1"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD delayShowHUDWithMessage:strongSelf->m_collectBtn.selected?@"取消收藏成功":@"收藏成功"];
             dispatch_async(dispatch_get_main_queue(), ^{
                 strongSelf->m_collectBtn.selected = !strongSelf->m_collectBtn.selected;
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

- (void)gotoAllCommentView
{
    if(self.moreBlock)
    {
        self.moreBlock(-2);
    }
}

@end
