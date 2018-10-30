//
//  CommonHttp.m
//  uavsystem
//
//  Created by jian zhang on 16/8/4.
//  Copyright © 2018年 . All rights reserved.
//

#import "CommonHttpAdapter.h"
#import <netinet/in.h>

static CommonHttpAdapter *comHttp = nil;

@implementation CommonHttpAdapter
{
    AFHTTPSessionManager *httpSessionManager;
    AFSecurityPolicy *securityPolicy;
    NSString *sessionString;
    NSString *m_BaseUrl;
}

+ (CommonHttpAdapter *)sharedCommonHttp
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        comHttp = [[CommonHttpAdapter alloc] init];
    });
    return comHttp;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initAFNSession];
    }
    return self;
}

- (void)initAFNSession
{
    httpSessionManager = nil;
//    NSString *requsetType = @"https";
//    if (![DIF_CommonCurrentUser.serviceHost isEqualToString:@"192.168.100.243:51120"])
//    {
//        requsetType = @"http";
//    }
//    m_BaseUrl = [NSString stringWithFormat:@"%@://%@:%@/%@/",requsetType,DIF_CommonCurrentUser.serviceHost,DIF_CommonCurrentUser.servicePort,DIF_CommonCurrentUser.serviceName];
//    m_BaseUrl = @"http://192.168.100.243:51120";
    httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [httpSessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    httpSessionManager.requestSerializer.timeoutInterval = 30;
    [httpSessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    AFJSONResponseSerializer *response = (AFJSONResponseSerializer *)httpSessionManager.responseSerializer;
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/xml",@"application/json", @"text/json", @"text/javascript",@"text/html",@"application/x-www-form-urlencoded", nil];
    response.removesKeysWithNullValues = YES;
//    if ([DIF_CommonCurrentUser.serviceHost isEqualToString:@"www.jlxxxfw.cn"])
//    {
//        [self setHttpsCertificate];
//    }
}

- (void)setBaseUrl:(NSString *)url
{
//    NSString *requsetType = @"https";
//    if (![DIF_CommonCurrentUser.serviceHost isEqualToString:@"www.jlxxxfw.cn"])
//    {
//        requsetType = @"http";
//    }
    m_BaseUrl = [NSString stringWithFormat:@"%@/",url];
    [httpSessionManager setBaseURL:[NSURL URLWithString:m_BaseUrl]];
//    if ([DIF_CommonCurrentUser.serviceHost isEqualToString:@"www.jlxxxfw.cn"])
//    {
//        [self setHttpsCertificate];
//    }
}

-(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)setHttpsCertificate
{
//    __block NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"appClient" ofType:@"cer"];
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//    securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//    securityPolicy.allowInvalidCertificates = YES;
////    securityPolicy.validatesDomainName = NO;
//    NSSet *set = [[NSSet alloc] initWithObjects:cerData, nil];
//    securityPolicy.pinnedCertificates = set;
//
//    httpSessionManager.securityPolicy = securityPolicy;
}

- (NSString *)parametersToString:(NSDictionary *)params
{
    NSMutableString *paramString = [NSMutableString string];
    for (NSString *key in params.allKeys)
    {
        [paramString appendFormat:@"%@=%@",key,params[key]];
        [paramString appendString:@"&"];
    }
    [paramString deleteCharactersInRange:NSMakeRange(paramString.length-1, 1)];
    return paramString;
}

#pragma mark 获取请求对象
- (NSMutableURLRequest *)reWrteCreateHttpRequstWithMethod:(NSString *)model
                                                URLString:(NSString *)URLString
                                               parameters:(id)parameters
                                                  failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request;
    if ([model isEqualToString:@"GET"])
    {
        request =
        [httpSessionManager.requestSerializer requestWithMethod:model
                                                      URLString:[httpSessionManager.baseURL.absoluteString stringByAppendingString:URLString]
                                                     parameters:parameters
                                                          error:&serializationError];
    }
    else if ([URLString rangeOfString:@"myperformance/member"].location != NSNotFound ||
             [URLString rangeOfString:@"myperformance/safe"].location != NSNotFound ||
             [URLString rangeOfString:@"myperformance/credit"].location != NSNotFound)
    {
        request =
        [httpSessionManager.requestSerializer requestWithMethod:model
                                                      URLString:[httpSessionManager.baseURL.absoluteString stringByAppendingString:URLString]
                                                     parameters:parameters
                                                          error:&serializationError];
    }
    else
    {
        request =
        [[AFJSONRequestSerializer serializer] requestWithMethod:model
                                                      URLString:[httpSessionManager.baseURL.absoluteString stringByAppendingString:URLString]
                                                     parameters:parameters
                                                          error:&serializationError];
    }
    if (serializationError)
    {
        if (failure)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(httpSessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    return request;
}

#pragma mark 获取请求事件并执行
- (NSURLSessionDataTask *)httpRequest:(NSURLRequest *)request
                             progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                              success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                              failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [httpSessionManager dataTaskWithRequest:request
                                        uploadProgress:uploadProgress
                                      downloadProgress:nil
                                     completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                         if (error)
                                         {
                                             if (failure)
                                             {
                                                 failure(dataTask, error);
                                             }
                                         }
                                         else
                                         {
                                             if (success)
                                             {
                                                 success(dataTask, responseObject);
                                             }
                                         }
                                     }];
    [dataTask resume];
    return dataTask;
}

#pragma mark - Get请求
- (void)HttpGetRequestWithCommand:(NSString *)command
                       parameters:(NSDictionary *)parms
                    ResponseBlock:(CommonHttpResponseBlock)block
                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (![self connectedToNetwork])
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_NOT_HAVE_NETWORK}):nil;
        return;
    }
    if (!command)
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_REQUEST_PARMS_NULL}):nil;
        return;
    }
    if (parms)
    {
        command = [command stringByAppendingFormat:@"?%@",[self parametersToString:parms]];
    }
    DebugLog(@"command = %@",command);
    NSMutableURLRequest *request =
    [self reWrteCreateHttpRequstWithMethod:@"GET"
                                 URLString:[command stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                parameters:nil
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       DebugLog(@"error = %@",error);
                                       if (failedBlock)
                                       {
                                           failedBlock(error);
                                       }
                                   }];
    
    [self httpRequest:request
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  DebugLog(@"responseObject = %@",responseObject);
                  if (block)
                  {
                      if ([responseObject[@"code"] integerValue] == 200)
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS,responseObject);
                      }
                      else
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,responseObject);
                      }
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  DebugLog(@"error = %@",error);
                  if (failedBlock)
                  {
                      failedBlock(error);
                  }
              }];
}

