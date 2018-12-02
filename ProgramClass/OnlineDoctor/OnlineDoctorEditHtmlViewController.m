//
//  OnlineDoctorEditHtmlViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/12/2.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "OnlineDoctorEditHtmlViewController.h"

@interface OnlineDoctorEditHtmlViewController ()

@end

@implementation OnlineDoctorEditHtmlViewController
{
//    ZSSRichTextEditor *m_TextEditor;
    UITextField *m_TitleFile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    self.title = @"发布咨询";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
    [self setPlaceholder:@"请输入正文"];
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarInsertImageFromDevice,
                                         ZSSRichTextEditorToolbarInsertLink,
                                         ZSSRichTextEditorToolbarFonts,
                                         ZSSRichTextEditorToolbarUndo,
                                         ZSSRichTextEditorToolbarRedo];
    DIF_WeakSelf(self)
    [self setSelectPictureBlock:^(UIImage *image) {
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf insertImage:url alt:@"image"];
            });
        });
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, DIF_SCREEN_WIDTH, 1)];
    [line setBackgroundColor:DIF_HEXCOLOR(@"EFEFF4")];
    [self.view insertSubview:line belowSubview:self.editorView];
    
    m_TitleFile = [[UITextField alloc] initWithFrame:CGRectMake(DIF_PX(15), line.bottom, DIF_SCREEN_WIDTH-DIF_PX(30), DIF_PX(40))];
    [m_TitleFile setPlaceholder:@"请输入标题"];
    [self.view addSubview:m_TitleFile];
    [self.view insertSubview:m_TitleFile belowSubview:self.editorView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, m_TitleFile.bottom, DIF_SCREEN_WIDTH, 1)];
    [line2 setBackgroundColor:DIF_HEXCOLOR(@"EFEFF4")];
    [self.view addSubview:line2];
    [self.view insertSubview:line2 belowSubview:self.editorView];
    
    [self.editorView setTop:line2.bottom];
}

- (void)exportHTML {
    
    NSLog(@"%@", [self getHTML]);
    if (m_TitleFile.text.length <= 0)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入标题"];
        return;
    }
    NSString *content =  [self getHTML];
    if (content.length <= 0)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入正文"];
        return;
    }
    NSString * encodedString = content;
    [CommonHUD showHUD];
     DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestRemoteDiagnosisPublishWithTopicId:nil
     comment:@{@"content":encodedString,
               @"title":m_TitleFile.text}
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD delayShowHUDWithMessage:@"发表成功"];
             DIF_StrongSelf
             [strongSelf.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

@end
