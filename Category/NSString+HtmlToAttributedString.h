//
//  NSString+HtmlToAttributedString.h
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/28.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NSString_HtmlToAttributedString)

- (NSString *)htmlEntityDecode;

- (NSAttributedString *)attributedStringWithHTMLString;

- (NSString *)filterHTML;

@end

NS_ASSUME_NONNULL_END
