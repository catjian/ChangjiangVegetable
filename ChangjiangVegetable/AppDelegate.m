//
//  AppDelegate.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/19.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    CLLocationManager *m_locationManager;
    AMapLocationManager *m_AmaplocationManager;
    RootViewController *homeVC;
    BOOL m_showSaveData;
    LoginViewController *m_LoginVC;
    NSDictionary *m_VersionDic;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (RootViewController *)getRootViewController
{
    return homeVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UMConfigure setLogEnabled:NO];//此处在初始化函数前面是为了打印初始化的日志
//    [MobClick setCrashReportEnabled:YES];
//    [UMConfigure initWithAppkey:@"5b5eb685b27b0a4a24000112" channel:@"App Store"];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    [self saveUUIDToKeyChain];
    [self startLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [self loadWindowRootTabbarViewController];
    DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
    DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
    [self.window makeKeyAndVisible];
    
//    [[IQKeyboardManager sharedManager] setToolbarDoneBarButtonItemText:@"完成"];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    return YES;
}

- (void)saveUUIDToKeyChain
{
    NSString *string = [SAMKeychain passwordForService:(__bridge id)kSecAttrGeneric account:(__bridge id)kSecAttrGeneric];
    if([string isEqualToString:@""] || !string)
    {
        [SAMKeychain setPassword:[self getUUIDString] forService:(__bridge id)kSecAttrGeneric account:(__bridge id)kSecAttrGeneric];
    }
}

- (NSString *)readUUIDFromKeyChain
{
    NSString *UUID = [SAMKeychain passwordForService:(__bridge id)kSecAttrGeneric account:(__bridge id)kSecAttrGeneric];
    return UUID;
}

- (NSString *)getUUIDString
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Custom Function

- (void)loadWindowRootTabbarViewController
{
    RootViewController *rootVC = [[RootViewController alloc] init];
    BaseNavigationViewController *nav1 = [[BaseNavigationViewController alloc] initWithRootViewController:rootVC];
    
    VideoListViewController *vnVC = [[VideoListViewController alloc] init];
    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:vnVC];
    
    WebShopViewController *snVC = [[WebShopViewController alloc] init];
    BaseNavigationViewController *nav3 = [[BaseNavigationViewController alloc] initWithRootViewController:snVC];
    
    WebShowViewController *msgVC = [[WebShowViewController alloc] init];
    BaseNavigationViewController *nav4 = [[BaseNavigationViewController alloc] initWithRootViewController:msgVC];
    
    MySetViewController *myVC = [[MySetViewController alloc] init];
    BaseNavigationViewController *nav5 = [[BaseNavigationViewController alloc] initWithRootViewController:myVC];
    
    self.baseTB = [[BaseTabBarController alloc] initWithViewControllers:@[nav1,nav2,nav3,nav4,nav5]];
    [self.window setRootViewController:self.baseTB];
}

- (void)loadLoginViewController
{
    [CommonHUD hideHUD];
}

#pragma mark - Location

