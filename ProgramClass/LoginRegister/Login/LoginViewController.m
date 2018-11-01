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
}

#pragma mark - Button Events

- (IBAction)loginButtonEvent:(id)sender
{
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
