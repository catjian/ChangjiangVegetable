//
//  ShopCartViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/2.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShopCartViewCellSelectBlock)(BOOL isSelected);
typedef void(^ShopCartViewCellEditCountBlock)(NSInteger count, CGFloat money);

@interface ShopCartViewCell : BaseTableViewCell

@property (nonatomic, copy) ShopCartViewCellSelectBlock selectBlock;
@property (nonatomic, copy) ShopCartViewCellEditCountBlock countBlock;


@end

NS_ASSUME_NONNULL_END
