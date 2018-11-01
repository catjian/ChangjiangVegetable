//
//  ShopCartBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/2.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartBaseView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *dataArr;
@property (nonatomic) CGFloat allMoneyNum;

@end

NS_ASSUME_NONNULL_END
