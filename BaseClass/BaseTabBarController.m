//
//  BaseTabBarController.m
//  uavsystem
//
//  Created by zhang_jian on 16/7/4.
//  Copyright © 2018年 . All rights reserved.
//

#import "BaseTabBarController.h"

const NSString *TabBarShow_Animation_Key = @"position_show";
const NSString *TabBarHide_Animation_Key = @"position_hide";

const CGFloat tabbar_Hegith = 50;

@interface BaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation BaseTabBarController
{
    UIView *m_BaseView;
    UIButton *m_SelectBtn;
    BOOL m_IsHidden;
    NSDate *m_oldDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedIndex"];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self)
    {
        m_IsHidden = NO;
        m_oldDate = [NSDate date];
        self.viewControllers = [viewControllers mutableCopy];
        
        m_BaseView = [[UIView alloc] initWithFrame:[self BaseViewFrame]];
        [m_BaseView setBackgroundColor:[UIColor colorWithPatternImage:DIF_IMAGE_HEXCOLOR(@"#ffffff")]];
        [self.view addSubview:m_BaseView];
        
        UIView *headerLine = [UIView new];
        headerLine.sd_layout.topSpaceToView(m_BaseView,0).heightIs(1).widthIs(m_BaseView.width);
        [headerLine setBackgroundColor:[UIColor colorWithPatternImage:DIF_IMAGE_HEXCOLOR(@"#e8e8e8")]];
        [m_BaseView addSubview:headerLine];
        [self initViewContent];
        
//        [self setDelegate:self];
        
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
        
        [self setSelectedIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (CGFloat)getTabBarHeight
{
    return tabbar_Hegith;
}

- (BOOL)isHidden
{
    return m_IsHidden;
}

- (CGRect)BaseViewFrame
{
    [self hideTabBar];
    CGRect frame = self.tabBar.frame;
    
    CGFloat offset_Height = tabbar_Hegith+(is_iPHONE_X?34:0);
    frame.origin.y -= offset_Height;
    frame.size.height = offset_Height;
    return frame;
}

- (void)initViewContent
{
    for (NSUInteger idx = 0; idx < self.viewControllers.count; idx++)
    {
        [self createButtonWithIndex:idx];
    }
}

- (void)createButtonWithIndex:(NSInteger)idx
{
    __block NSArray *btnImages = @[@"首页",@"视频",@"商城",@"网展",@"我的"];
    CGFloat offset_Width = m_BaseView.width/self.viewControllers.count;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(idx*(offset_Width+0), 0, offset_Width, tabbar_Hegith)];
    [btn setTag:idx+100];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-选中",btnImages[idx]]]
         forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-选中",btnImages[idx]]]
         forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-未选中",btnImages[idx]]] forState:UIControlStateNormal];
    [btn setSelected:NO];
    [btn addTarget:self action:@selector(SelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:btnImages[idx] forState:UIControlStateNormal];
    [btn.titleLabel setFont:DIF_DIFONTOFSIZE(11)];
    [btn setTitleColor:[CommonTool colorWithHexString:@"#A9A9A9" Alpha:1] forState:UIControlStateNormal];
    [btn setTitleColor:[CommonTool colorWithHexString:@"#2D7AFF" Alpha:1] forState:UIControlStateHighlighted];
    [btn setTitleColor:[CommonTool colorWithHexString:@"#2D7AFF" Alpha:1] forState:UIControlStateSelected];
    [btn setButtonImageTitleStyle:ENUM_ButtonImageTitleStyleTop padding:3];
    [m_BaseView addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    NSLog(@"touchPoint.y = %f", touchPoint.y);
}

- (void)SelectButtonAction:(UIButton *)btn
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timeSpace = nowDate.timeIntervalSince1970 - m_oldDate.timeIntervalSince1970;
    m_oldDate = [NSDate date];
    NSLog(@"timeSpace = %f", timeSpace);
    if (timeSpace > 0.05)
    {
        self.selectedIndex = btn.tag-100;
        if (self.selectedIndex == 0)
        {
            BaseNavigationViewController *nv1 = self.viewControllers[0];
            [nv1 popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedIndex"])
    {
        [self hideTabBar];
        NSInteger newIndex = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        for (int i = 0; i < self.viewControllers.count; i++)
        {
            UIButton *btn = (UIButton *)[m_BaseView viewWithTag:100+i];
            [btn setSelected:NO];
            if (i == newIndex)
            {
                [btn setSelected:YES];
                m_SelectBtn = btn;
                [self setSelectedViewController:self.viewControllers[i]];
            }
        }
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self hideTabBar];
}

- (void)showTabBarViewControllerIsAnimation:(BOOL)isAnimation
{
    [self hideTabBar];
    if (!m_BaseView.hidden)
    {
        return;
    }
    m_IsHidden = NO;
    [m_BaseView setHidden:NO];
    DIF_WeakSelf(self)
    [UIView animateWithDuration:(isAnimation?0.5:0) animations:^{
        DIF_StrongSelf
        [strongSelf->m_BaseView setAlpha:1];
    } completion:^(BOOL finished) {
        DIF_StrongSelf
        for (int i = 0; i < self.viewControllers.count; i++)
        {
            UIButton *btn = (UIButton *)[strongSelf->m_BaseView viewWithTag:100+i];
            [btn setEnabled:YES];
        }
    }];
}

- (void)hideTabBarViewControllerIsAnimation:(BOOL)isAnimation
{
    [self hideTabBar];
    m_IsHidden = YES;
    for (int i = 0; i < self.viewControllers.count; i++)
    {
        UIButton *btn = (UIButton *)[m_BaseView viewWithTag:100+i];
        [btn setEnabled:NO];
    }
    
    DIF_WeakSelf(self)
    [UIView animateWithDuration:(isAnimation?0.2:0) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut   animations:^{
        DIF_StrongSelf
        [strongSelf->m_BaseView setAlpha:0];
    } completion:^(BOOL finished) {
        DIF_StrongSelf
        [strongSelf->m_BaseView setHidden:YES];
    }];
    
}

- (void)hideTabBar
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
        }
        else
        {
            if([view isKindOfClass:NSClassFromString(@"UITransitionView")])
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
            }
        }
    }
    [self.tabBar setHidden:YES];
}

#pragma mark - Show Badge

- (void)showBadgeNumberOnItemIndex:(int)index Number:(NSInteger)number
{
    [self removeBadgeNumberOnItemIndex:index];
    UIButton *btn = (UIButton *)[m_BaseView viewWithTag:100+index];
    //新建小红点
    UILabel *bview = [[UILabel alloc]init];
    bview.tag = 888+index;
    bview.layer.cornerRadius = 5;
    bview.clipsToBounds = YES;
    bview.backgroundColor = DIF_HEXCOLOR(@"ff0000");
    [bview setText:[@(number) stringValue]];
    [bview setFont:DIF_UIFONTOFSIZE(8)];
    [bview setTextColor:DIF_HEXCOLOR(@"ffffff")];
    [bview setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat width = 10 + 5*(bview.text.length-1);
    CGRect imageFrame = btn.imageView.frame;
    bview.frame = CGRectMake(imageFrame.origin.x+imageFrame.size.width, imageFrame.origin.y, width, 10);
    [btn addSubview:bview];
    [btn bringSubviewToFront:bview];
}

//隐藏红点
-(void)hideBadgeNumberOnItemIndex:(int)index
{
    [self removeBadgeNumberOnItemIndex:index];
}

//移除控件
- (void)removeBadgeNumberOnItemIndex:(int)index
{
    UIButton *btn = (UIButton *)[m_BaseView viewWithTag:100+index];
    for (UIView*subView in btn.subviews) {
        if (subView.tag == 888+index)
        {
            [subView removeFromSuperview];
        }
    }
}

@end