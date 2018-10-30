//
//  SelectChannelViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/27.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "SelectChannelViewController.h"
#import "SelectChannelBaseView.h"

@interface SelectChannelViewController ()

@end

@implementation SelectChannelViewController
{
    SelectChannelBaseView *m_BaseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_BaseView)
    {
        m_BaseView = [[SelectChannelBaseView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setBlock:^(NSArray *selectIndex) {
            DIF_StrongSelf
        }];
    }
    m_BaseView.channelData = self.channelData;
}

- (void)setChannelData:(NSDictionary *)channelData
{
    _channelData = channelData;
    m_BaseView.channelData = channelData;
}

@end