#pragma mark - Post请求
- (void)HttpPostRequestWithCommand:(NSString *)command
                        parameters:(NSDictionary *)parms
                     ResponseBlock:(CommonHttpResponseBlock)block
                       FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (![self connectedToNetwork])
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_NOT_HAVE_NETWORK}):nil;
        return;
    }
    if (!command)
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_REQUEST_PARMS_NULL}):nil;
        return;
    }
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parms
//                                                       options:NSJSONWritingPrettyPrinted error:nil];
//    // NSData转为NSString
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    DebugLog(@"command = %@\nresponseObject = %@",command,jsonStr);
    NSMutableURLRequest *request =
    [self reWrteCreateHttpRequstWithMethod:@"POST"
                                 URLString:[command stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                parameters:parms
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       DebugLog(@"error = %@",error);
                                       if (failedBlock)
                                       {
                                           failedBlock(error);
                                       }
                                   }];
    
    [self httpRequest:request
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  DebugLog(@"responseObject = %@",responseObject);
                  if (block)
                  {
                      if ([responseObject[@"code"] integerValue] == 200)
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS,responseObject);
                      }
                      else
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,responseObject);
                      }
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  DebugLog(@"error = %@",error);
                  if (failedBlock)
                  {
                      failedBlock(error);
                  }
              }];
}

#pragma mark - Put请求
- (void)HttpPutRequestWithCommand:(NSString *)command
                        parameters:(NSDictionary *)parms
                     ResponseBlock:(CommonHttpResponseBlock)block
                       FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (![self connectedToNetwork])
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_NOT_HAVE_NETWORK}):nil;
        return;
    }
    if (!command)
    {
        block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@{@"message":DIF_HTTP_REQUEST_PARMS_NULL}):nil;
        return;
    }
    DebugLog(@"command = %@",command);
    NSMutableURLRequest *request =
    [self reWrteCreateHttpRequstWithMethod:@"PUT"
                                 URLString:[command stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                                parameters:parms
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                       DebugLog(@"error = %@",error);
                                       if (failedBlock)
                                       {
                                           failedBlock(error);
                                       }
                                   }];
    
    [self httpRequest:request
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                  DebugLog(@"responseObject = %@",responseObject);
                  if (block)
                  {
                      if ([responseObject[@"code"] integerValue] == 200)
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS,responseObject);
                      }
                      else
                      {
                          block(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,responseObject);
                      }
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  DebugLog(@"error = %@",error);
                  if (failedBlock)
                  {
                      failedBlock(error);
                  }
              }];
}

#pragma mark - 取得公告附件下载路径
- (void)httpRequestDownloadFileByMobileWithParameters:(NSDictionary *)parms
                                        ResponseBlock:(CommonHttpResponseBlock)successBlock
                                          FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"downloadFileByMobile.action"
                         parameters:parms
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

