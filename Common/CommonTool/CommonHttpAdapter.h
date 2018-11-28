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

//static NSString * const BaseUrl = @"https://www.easy-mock.com/mock/5bd1b55b5e38a677f659a8e0/cjveg";
static NSString * const BaseUrl = @"http://139.159.239.153";

@interface CommonHttpAdapter : NSObject

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *refresh_token;

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


#pragma mark - Interface
#pragma mark - 登录授权接口
#pragma mark - 登录接口
- (void)httpRequestLoginWithMobile:(NSString *)mobile
                          Password:(NSString *)password
                     ResponseBlock:(CommonHttpResponseBlock)successBlock
                       FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 注册接口
#pragma mark - 忘记密码1
- (void)httpRequestForgotPassword1WithMobile:(NSString *)mobile
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 忘记密码2
- (void)httpRequestForgotPassword2WithMobile:(NSString *)mobile
                                 NewPassword:(NSString *)password
                                  VerifyCode:(NSString *)verifycode
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 忘记密码获取验证码
- (void)httpRequestGetForgotPasswordVerifycodeWithMobile:(NSString *)mobile
                                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 注册获取验证码 /yangtze_veg/register/getVerifycode
- (void)httpRequestGetVerifycodeWithMobile:(NSString *)mobile
                             ResponseBlock:(CommonHttpResponseBlock)successBlock
                               FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 注册 /yangtze_veg/register/register
- (void)httpRequestRegisterWithMobile:(NSString *)mobile
                          NewPassword:(NSString *)password
                           VerifyCode:(NSString *)verifycode
                        ResponseBlock:(CommonHttpResponseBlock)successBlock
                          FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - app主功能接口文档
#pragma mark - 获取首页数据接口
- (void)httpRequestGetMainDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取商城页面数据
- (void)httpRequestGetShopDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取商品列表
- (void)httpRequestGetListByGoodsWithVendorId:(NSString *)vendorId  //供应商id
                                     indePage:(NSString *)indePage
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取用户的收货地址接口
- (void)httpRequestGetAddressWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                   FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取用户信息
- (void)httpRequestGetUserWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 签到
- (void)httpRequestSignInWithResponseBlock:(CommonHttpResponseBlock)successBlock
                               FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 更新用户资料

/**
 更新用户资料
 
 @param params {
 "avatar": "string",
 "birthday": "2018-11-18T13:44:57.955Z",
 "gender": 0,
 "id": 0,
 "last_login_ip": "string",
 "last_login_time": "2018-11-18T13:44:57.955Z",
 "mobile": "string",
 "nickname": "string",
 "password": "string",
 "register_ip": "string",
 "register_time": "2018-11-18T13:44:57.955Z",
 "userLevel": "string",
 "userScore": 0,
 "user_level_id": 0,
 "username": "string",
 "weixin_openid": "string"
 }
 @param successBlock suc
 @param failedBlock fail
 */
- (void)httpRequestPostUserUpdateWithParams:(NSDictionary *)params
                              ResponseBlock:(CommonHttpResponseBlock)successBlock
                                FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 收货地址
#pragma mark - 删除指定的收货地址
- (void)httpRequestAddressDeleteWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 删除指定的收货地址
- (void)httpRequestGetAddressDetailWithID:(NSString *)addId
                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                              FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取用户的收货地址接口
- (void)httpRequestGetAddressListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                       FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 添加或更新收货地址
- (void)httpRequestAddressSaveWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 资讯接口
#pragma mark - 获取关注的菜单列表
- (void)httpRequestGetMenuListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 根据菜单ID获取资讯列表
- (void)httpRequestGetTopicListByMenuIdWithMenuId:(NSString *)menuId
                                         indePage:(NSString *)indePage
                                         pageSize:(NSString *)pageSize
                                              key:(NSString *)key
                                    ResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 公共接口
#pragma mark - 获取信息详情
- (void)httpRequestGetPublicDetailWithTopicId:(NSString *)articleId
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取评论信息 /yangtze_veg/public/getComment/{articleId}
- (void)httpRequestGetPublicCommentWithTopicId:(NSString *)articleId
                                        PageNo:(NSString *)pageNo
                                      PageSize:(NSString *)pageSize
                                 ResponseBlock:(CommonHttpResponseBlock)successBlock
                                   FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 文章(列表)点赞/取消点赞 /yangtze_veg/public/like 状态(1点赞，-1取消点赞)
- (void)httpRequestGetPublicLikeWithTopicId:(NSString *)articleId
                                     Status:(NSString *)status
                              ResponseBlock:(CommonHttpResponseBlock)successBlock
                                FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark -/yangtze_veg/public/addCollect 添加收藏/取消收藏
- (void)httpRequestPublicAddCollectWithTopicId:(NSString *)articleId
                                        Status:(NSString *)status
                                 ResponseBlock:(CommonHttpResponseBlock)successBlock
                                   FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - /yangtze_veg/public/goods/addCollect 商品添加收藏/取消收藏
- (void)httpRequestPublicGoodsAddCollectWithTopicId:(NSString *)goodsId
                                          ProductId:(NSString *)productId
                                             Status:(NSString *)status
                                      ResponseBlock:(CommonHttpResponseBlock)successBlock
                                        FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - /yangtze_veg/public/saveComment/{articleId} 发评论
- (void)httpRequestPublicSaveCommentWithTopicId:(NSString *)articleId
                                        comment:(NSDictionary *)comment
                                  ResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - /yangtze_veg/public/vendor/addCollect 店铺添加收藏/取消收藏
- (void)httpRequestPublicVendorAddCollectWithTopicId:(NSString *)vendorId
                                              Status:(NSString *)status
                                       ResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 远程问诊
