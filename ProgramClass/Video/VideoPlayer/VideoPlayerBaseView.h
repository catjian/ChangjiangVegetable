//
//  VideoPlayerBaseView.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/29.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VideoPlayerBaseViewSelectMoreViewBlock)(NSInteger tag);

@interface VideoPlayerBaseView : UIView

@property (nonatomic, copy) VideoPlayerBaseViewSelectMoreViewBlock moreBlock;
@property (nonatomic, strong) NSDictionary *videoDic;
@property (nonatomic, strong) NSArray *videoList;
@property(nonatomic, strong) KRVideoPlayerController *playerCon;
@end

NS_ASSUME_NONNULL_END
