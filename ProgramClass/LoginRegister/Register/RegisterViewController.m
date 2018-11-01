//
//  RegisterViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/10/26.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;

@end

@implementation RegisterViewController

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
    [self.nextBtn.layer setCornerRadius:21];
    [self.verifyBtn.layer setCornerRadius:5];
    [self.verifyBtn.layer setBorderColor:DIF_HEXCOLOR(@"#999999").CGColor];
    [self.verifyBtn.layer setBorderWidth:1];
}

#pragma mark - Button Events

- (IBAction)getVerifyButtonEvent:(id)sender
{
}

- (IBAction)nextButtonEvent:(id)sender
{
    [self loadViewController:@"RegisterSetPwdViewController"];
}

@end
