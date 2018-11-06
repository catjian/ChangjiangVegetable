//
//  SubscribeViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubscribeViewCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *readNumLab;

@end

NS_ASSUME_NONNULL_END
