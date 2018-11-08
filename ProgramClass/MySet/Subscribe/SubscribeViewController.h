//
//  SubscribeViewController.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SubscribeViewControllerType) {
    SubscribeViewControllerType_Collection,
    SubscribeViewControllerType_History,
};

@interface SubscribeViewController : BaseViewController

@property (nonatomic) SubscribeViewControllerType conType;

@end

NS_ASSUME_NONNULL_END
