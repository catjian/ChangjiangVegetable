//
//  ShopTypeListViewController.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ShopTypeListViewController_HttpType) {
    ShopTypeListViewController_HttpType_Goodscount = 0,
    ShopTypeListViewController_HttpType_Order = 7,     
};

NS_ASSUME_NONNULL_BEGIN

@interface ShopTypeListViewController : BaseViewController

@property (nonatomic) ShopTypeListViewController_HttpType httpType;

@end

NS_ASSUME_NONNULL_END
