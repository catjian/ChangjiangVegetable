//
//  OnlineDoctorBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/7.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnlineDoctorBaseView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *doctorDic;
@property (nonatomic, strong) NSArray *articleList;

@end

NS_ASSUME_NONNULL_END
