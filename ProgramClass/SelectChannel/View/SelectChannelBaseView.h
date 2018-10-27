//
//  SelectChannelBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/27.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectChannelBaseViewViewBlock)(NSArray *);

@interface SelectChannelBaseView : UIView

@property (nonatomic, copy) SelectChannelBaseViewViewBlock block;
@property (nonatomic, strong) NSDictionary *channelData;
@property (nonatomic, copy) NSString *ageStr;

@end


NS_ASSUME_NONNULL_END
