//
//  WebShopBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/21.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebShopBaseView : UIView

@property (nonatomic, copy) tableViewSelectRowAtIndexPathBlock selectBlock;
@property (nonatomic, strong) NSDictionary *allDataDic;

@end

NS_ASSUME_NONNULL_END
