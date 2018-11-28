//
//  AllCommentViewController.m
//  ChangjiangVegetable
//
//  Created by zhang_jian on 2018/11/29.
//  Copyright © 2018 jian zhang. All rights reserved.
//

#import "AllCommentViewController.h"

@interface AllCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@interface CommentCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *commentLab;
@property (nonatomic, strong) UIButton *reciveBtn;

@end


@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.cellHeight = DIF_PX(132);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DIF_SCREEN_WIDTH, DIF_PX(132))];
        [view setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
        [self.contentView addSubview:view];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, DIF_PX(2), view.width, DIF_PX(130))];
        [backView setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
        [view addSubview:backView];
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(DIF_PX(6), DIF_PX(5), DIF_PX(40), DIF_PX(40))];
        [self.iconImage.layer setMasksToBounds:YES];
        [self.iconImage.layer setCornerRadius:self.iconImage.height/2];
        [self.iconImage setImage:[UIImage imageNamed:@"normalUserIcon"]];
        [backView addSubview:self.iconImage];
        
        self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.right+DIF_PX(5), self.iconImage.top,
                                                                     view.width-self.iconImage.right-DIF_PX(12), DIF_PX(30))];
        [self.nameLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.nameLab setTextColor:DIF_HEXCOLOR(@"666666")];
        [backView addSubview:self.nameLab];
        
        self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.left, self.nameLab.bottom+DIF_PX(5), self.nameLab.width, DIF_PX(20))];
        [self.dateLab setFont:DIF_DIFONTOFSIZE(12)];
        [self.dateLab setTextColor:DIF_HEXCOLOR(@"999999")];
        [backView addSubview:self.dateLab];
        
        self.commentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImage.left, self.dateLab.bottom+DIF_PX(5), backView.width-DIF_PX(12), DIF_PX(30))];
        [self.commentLab setFont:DIF_DIFONTOFSIZE(16)];
        [self.commentLab setTextColor:DIF_HEXCOLOR(@"666666")];
//        [self.commentLab setText:commentDic[@"content"]];
//        CGFloat contentHegiht = [CommonTool getSpaceLabelHeight:self.commentLab.text withFont:self.commentLab.font withWidth:self.commentLab.width];
//        if (contentHegiht > self.commentLab.height){
//            [self.commentLab setHeight:contentHegiht];
//        }
        [backView addSubview:self.commentLab];
        
        self.reciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reciveBtn setFrame:CGRectMake(self.commentLab.left, self.commentLab.bottom+DIF_PX(8), DIF_PX(82), DIF_PX(30))];
        [self.reciveBtn setTitle:@"回复" forState:UIControlStateNormal];
        [self.reciveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.reciveBtn setTitleColor:DIF_HEXCOLOR(@"#FC7940") forState:UIControlStateNormal];
        [view addSubview:self.reciveBtn];
    }
    return self;
}

- (void)loadData:(NSDictionary *)commentDic
{
    [self.nameLab setText:commentDic[@"createByName"]];
    [self.dateLab setText:commentDic[@"createTime"]];
    [self.commentLab setText:commentDic[@"content"]];
    CGFloat contentHegiht = [CommonTool getSpaceLabelHeight:self.commentLab.text withFont:self.commentLab.font withWidth:self.commentLab.width];
    if (contentHegiht > self.commentLab.height)
    {
        self.cellHeight = self.cellHeight - self.commentLab.height + contentHegiht;
        [self.commentLab setHeight:contentHegiht];
    }
    [self.reciveBtn setTop:self.commentLab.bottom+DIF_PX(8)];
}

@end

@implementation AllCommentViewController
{
    BaseTableView *m_BaseView;
    NSMutableArray *m_CommentList;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DIF_HideTabBarAnimation(YES);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DIF_HideTabBarAnimation(NO);
    // Do any additional setup after loading the view from its nib.
    [self setNavTarBarTitle:@"全部评论"];
    [self.view setBackgroundColor:DIF_HEXCOLOR(@"ffffff")];
    m_CommentList = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!m_BaseView)
    {
        m_BaseView = [[BaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [m_BaseView setDelegate:self];
        [m_BaseView setDataSource:self];
        [m_BaseView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [m_BaseView setBackgroundColor:DIF_HEXCOLOR(@"f4f4f4")];
        [self.view addSubview:m_BaseView];
        DIF_WeakSelf(self)
        [m_BaseView setRefreshBlock:^{
            DIF_StrongSelf
            [strongSelf httpRequestGetPublicCommentWithPage:@"1"];
        }];
        [m_BaseView setLoadMoreBlock:^(NSInteger page) {
            DIF_StrongSelf
            [strongSelf httpRequestGetPublicCommentWithPage:[@(page+1) stringValue]];
        }];
    }
}

#pragma mark - UITableView Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_CommentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *comment = m_CommentList[indexPath.row];
    NSDictionary *commentDic = comment[@"comment"];
    CommentCell *cell = [CommentCell cellClassName:@"CommentCell"
                                       InTableView:nil
                                   forContenteMode:commentDic];
    return cell.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *comment = m_CommentList[indexPath.row];
    NSDictionary *commentDic = comment[@"comment"];
    CommentCell *cell = [CommentCell cellClassName:@"CommentCell"
                                       InTableView:tableView
                                   forContenteMode:commentDic];
    return cell;
}

#pragma mark - Http Request

- (void)httpRequestGetPublicCommentWithPage:(NSString *)page
{
    [CommonHUD showHUD];
    DIF_WeakSelf(self)
    [DIF_CommonHttpAdapter
     httpRequestGetPublicCommentWithTopicId:self.tradeId
     PageNo:page
     PageSize:@"10"
     ResponseBlock:^(ENUM_COMMONHTTP_RESPONSE_TYPE type, id responseModel) {
         DIF_StrongSelf
         [strongSelf->m_BaseView endRefresh];
         if (type == ENUM_COMMONHTTP_RESPONSE_TYPE_SUCCESS)
         {
             [CommonHUD hideHUD];
             if (page.intValue == 1)
             {
                 strongSelf->m_CommentList = [NSMutableArray arrayWithArray:responseModel[@"data"][@"list"]];
             }
             else
             {
                 [strongSelf->m_CommentList addObjectsFromArray:responseModel[@"data"][@"list"]];
             }
             [strongSelf->m_BaseView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
         }
         else
         {
             [CommonHUD delayShowHUDWithMessage:responseModel[@"msg"]];
         }
     }
     FailedBlcok:^(NSError *error) {
         DIF_StrongSelf
         [strongSelf->m_BaseView endRefresh];
         [CommonHUD delayShowHUDWithMessage:DIF_HTTP_REQUEST_URL_NULL];
     }];
}

@end


