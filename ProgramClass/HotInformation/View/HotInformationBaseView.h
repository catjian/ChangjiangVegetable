//
//  HotInformationBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HotInformationBaseViewSelectChannelBlock)(void);

@interface HotInformationBaseView : UIView

@property (nonatomic, copy) HotInformationBaseViewSelectChannelBlock selectChannelBlock;

@end

NS_ASSUME_NONNULL_END