- (void)startLocation
{
    DIF_ReviewLocationAuthorizationStatus;
    m_locationManager = [[CLLocationManager alloc] init];
//    [[AMapServices sharedServices] setApiKey:DIF_AMapKey];
    m_AmaplocationManager = [[AMapLocationManager alloc] init];
    [m_AmaplocationManager setDelegate:self];
    [m_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [m_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [m_locationManager requestWhenInUseAuthorization];
    [m_AmaplocationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(AMapLocationRegion *)region
{
    [m_AmaplocationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    DebugLog(@"amapLocationManager lat %f,lng %f",location.coordinate.latitude,location.coordinate.longitude);
    
    if (location.coordinate.latitude != 0 && location.coordinate.longitude != 0)
    {
        [m_AmaplocationManager stopUpdatingLocation];
//        [self performSelector:@selector(startSingleLocation) withObject:nil afterDelay:1];
    }
}

int delay = 1;
- (void)startSingleLocation
{
    if (delay >= 5)
    {
        delay = 4;
    }
    [self singleLocaionCenter];
    [self performSelector:@selector(startSingleLocation) withObject:nil afterDelay:delay++];
}

- (void)singleLocaionCenter
{
    [m_AmaplocationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    }];
}

- (void)singleLocaionCenter:(NSString *)webName
{
}


#pragma mark - share

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    BOOL isSucWX = [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession
                                                         appKey:@"wxee23b4575bed6a75"
                                                      appSecret:@"42653bd4124e6889f3dbedc2a233b180"
                                                    redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置QQ的appKey和appSecret */
    BOOL isSucQQ = [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ
                                                         appKey:@"1107768203"
                                                      appSecret:@"1clPhLwpEiqtTx03"
                                                    redirectURL:nil];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina
                                          appKey:@"1581588422App"
                                       appSecret:@"8caf98dfb760302b6067e69d8c57671c"
                                     redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                         URLString:(NSString *)string
                             title:(NSString *)title
                             descr:(NSString *)descr
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject
                                         shareObjectWithTitle:title?title:@"@我，这是我的独门签单秘籍，开单宝典送给努力前行的你"
                                         descr:descr?descr:@"您的好友在易普惠分享一起开单大吉，邀您开单送大礼！"
                                         thumImage:[UIImage imageNamed:@"易保金服logoShare"]];
    //设置网页地址
    shareObject.webpageUrl =string;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager]
     shareToPlatform:platformType
     messageObject:messageObject
     currentViewController:self.baseTB
     completion:^(id data, NSError *error) {
         if (error) {
             NSLog(@"************Share fail with error %@*********",error);
         }else{
             NSLog(@"response data is %@",data);
         }
     }];
}

#pragma mark - Http Request
- (void)httpRequestIMUserSig
{
    [DIF_CommonHttpAdapter
     httpRequestUserSigResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             NSDictionary *dic = responseModel[@"data"];
             DIF_APPDELEGATE.imUserSig = dic;
             NSNumber *number = dic[@"accountType"];
             [TIMManagerObject sharedTIMManager].accountType = [number stringValue];
             DIF_TIMManagerObject.identifier = dic[@"identifier"];
             DIF_TIMManagerObject.userSig = dic[@"userSig"];
             number = dic[@"sdkAppID"];
             DIF_TIMManagerObject.appidAt3rd = [number stringValue];
             DIF_TIMManagerObject.sdkAppId = [number intValue];
             [DIF_TIMManagerObject loginEvent];
         }
     } FailedBlcok:^(NSError *error) {
         
     }];
}

- (void)httpRequestMyBrokerAmount
{
    [DIF_CommonHttpAdapter
     httpRequestMyBrokerAmountResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             NSDictionary *dic = responseModel[@"data"];
             DIF_APPDELEGATE.mybrokeramount = dic;
         }
     } FailedBlcok:^(NSError *error) {
         
     }];
}

- (void)httpRequestGetBrokerInfo
{
    [CommonHUD showHUD];
    [DIF_CommonHttpAdapter
     httpRequestBrokerinfoWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD hideHUD];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"message"]];
         }
         
     } FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_Request_NET_ERROR];
     }];
}

- (void)httpRequestCheckVersion
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestCheckVersionWithParameters:@{@"versionCode": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]}
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
             strongSelf->m_VersionDic = responseModel[@"data"];
             [strongSelf showUpdataAlert];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"message"]];
         }
         
     } FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_Request_NET_ERROR];
     }];
}

- (void)showUpdataAlert
{
    DIF_WeakSelf(self)
    if ([m_VersionDic[@"isLatest"] boolValue])
    {
        UIAlertController *alert =
        [CommonAlertView showAlertViewWithTitle:@"版本更新提示"
                                        Message:m_VersionDic[@"updateInfo"]
                                   NormalButton:nil
                                   CancelButton:@"更新"
                                   NormalHander:^(UIAlertAction *action) {
                                       DIF_StrongSelf
                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strongSelf->m_VersionDic[@"downloadUrl"]]
                                                                          options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO}
                                                                completionHandler:^(BOOL success) {
                                                                    if (!success)
                                                                    {
                                                                        [CommonHUD delayShowHUDWithMessage:@"请先安装Safari" delayTime:2];
                                                                        [strongSelf showUpdataAlert];
                                                                    }
                                                                    else
                                                                    {
                                                                        [CommonHUD hideHUD];
                                                                    }
                                                                }];
                                   }];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:DIF_Login_Status] != 1)
        {
            [m_LoginVC presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

@end
