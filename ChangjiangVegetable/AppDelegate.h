//
//  AppDelegate.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/19.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIMManagerObject.h"

#define DIF_Login_Status @"DIF_Login_Status"
#define DIF_Loaction_Save_UserId @"DIF_Loaction_Save_UserId"
#define DIF_Loaction_Save_Password @"DIF_Loaction_Save_Password"

typedef NS_ENUM(NSUInteger, ENUM_MyOrder_Status) {
    ENUM_MyOrder_Status_WaitPay = 11,
    ENUM_MyOrder_Status_WaitConfirm = 13,
    ENUM_MyOrder_Status_Finish = 15
};

typedef NS_ENUM(NSUInteger, ENUM_MyOrder_Car_Status) {
    ENUM_MyOrder_Car_Status_HadMoney = 11,
    ENUM_MyOrder_Car_Status_WaitPay = 12,
    ENUM_MyOrder_Car_Status_WaitReview = 13,
    ENUM_MyOrder_Car_Status_Finish = 15
};

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,AMapLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BaseTabBarController *baseTB;
@property (nonatomic, strong) NSDictionary *imUserSig;
@property (nonatomic, strong) NSDictionary *mybrokeramount;

+ (AppDelegate *)sharedAppDelegate;

- (void) loadLoginViewController;


- (NSDictionary *)serviceKeyValue;

//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                         URLString:(NSString *)string
                             title:(NSString *)title
                             descr:(NSString *)descr;

- (void)httpRequestIMUserSig;

- (void)httpRequestMyBrokerAmount;

- (void)httpRequestGetBrokerInfo;

@end

