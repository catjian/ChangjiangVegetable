//
//  ShopInformationViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopInformationViewCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *readNumLab;
@property (nonatomic, strong) UILabel *commentNumLab;
@property (nonatomic, strong) UILabel *zanNumLab;

@end

NS_ASSUME_NONNULL_END
