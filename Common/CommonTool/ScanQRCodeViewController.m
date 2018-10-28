//
//  ScanQRCodeViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/28.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ScanQRCodeViewController.h"

@interface ScanQRCodeViewController ()

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //页面标题
    self.title = @"扫一扫";
    //配置二维码扫描
    [self configBasicDevice];
    //配置缩放手势
    [self configPinchGes];
    //开始启动
    [self.session startRunning];
}

- (void)configBasicDevice
{
    //默认使用后置摄像头进行扫描,使用AVMediaTypeVideo表示视频
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设备输入 初始化
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //设备输出 初始化，并设置代理和回调，当设备扫描到数据时通过该代理输出队列，一般输出队列都设置为主队列，也是设置了回调方法执行所在的队列环境
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //会话 初始化，通过 会话 连接设备的 输入 输出，并设置采样质量为 高
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //会话添加设备的 输入 输出，建立连接
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //指定设备的识别类型 这里只指定二维码识别这一种类型 AVMetadataObjectTypeQRCode
    //指定识别类型这一步一定要在输出添加到会话之后，否则设备的课识别类型会为空，程序会出现崩溃
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //设置扫描信息的识别区域，本文设置正中央的一块正方形区域，该区域宽度是scanRegion_W
    //这里考虑了导航栏的高度，所以计算有点麻烦，识别区域越小识别效率越高，所以不设置整个屏幕
    CGFloat navH = self.navigationController.navigationBar.bounds.size.height;
    CGFloat appWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat appHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewH = appHeight - navH;
    CGFloat scanViewH = self.scanRegion_W;
    [self.output setRectOfInterest:CGRectMake((appWidth-scanViewH)/(2*appWidth), (viewH-scanViewH)/(2*viewH), scanViewH/appWidth, scanViewH/viewH)];
    //预览层 初始化，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    //预览层的区域设置为整个屏幕，这样可以方便我们进行移动二维码到扫描区域,在上面我们已经对我们的扫描区域进行了相应的设置
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, appWidth, appHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //扫描框 和扫描线的布局和设置，模拟正在扫描的过程，这一块加不加不影响我们的效果，只是起一个直观的作用
//    TNWCameraScanView *clearView = [[TNWCameraScanView alloc]initWithFrame:self.view.frame navH:navH];
//    [self.view addSubview:clearView];
    //扫描框下面的信息label布局
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (viewH+scanViewH)/2+10.0f, appWidth, 20.0f)];
    label.text = @"扫一扫功能仅用于会议签到";
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)configPinchGes{
    self.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:self.pinchGes];
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser{
    if (!_device){
        return;
    }
    //对手势的状态进行判断
    if (recogniser.state == UIGestureRecognizerStateBegan){
        _initScale = _device.videoZoomFactor;
    }
    //相机设备在改变某些参数前必须先锁定，直到改变结束才能解锁
    NSError *error = nil;
    [_device lockForConfiguration:&error]; //锁定相机设备
    if (!error) {
        CGFloat zoomFactor; //缩放因子
        CGFloat scale = recogniser.scale;
        if (scale < 1.0f) {
            zoomFactor = self.initScale - pow(self.device.activeFormat.videoMaxZoomFactor, 1.0f - recogniser.scale);
        } else {
            zoomFactor = self.initScale + pow(self.device.activeFormat.videoMaxZoomFactor, (recogniser.scale - 1.0f) / 2.0f);
        }
        zoomFactor = MIN(15.0f, zoomFactor);
        zoomFactor = MAX(1.0f, zoomFactor);
        _device.videoZoomFactor = zoomFactor;
        [_device unlockForConfiguration];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//后置摄像头扫描到二维码的信息
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];   //停止扫描
    if ([metadataObjects count] >= 1)
    {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        //拿到扫描内容在这里进行个性化处理
        NSString *result = qrObject.stringValue;
        //解析数据进行处理并实现相应的逻辑
        //代码省略
    }
}

@end
