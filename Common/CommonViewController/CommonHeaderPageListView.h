//
//  CommonHeaderPageListView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/5.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonHeaderPageListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) CGFloat oneWidth;
@property (nonatomic, strong) NSDictionary *allDataDic;
@property (nonatomic, strong) NSArray *channelArray;

@end

NS_ASSUME_NONNULL_END