- (void)downLoadFileEventWithUrlString:(NSString *)urlPara
                          fieldTxtFile:(NSString *)filePath
                         ResponseBlock:(CommonHttpResponseBlock)successBlock
                        uploadProgress:(CommonHttpResponseProgress)progressBlock
{
    if (![self connectedToNetwork])
    {
        if (successBlock)
        {
            successBlock(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,@"网络连接失败\n请查看网络是否连接正常！");
        }
        return;
    }
    NSError *serializationError = nil;
    
    AFHTTPSessionManager *downLoadManger = [AFHTTPSessionManager manager];
    downLoadManger.responseSerializer = [AFJSONResponseSerializer serializer];
    downLoadManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSMutableURLRequest *request = [downLoadManger.requestSerializer
                                    requestWithMethod:@"GET"
                                    URLString:urlPara.mj_url.absoluteString
                                    parameters:nil
                                    error:&serializationError];
    __block NSURLSessionDownloadTask *dataTask =
    [downLoadManger downloadTaskWithRequest:request
                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                       if (progressBlock)
                                       {
                                           progressBlock(downloadProgress);
                                       }
                                   }
                                destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                    
                                    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                    //使用建议的路径
                                    path = [path stringByAppendingPathComponent:@"/downloadFile"];
                                    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
                                    {
                                        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                                    }
                                    path = [path stringByAppendingPathComponent:filePath];
                                    InfoLog(@"%@",path);
                                    NSURL *url = [NSURL fileURLWithPath:path];
                                    return url;
                                }
                          completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                              if (successBlock)
                              {
                                  if (error == nil)
                                  {
                                      successBlock(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS,@{@"message":@"下载完成",
                                                                                           @"filePath":filePath.absoluteString});
                                  }
                                  else
                                  {//下载失败的时候，只列举判断了两种错误状态码
                                      NSString * message = nil;
                                      if (error.code == - 1005) {
                                          message = @"网络异常";
                                      }else if (error.code == -1001){
                                          message = @"请求超时";
                                      }else if (error.code == -1011){
                                          message = @"文件已过期";
                                      }else{
                                          message = @"未知错误";
                                      }
                                      successBlock(ENUM_COMMONHTTP_RESPONSE_TYPE_FAULSE,message);
                                      if (filePath && filePath.absoluteString.length > 0)
                                      {
                                          [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                                      }
                                  }
                              }
                          }];
    [dataTask resume];
}

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
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (!image)
    {
        return nil;
    }
    __block NSString *fileUrl = nil;
    __block BOOL isHttpEnd = NO;
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                                    @"application/json",
                                                                    @"text/html",
                                                                    @"image/jpeg",
                                                                    @"image/png",
                                                                    @"application/octet-stream",
                                                                    @"text/json",
                                                                    @"multipart/form-data",
                                                                    nil];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [httpSessionManager.requestSerializer
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:[[NSURL URLWithString:@"/file" relativeToURL:httpSessionManager.baseURL] absoluteString]
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                        NSData *imageData = UIImageJPEGRepresentation(image, 1);
                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                        formatter.dateFormat = @"yyyyMMddHHmmssSSSS";
                                        NSString *str = [formatter stringFromDate:[NSDate date]];
                                        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                                        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
                                    }
                                    error:&serializationError];
    if (serializationError)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
        dispatch_async(httpSessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
            isHttpEnd = YES;
        });
#pragma clang diagnostic pop
        return nil;
    }
    
    NSURLSessionDataTask *task =
    [httpSessionManager
     uploadTaskWithStreamedRequest:request
     progress:^(NSProgress * _Nonnull uploadProgress) {
         DebugLog(@"responseObject = %@",uploadProgress.localizedDescription);
     }
     completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
         DebugLog(@"responseObject = %@",responseObject);
         if (error &&
             (!responseObject ||
              ([responseObject[@"httpStatus"] integerValue] != 401 &&
               [responseObject[@"httpStatus"] integerValue] != 405))) {
                  fileUrl = nil;
                  failedBlock?failedBlock(error):nil;
              }
         else
         {
             if ([responseObject[@"code"] integerValue] == 604)
             {
//                 [self refreshAccessTokenWithSuccessBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
//                     [self HttpGetRequestWithCommand:command parameters:parms ResponseBlock:block FailedBlcok:failedBlock];
//                 }];
                 DIF_POP_TO_LOGIN
             }
             else
             {
                 fileUrl = responseObject[@"data"];
                 successBlock?successBlock(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS,responseObject):nil;
             }
         }
         isHttpEnd = YES;
         [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
     }];
    [task resume];
    while (!isHttpEnd)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return fileUrl;
}

#pragma mark - Interface
#pragma mark - 获取首页数据接口
- (void)httpRequestGetMainDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getMainData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取关注的菜单列表
- (void)httpRequestGetMenuListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getMenuList"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取视频数据
- (void)httpRequestGetVideoDataByMenuIdWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getVideoDataByMenuId"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取商城页面数据
- (void)httpRequestGetShopDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getShopData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取网展页面数据
- (void)httpRequestGetOnlineDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getOnlineData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 根据菜单ID获取资讯列表
- (void)httpRequestGetTopicListByMenuIdWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getTopicListByMenuId"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取热门推荐视频列表
- (void)httpRequestPostGeHotVideoListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"geHotVideoList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

@end
