//
//  PayInputContinueViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/5.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "PayInputContinueViewController.h"

@interface PayInputContinueViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *lineOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineTwoBtn;

@property (weak, nonatomic) IBOutlet UITextField *customFP;
@property (weak, nonatomic) IBOutlet UITextField *zssFP;
@property (weak, nonatomic) IBOutlet UITextField *zyFP;

@property (weak, nonatomic) IBOutlet UIView *contentTwoView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardIdTF;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLab;

@end

@implementation PayInputContinueViewController
{
    NSInteger m_SelectTag;
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
    [self.navigationController setNavigationBarHidden:NO];
    DIF_HideTabBarAnimation(YES);
    [self setNavTarBarTitle:@"我要付款"];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    [self.nextBtn.layer setCornerRadius:self.nextBtn.height/2];
    m_SelectTag = 8800;
    [self.customFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    [self.customFP.layer setBorderWidth:1];
    [self.customFP.layer setCornerRadius:4];
    [self.customFP setDelegate:self];
    [self.zssFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    [self.zssFP.layer setBorderWidth:1];
    [self.zssFP.layer setCornerRadius:4];
    [self.zssFP setDelegate:self];
    [self.zyFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    [self.zyFP.layer setBorderWidth:1];
    [self.zyFP.layer setCornerRadius:4];
    [self.zyFP setDelegate:self];
    [self.remarkTV.layer setCornerRadius:4];
    [self.remarkTV.layer setBorderWidth:1];
    [self.remarkTV.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];    
}

- (IBAction)lineOneButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)lineTwoButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)addressButtonEvent:(id)sender {
    [self loadViewController:@"AddressAddViewController" hidesBottomBarWhenPushed:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.customFP setText:nil];
    [self.customFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    [self.zssFP setText:nil];
    [self.zssFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    [self.zyFP setText:nil];
    [self.zyFP.layer setBorderColor:DIF_HEXCOLOR(@"EAEAEA").CGColor];
    if ([textField isEqual:self.customFP]){
        m_SelectTag = 8800;
        [textField resignFirstResponder];
    }
    if ([textField isEqual:self.zssFP]){
        m_SelectTag = 8801;
        [textField resignFirstResponder];
    }
    if ([textField isEqual:self.zyFP]){
        m_SelectTag = 8802;
        [textField resignFirstResponder];
    }
    for (int i = 0; i<3; i++)
    {
        UIImageView *icon = [self.view viewWithTag:i+8800];
        [icon setImage:[UIImage imageNamed:@"未选中"]];
    }
    UIImageView *icon = [self.view viewWithTag:m_SelectTag];
    [icon setImage:[UIImage imageNamed:@"选中"]];
    [textField.layer setBorderColor:DIF_HEXCOLOR(@"e73f3f").CGColor];
    [textField setText:textField.placeholder];
}

@end
