//
//  MyOrderViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderViewCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *singleMoneyLab;
@property (nonatomic, strong) UILabel *allMoneyLab;

@end

NS_ASSUME_NONNULL_END
