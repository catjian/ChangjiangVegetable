//
//  InsturanceOrderCommitViewController.m
//  SuperBroker
//
//  Created by zhang_jian on 2018/7/18.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "InsuranceOrderCommitViewController.h"
#import "CancelCommitOrderView.h"

@interface InsuranceOrderCommitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *promotionRewardsLab;
@property (weak, nonatomic) IBOutlet UIImageView *insIcon;
@property (weak, nonatomic) IBOutlet UILabel *insNameLab;
@property (weak, nonatomic) IBOutlet UILabel *insDateLab;
@property (weak, nonatomic) IBOutlet UILabel *insuredNameLab;
@property (weak, nonatomic) IBOutlet UILabel *insuredCardIDLab;
@property (weak, nonatomic) IBOutlet UILabel *insuredRelevanceLab;
@property (weak, nonatomic) IBOutlet UILabel *insuredPhoneLab;
@property (weak, nonatomic) IBOutlet UILabel *insuredEmailLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *createDateLab;
@property (weak, nonatomic) IBOutlet UILabel *managerPhoneLab;


@end

@implementation InsuranceOrderCommitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTarBarTitle:@"保险订单提交"];
    [self setRightItemWithContentName:@"客服-黑"];
    [self httpRequestMyOrderInsuranceDetailWithParameters];
}

- (void)rightBarButtonItemAction:(UIButton *)btn
{
    [self loadViewController:@"CustomerServerViewController" hidesBottomBarWhenPushed:YES];
}

- (IBAction)cancelOrderButtonEvent:(id)sender
{    
    CancelCommitOrderView *cancelView = [[CancelCommitOrderView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_SCREEN_HEIGHT)];
    [DIF_APPDELEGATE.window addSubview:cancelView];
    [cancelView show];
    DIF_WeakSelf(self)
    [cancelView setBlock:^(BOOL isSuccess) {
        if (isSuccess)
        {
            [CommonHUD showHUDWithMessage:@"取消订单中..."];
            DIF_StrongSelf
            [DIF_CommonHttpAdapter
             httpRequestMyOrderCancelWithParameters:@{@"orderId":strongSelf.detailModel.orderId}
             ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
                 DIF_StrongSelf
                 if(type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
                 {
                     [CommonHUD delayShowHUDWithMessage:@"取消订单成功"];
                     [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                 }
                 else
                 {
                     [CommonHUD delayShowHUDWithMessage:responseModel[@"message"]];
                 }
             } FailedBlcok:^(NSError *error) {
                 [CommonHUD delayShowHUDWithMessage:DIF_Request_NET_ERROR];
             }];
        }
    }];
}

- (void)loadContentView
{
}

#pragma mark - HttpRequest

- (void)httpRequestMyOrderInsuranceDetailWithParameters
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestMyOrderInsuranceDetailWithParameters:@{@"orderId":self.detailModel.orderId}
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             DIF_StrongSelf
             [CommonHUD hideHUD];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"message"]];
         }
     } FailedBlcok:^(NSError *error) {
         [CommonHUD delayShowHUDWithMessage:DIF_Request_NET_ERROR];
     }];
}
@end
