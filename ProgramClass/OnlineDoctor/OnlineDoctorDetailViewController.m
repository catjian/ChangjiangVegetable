//
//  OnlineDoctorDetailViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/22.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "OnlineDoctorDetailViewController.h"

@interface OnlineDoctorDetailViewController() <UIScrollViewDelegate, UITextViewDelegate>

@end

@implementation OnlineDoctorDetailViewController
{
    UITextView *m_TextView;
    UIImageView *m_ImageView;
    NSDictionary *m_Detail;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    m_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, DIF_PX(20), DIF_PX(165), DIF_PX(214))];
    [m_ImageView setRight:DIF_SCREEN_WIDTH-DIF_PX(14)];
    [self.view addSubview:m_ImageView];
    
    m_TextView = [[UITextView alloc] initWithFrame:CGRectMake(DIF_PX(14), DIF_PX(10), DIF_SCREEN_WIDTH-DIF_PX(28), self.view.height)];
    m_TextView.editable = NO;
    m_TextView.delegate = self;
    [m_TextView setFont:DIF_DIFONTOFSIZE(16)];
    [m_TextView setTextColor:DIF_HEXCOLOR(@"333333")];
    [self.view insertSubview:m_TextView belowSubview:m_ImageView];
    
    m_TextView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
    [m_ImageView sd_setImageWithURL:[NSURL URLWithString:m_Detail[@"doctorPortraitUrl"]]];
    [m_TextView setText:m_Detail[@"doctorName"]];
}

- (UIBezierPath *)translatedBezierPath
{
    //坐标转换，原先imageView默认是以self.view作为参考系，现在要设置textView的环绕，所以将参考坐标系换成textView
    CGRect imageRect = [m_TextView convertRect:m_ImageView.frame fromView:self.view];
    //将UIBezierPath设置为图片frame
    UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:imageRect];
    return newPath;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    m_ImageView.frame = CGRectMake(m_ImageView.frame.origin.x,
                                   DIF_PX(20)-scrollView.contentOffset.y,
                                   m_ImageView.frame.size.width ,
                                   m_ImageView.frame.size.height);
}

- (void)loadDoctorDetail:(NSDictionary *)detail
{
    m_Detail = detail;
    [self setNavTarBarTitle:detail[@"doctorName"]];
}

@end
