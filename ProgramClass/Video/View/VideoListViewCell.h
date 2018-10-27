//
//  VideoListViewCell.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/23.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIButton *zanBtn;

@end

NS_ASSUME_NONNULL_END
