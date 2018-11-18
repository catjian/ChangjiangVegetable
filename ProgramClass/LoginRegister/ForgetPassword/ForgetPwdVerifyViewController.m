//
//  ForgetPwdVerifyViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/26.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ForgetPwdVerifyViewController.h"

@interface ForgetPwdVerifyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation ForgetPwdVerifyViewController
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
    [self.navigationController setNavigationBarHidden:NO];
    m_TimerNum = 60;
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self setNavTarBarTitle:@"忘记密码"];
    //        [self setLeftItemWithContentName::@"back"];
    [self.nextBtn.layer setCornerRadius:21];
    [self.verifyBtn.layer setCornerRadius:5];
    [self.verifyBtn.layer setBorderColor:DIF_HEXCOLOR(@"#999999").CGColor];
    [self.verifyBtn.layer setBorderWidth:1];
    [self.phoneLab setText:[NSString stringWithFormat:@"%@*****%@", [self.phoneNum substringToIndex:3],
                            [self.phoneNum substringFromIndex:self.phoneNum.length-2]]];
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

- (IBAction)getVerifyCodeButtonEvent:(id)sender
{
    [CommonHUD showHUDWithMessage:@"获取验证码中..."];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetForgotPasswordVerifycodeWithMobile:self.phoneNum
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [strongSelf updateVerifyButtonTitle];
             [CommonHUD delayShowHUDWithMessage:@"获取验证码成功"];
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
    [CommonHUD showHUDWithMessage:@"修改密码中..."];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestForgotPassword2WithMobile:self.phoneNum
     NewPassword:self.passwordTF.text
     VerifyCode:self.verifyTF.text
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD delayShowHUDWithMessage:@"修改密码成功"];
             UIViewController *vc = nil;
             for (UIViewController *navc in self.navigationController.viewControllers)
             {
                 if ([NSStringFromClass(navc.class) isEqualToString:@"LoginViewController"])
                 {
                     vc = navc;
                 }
             }
             if (vc)
             {
                 [strongSelf.navigationController popToViewController:vc animated:YES];
             }
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

@end
