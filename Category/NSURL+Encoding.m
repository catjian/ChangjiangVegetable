//
//  NSURL+Encoding.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/21.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "NSURL+Encoding.h"

@implementation NSURL(NSURL_Encoding)

+ (nullable instancetype)URLWithString:(NSString *)URLString
{
    NSString *urlString = URLString?URLString:@"";
    urlString=[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    return [[NSURL alloc] initWithString:urlString];
}
@end
