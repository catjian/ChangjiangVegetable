//
//  AddressAddViewController.m
//  ChangjiangVegetable
//
//  Created by jian zhang on 2018/11/6.
//  Copyright © 2018年 jian zhang. All rights reserved.
//

#import "AddressAddViewController.h"

@interface AddressAddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *countyTF;
@property (weak, nonatomic) IBOutlet UITextField *addressInfoTF;

@end

@implementation AddressAddViewController

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
    [self setNavTarBarTitle:@"添加收货地址"];
    UIButton *rightBtn = [self setRightItemWithContentName:@"保存"];
    [rightBtn setTitleColor:DIF_HEXCOLOR(@"fd763c") forState:UIControlStateNormal];
    [self httpRequestPostGetCustomAddress];
}

#pragma mark - Http Request

- (void)httpRequestPostGetCustomAddress
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter httpRequestPostGetCustomAddressWithResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
        DIF_StrongSelf
        if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
        {
            [CommonHUD hideHUD];
            NSDictionary *dataDic = responseModel[@"data"][0];
            [strongSelf.nameLab setText:dataDic[@"name"]];
            [strongSelf.phoneTF setText:dataDic[@"phone"]];
            [strongSelf.provinceTF setText:dataDic[@"province"]];
            [strongSelf.cityTF setText:dataDic[@"city"]];
            [strongSelf.countyTF setText:dataDic[@"area"]];
            [strongSelf.addressInfoTF setText:dataDic[@"addressInfo"]];
        }
        else
        {
            [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
        }
    } FailedBlcok:^(NSError *error) {
        [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
    }];
}

@end
