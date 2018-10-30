//
//  CommonHttp.h
//  uavsystem
//
//  Created by jian zhang on 16/8/4.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#define DIF_HTTP_NOT_HAVE_NETWORK @"网络连接失败\n请查看网络是否连接正常！"
#define DIF_HTTP_REQUEST_PARMS_NULL @"请求数据不能为空"
#define DIF_HTTP_REQUEST_URL_NULL @"网络请求异常"

#define DIF_CommonHttpAdapter [CommonHttpAdapter sharedCommonHttp]

typedef NS_ENUM(NSUInteger, ENUM_COMMONHTTP_RESPONSE_TYPE) {
    ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS, // 000000
    ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE
};

typedef void(^CommonHttpResponseBlock)(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel);
typedef void(^CommonHttpResponseFailed)(NSError *error);
typedef void(^CommonHttpResponseProgress)(NSProgress *progress);

static NSString * const BaseUrl = @"https://www.easy-mock.com/mock/5bd1b55b5e38a677f659a8e0/cjveg";

@interface CommonHttpAdapter : NSObject

+ (CommonHttpAdapter *)sharedCommonHttp;

- (void)setBaseUrl:(NSString *)url;

-(BOOL) connectedToNetwork;

#pragma mark - 上传图片
/**
 上传图片
 
 @param image 图片
 @param successBlock 成功
 @param failedBlock 失败
 @return 图片URL
 */
- (NSString *)httpRequestUploadImageFile:(UIImage *)image
                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取首页数据接口
- (void)httpRequestGetMainDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取关注的菜单列表
- (void)httpRequestGetMenuListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取视频数据
- (void)httpRequestGetVideoDataByMenuIdWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取商城页面数据
- (void)httpRequestGetShopDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取网展页面数据
- (void)httpRequestGetOnlineDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 根据菜单ID获取资讯列表
- (void)httpRequestGetTopicListByMenuIdWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取热门推荐视频列表
- (void)httpRequestPostGeHotVideoListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock;
@end
