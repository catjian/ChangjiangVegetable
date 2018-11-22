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
    NSString *videoPath = videoDic[@"videoPath"];
    if (!videoPath)
        videoPath = videoDic[@"videoFirstFrameUrl"];
    [self.playerCon setContentURL:[NSURL URLWithString:videoPath]];
    [m_TitelView setText:videoDic[@"title"]];
    [m_DetailView setText:videoDic[@"title"]];
    [m_DateLab setText:videoDic[@"updateTime"]];
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
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    [self.playerCon setContentURL:videoURL];
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
    [downBtn setFrame:CGRectMake(DIF_PX(12), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [downBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
    [sharedViews addSubview:downBtn];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setFrame:CGRectMake(downBtn.right+DIF_PX(12), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [likeBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [sharedViews addSubview:likeBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(likeBtn.right+DIF_PX(12), DIF_PX(4), DIF_PX(30), DIF_PX(30))];
    [shareBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
    [sharedViews addSubview:shareBtn];
    
    UIButton *commonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commonBtn setFrame:CGRectMake(0, DIF_PX(4), DIF_PX(70), DIF_PX(30))];
    [commonBtn setRight:sharedViews.width-DIF_PX(8)];
    [commonBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
    [commonBtn setTitle:@"999" forState:UIControlStateNormal];
    [commonBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
    [commonBtn.titleLabel setFont:DIF_DIFONTOFSIZE(14)];
    [commonBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:4];
    [sharedViews addSubview:commonBtn];
    
    UIButton *giveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, DIF_PX(4), DIF_PX(70), DIF_PX(30))];
    [shareBtn setRight:commonBtn.left-DIF_PX(8)];
    [giveBtn setImage:[UIImage imageNamed:@"点赞3"] forState:UIControlStateNormal];
    [giveBtn setTitle:@"888" forState:UIControlStateNormal];
    [commonBtn.titleLabel setFont:DIF_DIFONTOFSIZE(14)];
    [giveBtn setTitleColor:DIF_HEXCOLOR(@"999999") forState:UIControlStateNormal];
    [giveBtn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleLeft padding:4];
    [sharedViews addSubview:giveBtn];
    
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
    [m_TitelView setText:@"农村种植露地辣椒，这位农民的高产方法，值得学习发展。"];
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
    [m_DateLab setText:@"2018年9月12日"];
    [m_NewsView addSubview:m_DateLab];
    return m_NewsView.bottom;
}

- (void)createMoreViewWithBelowBottom:(CGFloat)bottom
{
    m_MoreView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, DIF_SCREEN_WIDTH, DIF_PX(220))];
    [m_MoreView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [m_ScrollView addSubview:m_MoreView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(80))];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://free.modao.cc/uploads3/images/2499/24991066/raw_1536658218.jpeg"]];
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
        UIView *videoView = [self createMoreVideoViewWithURLString:dic[@"image"]
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
    dispatch_async(dispatch_queue_create("com.getVideoPreViewImage.queue", NULL), ^{
        UIImage *image = [CommonTool getVideoPreViewImage:urlString];
        while (1)
        {
            if (image)
                break;
            sleep(1);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:image];
        });
    });
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

@end
