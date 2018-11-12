//
//  RegisterSetPwdViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/26.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "RegisterSetPwdViewController.h"

@interface RegisterSetPwdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegisterSetPwdViewController

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
    [self setNavTarBarTitle:@"注册"];
    //        [self setLeftItemWithContentName::@"back"];
    [self.finishBtn.layer setCornerRadius:21];
}

#pragma mark - Button Events

- (IBAction)finishButtonEvent:(id)sender
{
    if(self.passwordTF.text.isNull)
    {
        [CommonHUD delayShowHUDWithMessage:@"请输入密码"];
        return;
    }
    [CommonHUD showHUDWithMessage:@"正在注册..."];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestRegisterWithMobile:self.phoneNum
     NewPassword:self.passwordTF.text
     VerifyCode:self.verifycode
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             for(UIViewController *vc in strongSelf.navigationController.viewControllers)
             {
                 if ([vc isKindOfClass:[LoginViewController class]])
                 {
                     [strongSelf.navigationController popToViewController:vc animated:YES];
                 }
             }
             [CommonHUD delayShowHUDWithMessage:@"注册成功"];
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
