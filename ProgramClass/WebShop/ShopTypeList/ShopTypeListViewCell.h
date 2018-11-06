//
//  ShopTypeListViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopTypeListViewCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *singleMoneyLab;
@property (nonatomic, strong) UILabel *addressLab;

@end

NS_ASSUME_NONNULL_END
