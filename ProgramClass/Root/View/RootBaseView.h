//
//  RootBaseView.h
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/10.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewCell.h"
#import "RootViewHotCell.h"
#import "RooViewNewsCell.h"
#import "RootViewLoanCell.h"
#import "RootOnlyPictureCell.h"
#import "RootVideoViewCell.h"

typedef void(^RootBaseViewHeaderMoreSelectBlock)(NSInteger);
@interface RootBaseView : UIView

@property (nonatomic, copy) tableViewSelectRowAtIndexPathBlock selectBlock;
@property (nonatomic, copy) RootBaseViewHeaderMoreSelectBlock headerBlock;

@property (nonatomic, strong) NSDictionary *allDataDic;

@end
