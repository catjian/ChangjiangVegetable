//
//  IMInpuerView.h
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/29.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMInpuerViewSizeChangeBlock)(void);
typedef void(^IMInpuerViewSendEventBlock)(NSString * message);
typedef void(^IMInpuerViewEditBlock)(BOOL, NSNotification*);

@interface IMInpuerView : UIView

@property (nonatomic, copy) IMInpuerViewSizeChangeBlock changeBlock;
@property (nonatomic, copy) IMInpuerViewSendEventBlock sendBlock;
@property (nonatomic, copy) IMInpuerViewEditBlock editBlock;
@property (nonatomic, copy) NSString *placeholderString;

- (void)HideSendButton:(BOOL)isHidden;
- (void)setInputWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
