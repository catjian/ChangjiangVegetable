//
//  RegisterViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/26.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterSetPwdViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;

@end

@implementation RegisterViewController
{
    NSInteger m_TimerNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_HideTabBarAnimation(YES);
    m_TimerNum = 60;
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self setNavTarBarTitle:@"注册"];
    //        [self setLeftItemWithContentName::@"back"];
    [self.nextBtn.layer setCornerRadius:21];
    [self.verifyBtn.layer setCornerRadius:5];
    [self.verifyBtn.layer setBorderColor:DIF_HEXCOLOR(@"#999999").CGColor];
    [self.verifyBtn.layer setBorderWidth:1];
}

- (void)updateVerifyButtonTitle
{
    m_TimerNum--;
    [self.verifyBtn setTitle:[NSString stringWithFormat:@"%ld秒后重试",m_TimerNum] forState:UIControlStateNormal];
    if (m_TimerNum!= 0)
    {
        [self performSelector:@selector(updateVerifyButtonTitle)
                   withObject:nil
                   afterDelay:1];
    }
    else
    {
        m_TimerNum = 60;
    }
}

#pragma mark - Button Events

- (IBAction)getVerifyButtonEvent:(id)sender
{
    if(self.phoneTF.text.isNull || ![CommonVerify isMobileNumber:self.phoneTF.text])
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入手机号"];
        return;
    }
    [CommonHUD showHUDWithMessage:@"获取验证码中..."];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetVerifycodeWithMobile:self.phoneTF.text
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [strongSelf updateVerifyButtonTitle];
             [CommonHUD delayShowHUDWithMessage:@"登录成功"];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
    }
     FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
        
    }];
}

- (IBAction)nextButtonEvent:(id)sender
{
    if(self.phoneTF.text.isNull || ![CommonVerify isMobileNumber:self.phoneTF.text])
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入手机号"];
        return;
    }
    if(self.verifyTF.text.isNull)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入验证码"];
        return;
    }
    RegisterSetPwdViewController *vc = [self loadViewController:@"RegisterSetPwdViewController"];
    vc.phoneNum = self.phoneTF.text;
    vc.verifycode = self.verifyTF.text;
}

@end
