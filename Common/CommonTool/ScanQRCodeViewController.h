//
//  ScanQRCodeViewController.h
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeViewController : BaseViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureDevice * device; //捕获设备，默认后置摄像头
@property (strong, nonatomic) AVCaptureDeviceInput * input; //输入设备
@property (strong, nonatomic) AVCaptureMetadataOutput * output;//输出设备，需要指定他的输出类型及扫描范围
@property (strong, nonatomic) AVCaptureSession * session; //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;//展示捕获图像的图层，是CALayer的子类

@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGes;//缩放手势
@property (assign, nonatomic) CGFloat scanRegion_W;//二维码正方形扫描区域的宽度，根据不同机型适配
@property (nonatomic) CGFloat initScale;

@end
NS_ASSUME_NONNULL_END
