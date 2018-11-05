//
//  PayInputDetailViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/5.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "PayInputDetailViewController.h"

@interface PayInputDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLab;

@end

@implementation PayInputDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    DIF_HideTabBarAnimation(YES);
    [self setNavTarBarTitle:@"我要付款"];
    [self.nextBtn.layer setCornerRadius:self.nextBtn.height/2];
}

- (IBAction)nextButtonEvent:(id)sender {
    [self loadViewController:@"PayInputContinueViewController" hidesBottomBarWhenPushed:NO];
}

@end
