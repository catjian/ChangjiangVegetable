//
//  HtmlContentViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/22.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "HtmlContentViewController.h"

@interface HtmlContentViewController ()

@end

@implementation HtmlContentViewController
{
    UIScrollView *m_BackView;
    UILabel *m_TitleLab;
    UILabel *m_DateLab;
    UILabel *m_ReadLab;
    UILabel *m_ContentLab;
    NSDictionary *m_Result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTarBarTitle:@"文章详情"];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    m_BackView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
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
    [m_ReadLab setFont:DIF_DIFONTOFSIZE(14)];
    [m_ReadLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [m_BackView addSubview:m_ReadLab];
    
    m_ContentLab =  [[UILabel alloc] initWithFrame:CGRectMake(DIF_PX(6), m_ReadLab.bottom+DIF_PX(16), DIF_SCREEN_WIDTH-DIF_PX(12), DIF_PX(30))];
    [m_ContentLab setLineBreakMode:NSLineBreakByCharWrapping];
    [m_ContentLab setNumberOfLines:0];
    [m_ContentLab setFont:DIF_DIFONTOFSIZE(14)];
    [m_ContentLab setTextColor:DIF_HEXCOLOR(@"666666")];
    [m_BackView addSubview:m_ContentLab];
    
    [self httpRequestGetDetail];
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
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
    [m_DateLab setText:m_Result[@"createTime"]];
    [m_ReadLab setText:[NSString stringWithFormat:@"阅读%@",m_Result[@"readNumber"]]];
    NSString *content = m_Result[@"content"];
    content = [self htmlEntityDecode:content];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringWithHTMLString:content]];
    CGSize attSize = [attributeStr AttributedSizeWithBaseWidth:m_ContentLab.width];
    if (attSize.height > m_ContentLab.height)
        [m_ContentLab setHeight:attSize.height];
    [m_ContentLab setAttributedText:attributeStr];
    [m_BackView setContentSize:CGSizeMake(DIF_SCREEN_WIDTH, m_ContentLab.bottom)];
}

#pragma mark - httpRequest

- (void)httpRequestGetDetail
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetTradeInfoDetailWithTopicId:self.tradeId
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             strongSelf->m_Result = responseModel[@"data"];
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

@end
