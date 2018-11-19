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
    if (self.access_token && self.access_token.length > 0)
    {
        [request setValue:self.access_token forHTTPHeaderField:@"Authorization"];
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
                      else if ([responseObject[@"code"] integerValue] == 401)
                      {
                          DIF_CommonCurrentUser.accessToken = nil;
                          DIF_CommonCurrentUser.refreshToken = nil;
                          DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
                          DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
                          [DIF_APPDELEGATE loadLoginViewController];
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
    if (parms != nil)
    {
        command = [command stringByAppendingFormat:@"?%@",[self parametersToString:parms]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parms
                                                           options:NSJSONWritingPrettyPrinted error:nil];
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DebugLog(@"parameters = %@",jsonStr);
    }
    DebugLog(@"command = %@",command);
    NSMutableURLRequest *request =
    [self reWrteCreateHttpRequstWithMethod:@"POST"
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
                      else if ([responseObject[@"code"] integerValue] == 401)
                      {
                          DIF_CommonCurrentUser.accessToken = nil;
                          DIF_CommonCurrentUser.refreshToken = nil;
                          DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
                          DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
                          [DIF_APPDELEGATE loadLoginViewController];
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

#pragma mark - 刷新accessToken

- (void)refreshAccessTokenWithSuccessBlock:(CommonHttpResponseBlock)block
{
    [self HttpPostRequestWithCommand:@"/yangtze_veg/auth/refresh"
                          parameters:@{@"refreshToken":self.refresh_token}
                       ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
                           if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
                           {
                               NSDictionary *responseData = responseModel[@"data"];
                               DIF_CommonCurrentUser.accessToken = responseData[@"token"];
                               DIF_CommonCurrentUser.refreshToken = responseData[@"refresh_token"];
                               DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
                               DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
                               block?block(ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS, nil):[CommonHUD delayShowHUDWithMessage:@"秘钥已刷新，请重试"];
                           }
                           else
                           {
                               [CommonHUD delayShowHUDWithMessage:@"账户过期，请重新登录"];
                               //                               DIF_POP_TO_LOGIN
                           }
                       } FailedBlcok:^(NSError *error) {
                           [CommonHUD delayShowHUDWithMessage:DIF_Request_NET_ERROR];
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
                      else if ([responseObject[@"code"] integerValue] == 401)
                      {
                          DIF_CommonCurrentUser.accessToken = nil;
                          DIF_CommonCurrentUser.refreshToken = nil;
                          DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
                          DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
                          [DIF_APPDELEGATE loadLoginViewController];
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
#pragma mark - 登录授权接口
#pragma mark - 登录接口
- (void)httpRequestLoginWithMobile:(NSString *)mobile
                          Password:(NSString *)password
                     ResponseBlock:(CommonHttpResponseBlock)successBlock
                       FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull || password.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/auth/login"
                          parameters:@{@"mobile":mobile, @"password":password}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 注册接口
#pragma mark - 忘记密码1
- (void)httpRequestForgotPassword1WithMobile:(NSString *)mobile
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/register/forgotPassword1"
                          parameters:@{@"mobile":mobile}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 忘记密码2
- (void)httpRequestForgotPassword2WithMobile:(NSString *)mobile
                                 NewPassword:(NSString *)password
                                  VerifyCode:(NSString *)verifycode
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull || password.isNull || verifycode.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/register/forgotPassword2"
                          parameters:@{@"mobile":mobile, @"newpwd":password,@"verifycode":verifycode}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 忘记密码获取验证码
- (void)httpRequestGetForgotPasswordVerifycodeWithMobile:(NSString *)mobile
                                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/register/getForgotPasswordVerifycode"
                          parameters:@{@"mobile":mobile}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 注册获取验证码 /yangtze_veg/register/getVerifycode
- (void)httpRequestGetVerifycodeWithMobile:(NSString *)mobile
                             ResponseBlock:(CommonHttpResponseBlock)successBlock
                               FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/register/getVerifycode"
                          parameters:@{@"mobile":mobile}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 注册 /yangtze_veg/register/register
- (void)httpRequestRegisterWithMobile:(NSString *)mobile
                          NewPassword:(NSString *)password
                           VerifyCode:(NSString *)verifycode
                        ResponseBlock:(CommonHttpResponseBlock)successBlock
                          FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    if (mobile.isNull || password.isNull)
    {
        failedBlock([NSError errorWithDomain:DIF_HTTP_REQUEST_PARMS_NULL
                                        code:-100
                                    userInfo:@{@"errorMsg":DIF_HTTP_REQUEST_PARMS_NULL}]);
    }
    [self HttpPostRequestWithCommand:@"/yangtze_veg/register/register"
                          parameters:@{@"mobile":mobile, @"password":password,@"verifycode":verifycode}
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - app主功能接口文档
#pragma mark - 获取首页数据接口
- (void)httpRequestGetMainDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/getMainData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取商城页面数据
- (void)httpRequestGetShopDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/getShopData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取商品列表
- (void)httpRequestGetListByGoodsWithVendorId:(NSString *)vendorId  //供应商id
                                     indePage:(NSString *)indePage
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    NSDictionary *parmas = @{@"vendorId":vendorId,
                             @"indePage":indePage,
                             @"pageSize":@"10"};
    [self HttpGetRequestWithCommand:@"/yangtze_veg/getListByGoods"
                         parameters:parmas
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取用户的收货地址接口
- (void)httpRequestGetAddressWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                   FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"/yangtze_veg/mycenter/address/list"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 获取用户信息
- (void)httpRequestGetUserWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/mycenter/getUser"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 签到
- (void)httpRequestSignInWithResponseBlock:(CommonHttpResponseBlock)successBlock
                               FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/mycenter/signIn"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

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
                                FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/mycenter/userUpdate"
                         parameters:params
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 收货地址
#pragma mark - 删除指定的收货地址
- (void)httpRequestAddressDeleteWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"/yangtze_veg/address/delete"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 删除指定的收货地址
- (void)httpRequestGetAddressDetailWithID:(NSString *)addId
                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                              FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/address/detail"
                         parameters:@{@"id":addId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 获取用户的收货地址接口
- (void)httpRequestGetAddressListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                       FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"/yangtze_veg/address/list"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 添加或更新收货地址
- (void)httpRequestAddressSaveWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"/yangtze_veg/address/save"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 资讯接口
#pragma mark - 获取关注的菜单列表
- (void)httpRequestGetMenuListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/cms/getMenuList"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 根据菜单ID获取资讯列表
- (void)httpRequestGetTopicListByMenuIdWithMenuId:(NSString *)menuId
                                         indePage:(NSString *)indePage
                                         pageSize:(NSString *)pageSize
                                              key:(NSString *)key
                                    ResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    NSDictionary *parmas = @{@"menuId":menuId,
                             @"indePage":indePage,
                             @"pageSize":pageSize,
                             @"key":key};
    if (key.isNull)
    {
        parmas = @{@"menuId":menuId,
                   @"indePage":indePage,
                   @"pageSize":pageSize};
    }
    [self HttpGetRequestWithCommand:@"/yangtze_veg/cms/getTopicListByMenuId"
                         parameters:parmas
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 远程问诊
#pragma mark - 获取在线问诊的头部两部分数据
- (void)httpRequestGetOnlineDoctorDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                            FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/remoteDiagnosis/getOnlineDoctorData"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 在线问诊列表数据，分页
- (void)httpRequestGetOnlineDoctorCommentWithArticleId:(NSString *)articleId
                                         ResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    
    [self HttpGetRequestWithCommand:[@"/angtze_veg/remoteDiagnosis/getComment/" stringByAppendingString:articleId]
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 在线问诊 获取问诊的回帖信息
- (void)httpRequestGetOnlineDoctorArticleListWithIndePage:(NSString *)indePage
                                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                                              FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/remoteDiagnosis/getOnlineDoctorArticleList"
                         parameters:@{@"indePage":indePage,@"pageSize":@"10"}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 商品相关
#pragma mark - 获取分类下的商品
- (void)httpRequestGetGoodsCategoryWithCategoryId:(NSString *)categoryId
                                    ResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/category"
                         parameters:@{@"categoryId":categoryId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 在售的商品总数
- (void)httpRequestGetGoodsCountaWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                       FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/count"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 商品详情页数据
- (void)httpRequestGetGoodsDetailWithID:(NSString *)goodId
                               referrer:(NSString *)referrer
                          ResponseBlock:(CommonHttpResponseBlock)successBlock
                            FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/detail"
                         parameters:@{@"goodId":goodId,@"referrer":referrer}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 商品渠道
- (void)httpRequestGetGoodsGalleryWithID:(NSString *)goodId
                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/goodsGallery"
                         parameters:@{@"goodId":goodId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 人气推荐
- (void)httpRequestGetGoodsHotWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/hot"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 人气商品列表
- (void)httpRequestGetHotGoodsListWithCategoryId:(NSString *)categoryId
                                           Order:(NSString *)order
                                            Sort:(NSString *)sort
                                   ResponseBlock:(CommonHttpResponseBlock)successBlock
                                     FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/hotGoodsList"
                         parameters:@{@"categoryId":categoryId,@"order":order}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 商品首页
- (void)httpRequestGetGoodsIndexWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/index"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
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
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/list"
                         parameters:@{@"categoryId":categoryId,
                                      @"brandId":brandId,
                                      @"isHot":isHot,
                                      @"isNew":isNew,
                                      @"order":order,
                                      @"page":page}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 新品首发
- (void)httpRequestGetGoodsNewWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/new"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 获取商品列表
- (void)httpRequestGetGoodsProductListWithCategoryId:(NSString *)categoryId
                                            Discount:(NSString *)discount
                                               IsNew:(NSString *)isNew
                                               Order:(NSString *)order
                                                Page:(NSString *)page
                                                Sort:(NSString *)sort
                                       ResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/productlist"
                         parameters:@{@"categoryId":categoryId,
                                      @"discount":discount,
                                      @"isNew":isNew,
                                      @"order":order,
                                      @"page":page}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 商品详情页
- (void)httpRequestGetGoodsRelatedWithID:(NSString *)goodId
                           ResponseBlock:(CommonHttpResponseBlock)successBlock
                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/related"
                         parameters:@{@"goodId":goodId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 获取商品规格信息
- (void)httpRequestGetGoodsSKUWithGoodsID:(NSString *)goodsId
                                   GoodId:(NSString *)goodId
                            ResponseBlock:(CommonHttpResponseBlock)successBlock
                              FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/sku"
                         parameters:@{@"goodsId":goodsId,@"goodId":goodId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - TransferCoupon
- (void)httpRequestGetGoodsTransferCouponWithGoodsID:(NSString *)goodsId
                                            Referrer:(NSString *)referrer
                                            SendType:(NSString *)sendType
                                       ResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/goods/transferCoupon"
                         parameters:@{@"goodsId":goodsId,@"referrer":referrer,@"send_type":sendType}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 订单相关
#pragma mark - 取消订单
- (void)httpRequestGetCancelOrderWithOrderId:(NSString *)orderId
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/cancelOrder"
                         parameters:@{@"orderId":orderId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 确认收货
- (void)httpRequestGetConfirmOrderWithOrderId:(NSString *)orderId
                                ResponseBlock:(CommonHttpResponseBlock)successBlock
                                  FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/confirmOrder"
                         parameters:@{@"orderId":orderId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 获取订单详情
- (void)httpRequestGetOrderDetailWithOrderId:(NSString *)orderId
                               ResponseBlock:(CommonHttpResponseBlock)successBlock
                                 FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/detail"
                         parameters:@{@"orderId":orderId}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 获取订单物流
- (void)httpRequestGetLogisticsWithShippingCode:(NSString *)shippingCode
                                     ShippingNo:(NSString *)shippingNo
                                  ResponseBlock:(CommonHttpResponseBlock)successBlock
                                    FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/getLogistics"
                         parameters:@{@"shippingCode":shippingCode,@"shippingNo":shippingNo}
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 订单首页
- (void)httpRequestGetOrderIndexWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/index"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 获取订单列表
- (void)httpRequestGetOrderListWithPage:(NSString *)page
                         EvaluateStatus:(NSString *)evaluate_status
                            OrderStatus:(NSString *)order_status
                          ResponseBlock:(CommonHttpResponseBlock)successBlock
                            FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"size":@"10"}];
    if (!page)
    {
        [params setObject:@"1" forKey:@"page"];
    }
    if (evaluate_status)
    {
        [params setObject:evaluate_status forKey:@"evaluate_status"];
    }
    if (order_status)
    {
        [params setObject:order_status forKey:@"order_status"];
    }
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/list"
                         parameters:params
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}
#pragma mark - 订单提交
- (void)httpRequestPostOrderSubmitWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                        FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"/yangtze_veg/order/submit"
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



#pragma mark - 获取网展页面数据
- (void)httpRequestGetOnlineDataWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                      FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getOnlineData"
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

#pragma mark - 获取我要读刊界面的Banner
- (void)httpRequestGetReadBookBannerWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                          FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpGetRequestWithCommand:@"getReadBookBanner"
                         parameters:nil
                      ResponseBlock:successBlock
                        FailedBlcok:failedBlock];
}

#pragma mark - 根据类型获取读刊数据列表
- (void)httpRequestPostGetBookListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                        FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getBookList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 获取我的书刊列表
- (void)httpRequestPostGetMyBookListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                          FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getMyBookList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}



#pragma mark - 获取供求信息列表 传参type
- (void)httpRequestPostGetSupportInfoListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                               FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getSupportInfoList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 根据菜单id获取我的评论列表
- (void)httpRequestPostGetFeedbackListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                            FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getFeedbackList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}
#pragma mark - 根据菜单id获取我的收藏列表
- (void)httpRequestPostGetCollectionListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                              FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getCollectionList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 根据菜单id获取我的历史记录列表
- (void)httpRequestPostGetHistoryListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getHistoryList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 获取用户地址信息
- (void)httpRequestPostGetCustomAddressWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                             FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getCustomAddress"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 获取订单列表，传参type区分：全部，待发货等状态
- (void)httpRequestPostGetOrderListWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                         FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getOrderList"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}

#pragma mark - 获取物流信息
- (void)httpRequestPostGetExpressInfoWithResponseBlock:(CommonHttpResponseBlock)successBlock
                                           FailedBlcok:(CommonHttpResponseFailed)failedBlock
{
    [self HttpPostRequestWithCommand:@"getExpressInfo"
                          parameters:nil
                       ResponseBlock:successBlock
                         FailedBlcok:failedBlock];
}


@end

