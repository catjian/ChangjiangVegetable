//
//  ForgetPasswordViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/26.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ForgetPasswordViewController

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
}

#pragma mark - Button Events

- (IBAction)nextButtonEvent:(id)sender
{
    [self loadViewController:@"ForgetPwdVerifyViewController"];
}

@end
