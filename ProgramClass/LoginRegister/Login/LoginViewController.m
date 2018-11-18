//
//  LoginViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/25.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self setNavTarBarTitle:@"登录"];
    //        [self setLeftItemWithContentName::@"back"];
    [self.loginBtn.layer setCornerRadius:5];
    [self.registBtn.layer setCornerRadius:5];
    [self.registBtn.layer setBorderColor:DIF_HEXCOLOR(@"#E53C1C").CGColor];
    [self.registBtn.layer setBorderWidth:1];
    if(!DIF_CommonHttpAdapter.access_token)
    {
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setHidesBackButton:YES];
    }
}

#pragma mark - Button Events

- (IBAction)loginButtonEvent:(id)sender
{
    if(self.phoneTF.text.isNull || ![CommonVerify isMobileNumber:self.phoneTF.text])
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入手机号"];
        return;
    }
    if(self.passwordTF.text.isNull)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入密码"];
        return;
    }
    [CommonHUD showHUDWithMessage:@"正在登录..."];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestLoginWithMobile:self.phoneTF.text
     Password:self.passwordTF.text
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             NSDictionary *responseData = responseModel[@"data"];
             DIF_CommonCurrentUser.accessToken = responseData[@"token"];
             DIF_CommonCurrentUser.refreshToken = responseData[@"refresh_token"];
             DIF_CommonHttpAdapter.access_token = DIF_CommonCurrentUser.accessToken;
             DIF_CommonHttpAdapter.refresh_token = DIF_CommonCurrentUser.refreshToken;
             [strongSelf.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)registButtonEvent:(id)sender
{
    [self loadViewController:@"RegisterViewController"];
}

- (IBAction)forgetPasswordButtonEvent:(id)sender
{
    [self loadViewController:@"ForgetPasswordViewController"];
}

@end
