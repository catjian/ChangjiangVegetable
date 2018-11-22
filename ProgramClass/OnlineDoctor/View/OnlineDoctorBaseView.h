//
//  OnlineDoctorBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OnlineDoctorBaseViewSelectDoctorBlock)(NSInteger index);

@interface OnlineDoctorBaseView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy, readwrite) tableViewHeaderRefreshBlock refreshBlock;
@property (nonatomic, copy, readwrite) tableViewLoadMoreBlock loadMoreBlock;
@property (nonatomic, copy, readwrite) OnlineDoctorBaseViewSelectDoctorBlock selectDoctorBlock;
@property (nonatomic, strong) NSDictionary *doctorDic;
@property (nonatomic, strong) NSArray *articleList;

- (void)createCollectionView;
- (void)endRefresh;

@end

NS_ASSUME_NONNULL_END
