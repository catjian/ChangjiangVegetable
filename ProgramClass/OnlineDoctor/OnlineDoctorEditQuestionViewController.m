//
//  OnlineDoctorEditQuestionViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/26.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "OnlineDoctorEditQuestionViewController.h"

@interface OnlineDoctorEditQuestionViewController () <UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIWebView *editWebView;
@property (nonatomic,strong)NSString *inHtmlString;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;

@end

@implementation OnlineDoctorEditQuestionViewController
{
    NSString *_htmlString;//保存输出的富文本
    NSMutableArray *_imageArr;//保存添加的图片
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self setNavTarBarTitle:@"发布咨询"];
    [self setRightItemWithContentName:@"发布"];
    self.editWebView.delegate = self;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *indexFileURL = [bundle URLForResource:@"richTextEditor" withExtension:@"html"];
    
    [self.editWebView setKeyboardDisplayRequiresUserAction:NO];
    [self.editWebView loadRequest:[NSURLRequest requestWithURL:indexFileURL]];
    
}

- (void)rightBarButtonItemAction:(UIButton *)btn
{
    if (self.titleTF.text.length <= 0)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入标题"];
        return;
    }
    [self saveText];
    NSString *content = [self changeString:_htmlString];
    if (content.length <= 0)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入正文"];
        return;
    }
    NSString * encodedString = [content utf8ToUnicode:content];
//    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)content, NULL, NULL,  kCFStringEncodingUTF8));
//    NSMutableString *muStr = [[NSMutableString alloc] initWithString:content];
//    NSRange range = NSMakeRange(0, 0);
//    while (1)
//    {
//        range = [[muStr substringFromIndex:range.location+range.length] rangeOfString:@"<"];
//        if (range.location == NSNotFound)
//        {
//            break;
//        }
//        else
//        {
//            [muStr replaceCharactersInRange:range withString:@"\\u003c"];
//        }
//    }
//
//
//    [muStr insertString:@"\\u003cp\\u003e" atIndex:0];
    
    [CommonHUD showHUD];
    [DIF_CommonHttpAdapter
     httpRequestRemoteDiagnosisPublishWithTopicId:nil
     comment:@{@"content":encodedString,
               @"title":self.titleTF.text}
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD delayShowHUDWithMessage:@"发表成功"];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.inHtmlString.length > 0)
    {
        NSString *place = [NSString stringWithFormat:@"window.placeHTMLToEditor('%@')",self.inHtmlString];
        [webView stringByEvaluatingJavaScriptFromString:place];
    }
}

- (IBAction)addImage:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)printHTML
{
    NSString *title = [self.editWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('title-input').value"];
    NSString *html = [self.editWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('content').innerHTML"];
    NSString *script = [self.editWebView stringByEvaluatingJavaScriptFromString:@"window.alertHtml()"];
    [self.editWebView stringByEvaluatingJavaScriptFromString:script];
    NSLog(@"Title: %@", title);
    NSLog(@"Inner HTML: %@", html);
    
    if (html.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        _htmlString = html;
        //对输出的富文本进行处理后上传
        NSLog(@"%@",[self changeString:_htmlString]);
    }
    
}

#pragma mark - ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDate *now = [NSDate date];
    NSString *imageName = [NSString stringWithFormat:@"iOS%@.jpg", [self stringFromDate:now]];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image;
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imagePath atomically:YES];
    }
    
    DIF_WeakSelf(self)
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_queue_create("com.httpUploadImageFile.queue", nil), ^{
        DIF_StrongSelf
        [CommonHUD showHUDWithMessage:@"上传图片中..."];
        NSString *url = [DIF_CommonHttpAdapter httpRequestUploadImageFile:image ResponseBlock:nil FailedBlcok:nil];
        if(!url)
        {
            [CommonHUD delayShowHUDWithMessage:@"上传失败"];
            return;
        }
        [CommonHUD delayShowHUDWithMessage:@"上传图片成功"];
        //    NSInteger userid = 12345;
        //    //对应自己服务器的处理方法,
        //    //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
        //
        //    NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
        
        NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
        NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
        [strongSelf->_imageArr addObject:dic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.editWebView stringByEvaluatingJavaScriptFromString:script];
        });
    });
        
}



- (void)saveText
{
    [self printHTML];
}


#pragma mark - Method
-(NSString *)changeString:(NSString *)str
{
    
    NSMutableArray * marr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\""]];
    
    for (int i = 0; i < marr.count; i++)
    {
        NSString * subStr = marr[i];
        if ([subStr hasPrefix:@"/var"] || [subStr hasPrefix:@" id="])
        {
            [marr removeObject:subStr];
            i --;
        }
    }
    NSString * newStr = [marr componentsJoinedByString:@"\""];
    return newStr;
    
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

@end
