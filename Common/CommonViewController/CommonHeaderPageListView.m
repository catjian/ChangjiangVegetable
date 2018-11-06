//
//  CommonHeaderPageListView.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/5.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "CommonHeaderPageListView.h"

@implementation CommonHeaderPageListView
{
    BaseTableView *m_ContentView;
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
    CommonPageControlView *pageView = [[CommonPageControlView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(40))
                                                                            titles:titles
                                                                          oneWidth:self.oneWidth];
    [self addSubview:pageView];
    DIF_WeakSelf(self)
    [pageView setSelectBlock:^(NSInteger page) {
        DIF_StrongSelf
    }];
    
    [self createCollectionView];
}

- (void)createCollectionView
{
    m_ContentView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, DIF_PX(40), self.width, self.height) style:UITableViewStylePlain];
    [m_ContentView setDelegate:self];
    [m_ContentView setDataSource:self];
    [m_ContentView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:m_ContentView];
}

@end
