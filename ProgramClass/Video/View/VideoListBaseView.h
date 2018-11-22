//
//  VideoListBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/20.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoListBaseViewSelectChannelBlock)(void);

@interface VideoListBaseView : UIView 

@property (nonatomic, copy) CommonPageControlViewSelectBlock pageSelectBlock;
@property (nonatomic, copy) VideoListBaseViewSelectChannelBlock selectChannelBlock;
@property (nonatomic, copy) tableViewSelectRowAtIndexPathBlock selectBlock;
@property (nonatomic, strong) NSDictionary *allDataDic;
@property (nonatomic, strong) NSArray *channelArray;

@end
