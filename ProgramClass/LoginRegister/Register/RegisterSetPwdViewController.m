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
    [self.navigationController popToRootViewControllerAnimated:YES];    
}

@end