#pragma mark - 获取在线问诊的头部两部分数据
- (void)httpRequestGetOnlineDoctorDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                            FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 在线问诊列表数据，分页
- (void)httpRequestGetOnlineDoctorCommentWithArticleId:(NSString *)articleId
                                         ResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 查看在线问诊(专家)详情
- (void)httpRequestGetRemoteDiagnosisDetailWithArticleId:(NSString *)articleId
                                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 在线问诊 获取问诊的回帖信息
- (void)httpRequestGetOnlineDoctorArticleListWithIndePage:(NSString *)indePage
                                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                                              FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 商品相关
#pragma mark - 获取分类下的商品
- (void)httpRequestGetGoodsCategoryWithCategoryId:(NSString *)categoryId
                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                              FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 在售的商品总数
- (void)httpRequestGetGoodsCountaWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                       FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 商品详情页数据
- (void)httpRequestGetGoodsDetailWithID:(NSString *)goodId
                               referrer:(NSString *)referrer
                          ResponseBlock:(CommonHttpResponseBlock)successBlock
                            FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 商品渠道
- (void)httpRequestGetGoodsGalleryWithID:(NSString *)goodId
                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 人气推荐
- (void)httpRequestGetGoodsHotWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 人气商品列表
- (void)httpRequestGetHotGoodsListWithCategoryId:(NSString *)categoryId
                                           Order:(NSString *)order
                                            Sort:(NSString *)sort
                                   ResponseBlock:(CommonHttpResponseBlock)successBlock
                                     FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 商品首页
- (void)httpRequestGetGoodsIndexWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取商品列表
- (void)httpRequestGetGoodsListWithCategoryId:(NSString *)categoryId
                                         BrandId:(NSString *)brandId
                                           IsHot:(NSString *)isHot
                                           IsNew:(NSString *)isNew
                                           Order:(NSString *)order
                                            Page:(NSString *)page
                                         KeyWord:(NSString *)key
                                         Sort:(NSString *)sort
                                   ResponseBlock:(CommonHttpResponseBlock)successBlock
                                     FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 新品首发
- (void)httpRequestGetGoodsNewWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取商品列表
- (void)httpRequestGetGoodsProductListWithCategoryId:(NSString *)categoryId
                                            Discount:(NSString *)discount
                                               IsNew:(NSString *)isNew
                                               Order:(NSString *)order
                                                Page:(NSString *)page
                                                Sort:(NSString *)sort
                                       ResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 商品详情页
- (void)httpRequestGetGoodsRelatedWithID:(NSString *)goodId
                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取商品规格信息
- (void)httpRequestGetGoodsSKUWithGoodsID:(NSString *)goodsId
                                   GoodId:(NSString *)goodId
                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                              FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - TransferCoupon
- (void)httpRequestGetGoodsTransferCouponWithGoodsID:(NSString *)goodsId
                                            Referrer:(NSString *)referrer
                                            SendType:(NSString *)sendType
                                       ResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 订单相关
#pragma mark - 取消订单
- (void)httpRequestGetCancelOrderWithOrderId:(NSString *)orderId
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 确认收货
- (void)httpRequestGetConfirmOrderWithOrderId:(NSString *)orderId
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取订单详情
- (void)httpRequestGetOrderDetailWithOrderId:(NSString *)orderId
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取订单物流
- (void)httpRequestGetLogisticsWithShippingCode:(NSString *)shippingCode
                                     ShippingNo:(NSString *)shippingNo
                                  ResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 订单首页
- (void)httpRequestGetOrderIndexWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 获取订单列表
- (void)httpRequestGetOrderListWithPage:(NSString *)page
                         EvaluateStatus:(NSString *)evaluate_status
                            OrderStatus:(NSString *)order_status
                          ResponseBlock:(CommonHttpResponseBlock)successBlock
                            FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 订单提交
- (void)httpRequestPostOrderSubmitWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                        FailedBlcok:(CommonHttpResponseFailed)failedBlock;



#pragma mark - 视频接口
#pragma mark - 查询视频栏目
- (void)httpRequestGetVideoMenuListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 查询视频首页
- (void)httpRequestGetVideoDataByMenuIdWithMenuId:(NSString *)menuId
                                    ResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取热门推荐视频列表
- (void)httpRequestPostGetHotVideoListWithMenuId:(NSString *)menuId
                                  ResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取热门推荐视频列表
- (void)httpRequestPostGetNewVideoListWithMenuId:(NSString *)menuId
                                  ResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock;



#pragma mark - 获取网展页面数据
- (void)httpRequestGetOnlineDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取我要读刊界面的Banner
- (void)httpRequestGetReadBookBannerWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                          FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 根据类型获取读刊数据列表
- (void)httpRequestPostGetBookListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                        FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取我的书刊列表
- (void)httpRequestPostGetMyBookListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                          FailedBlcok:(CommonHttpResponseFailed)failedBlock;


#pragma mark - 获取供求信息列表 传参type
- (void)httpRequestPostGetSupportInfoListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                               FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 根据菜单id获取我的评论列表
- (void)httpRequestPostGetFeedbackListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                            FailedBlcok:(CommonHttpResponseFailed)failedBlock;
#pragma mark - 根据菜单id获取我的收藏列表
- (void)httpRequestPostGetCollectionListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                              FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 根据菜单id获取我的历史记录列表
- (void)httpRequestPostGetHistoryListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock;


#pragma mark - 获取订单列表，传参type区分：全部，待发货等状态
- (void)httpRequestPostGetOrderListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock;

#pragma mark - 获取物流信息
- (void)httpRequestPostGetExpressInfoWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock;

@end

