//
//  NSString+HtmlToAttributedString.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/28.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "NSString+HtmlToAttributedString.h"

@implementation NSString (NSString_HtmlToAttributedString)

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode
{
    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString
{
//    NSString *htmlString = [self filterHTML];
    NSString *htmlString = self;
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

//去掉 HTML 字符串中的标签
- (NSString *)filterHTML
{
    NSString *html = self;
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

- (NSString *)utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {    
        if ([[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"<"] ||
            [[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@">"] ||
            [[string substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="])
        {
            NSMutableString *s = [NSMutableString stringWithCapacity:0];
            // 中文和字符
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
            [str appendFormat:@"%@", s];
        }
        else
        {
            [str appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return str;
    
}

@end
