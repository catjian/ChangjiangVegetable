//
//  VideoListBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/20.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListBaseView : UIView 

@property (nonatomic, copy) tableViewSelectRowAtIndexPathBlock selectBlock;
@property (nonatomic, strong) NSDictionary *allDataDic;

@end
