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
    [self setNavTarBarTitle:@"忘记密码"];
    //        [self setLeftItemWithContentName::@"back"];
    [self.nextBtn.layer setCornerRadius:21];
    [self.verifyBtn.layer setCornerRadius:5];
    [self.verifyBtn.layer setBorderColor:DIF_HEXCOLOR(@"#999999").CGColor];
    [self.verifyBtn.layer setBorderWidth:1];
}

#pragma mark - Button Events

- (IBAction)nextButtonEvent:(id)sender
{
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
        [self.navigationController popToViewController:vc animated:YES];
    }
}

@end
