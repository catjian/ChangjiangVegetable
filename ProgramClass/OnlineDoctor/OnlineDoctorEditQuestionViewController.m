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
    [self saveText];
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
    
    NSInteger userid = 12345;
    //对应自己服务器的处理方法,
    //此处是将图片上传ftp中特定位置并使用时间戳命名 该图片地址替换到html文件中去
    NSString *url = [NSString stringWithFormat:@"http://test.xxx.com/apps/kanghubang/%@/%@/%@",[NSString stringWithFormat:@"%ld",userid%1000],[NSString stringWithFormat:@"%ld",(long)userid ],imageName];
    
    NSString *script = [NSString stringWithFormat:@"window.insertImage('%@', '%@')", url, imagePath];
    NSDictionary *dic = @{@"url":url,@"image":image,@"name":imageName};
    [_imageArr addObject:dic];
    
    [self.editWebView stringByEvaluatingJavaScriptFromString:script];
    [self dismissViewControllerAnimated:YES completion:nil];
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
