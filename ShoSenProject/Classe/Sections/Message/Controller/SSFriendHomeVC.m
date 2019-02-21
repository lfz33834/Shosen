//
//  SSFriendHomeVC.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/30.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSFriendHomeVC.h"
#import "SSCircleFriendsCell.h"
#import "SSCircleFriendHomeHeaderView.h"
#import "SSCircleMessageVC.h"
#import "SSMessageDetailVC.h"
#import "SSCircleListModel.h"
#import "SSCircleListCell.h"
#import "SSMessageDetailVC.h"
#import "SSCircleFriendRecommendVC.h"
#import "SSCircleViewModel.h"
#import "SSCircleShareBlackListView.h"
#import "SSCircleReportView.h"
#import "SSCircleBlackListView.h"
#import "SSCircleViewModel.h"

@interface SSFriendHomeVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *orderListTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *followArray;
@property (nonatomic, strong) SSCircleViewModel *viewModel;
@property (nonatomic, strong) SSCircleFriendHomeHeaderView  *headerView;
@property (nonatomic, strong) SSCircleReportView *reportView;
@property (nonatomic, strong) SSCircleBlackListView *laheiView;
@property (nonatomic, assign) int pageNum;

@end

@implementation SSFriendHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.orderListTable];
    
    
    UIButton * rightBtn = [UIButton itemWithFream:CGRectMake(0.0, 0.0, 30.0f, 30.0f) withbackGroundColor:[UIColor clearColor] withTitle:@"" withTitleColor:kColor(@"999999") withTitleSize:15 withIsBold:NO];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"circle_home_more"] forState:UIControlStateNormal];
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    if (self.vcType == SSFriendHomeVCTypeOthers) {
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [self setTitle:@"好友主页"];
        self.headerView.type = SSCircleFriendHomeHeaderViewTypeOthers;
        self.headerView.isFollow = NO;
    }else if(self.vcType == SSFriendHomeVCTypeSelf){
        [self setTitle:@"我的主页"];
        self.headerView.type = SSCircleFriendHomeHeaderViewTypeSlef;
    }else if (self.vcType == SSFriendHomeVCTypeFriends){
        [self setTitle:@"好友主页"];
        self.headerView.isFollow = YES;
        self.headerView.type = SSCircleFriendHomeHeaderViewTypeFriends;
    }
    [self.headerView initViewWithModel:self.listModel];
    [self feltData];
}

- (void)rightBtnAction
{
    SSCircleShareBlackListView *shareView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleShareBlackListView" owner:self options:nil].lastObject;
    [shareView initViewWithType:SSCircleShareBlackListTypeShare];
    [shareView showView];
}

#pragma --tableDataSource--
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        SSCircleFriendsCell *cell = [SSCircleFriendsCell cellWithTableView:tableView];
        if (self.vcType == SSFriendHomeVCTypeSelf) {
            cell.cellType = SSCircleFriendsCellTypeSelfUserInfo;
        }else{
            cell.cellType = SSCircleFriendsCellTypeOtherUserInfo;
        }
        [cell initCellWithDataArray:self.followArray];
        cell.block = ^(SSCircleListModel *model,SSCircleFriendsCellType cellType) {
            SSFriendHomeVC *homeVC = [[SSFriendHomeVC alloc]init];
            homeVC.listModel = model;
            homeVC.vcType = SSFriendHomeVCTypeOthers;
            [self.navigationController pushViewController:homeVC animated:YES];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    SSCircleListCell *cell = [SSCircleListCell cellWithTableView:tableView];
    SSCircleListModel *model = self.dataArray[indexPath.row - 1];
    [cell initCellWithModel:model index:indexPath.row];
    cell.block = ^(SSCircleListCellType cellType, SSCircleListModel *circleModel,NSInteger index) {
        if (cellType == SSCircleListCellTypeMessage) {
            SSMessageDetailVC *messageDetailVC = [[SSMessageDetailVC alloc]init];
            messageDetailVC.model = circleModel;
            [self.navigationController pushViewController:messageDetailVC animated:YES];
        }else if (cellType == SSCircleListCellTypeUserZhanKai){
            model.isUnfold = !circleModel.isUnfold;
            
            //1.当前所要刷新的cell，传入要刷新的 行数 和 组数
            NSIndexPath *indexCell = [NSIndexPath indexPathForRow:index inSection:0];
            //2.将indexPath添加到数组
            NSArray <NSIndexPath *> *indexPathArray = @[indexCell];
            //3.传入数组，对当前cell进行刷新
            [self.orderListTable reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [self.orderListTable reloadData];
        }
//        }else if (cellType == SSCircleListCellTypeUserInfo)
//        {
//            SSAccount *account = [SSAccountTool share].account;
//            SSFriendHomeVC *homeVC = [[SSFriendHomeVC alloc]init];
//            homeVC.listModel = circleModel;
//            if ([account.uid intValue] == [circleModel.userId intValue]) {
//                homeVC.vcType = SSFriendHomeVCTypeSelf;
//            }else{
//                homeVC.vcType = SSFriendHomeVCTypeFriends;
//            }
//            [self.navigationController pushViewController:homeVC animated:YES];
//        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}
#pragma --tableDelegate--

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 135;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    SSCircleListModel *model = self.dataArray[indexPath.row - 1];
    if (model.contentHeight > 120 && model.isUnfold) {
        return model.contentHeight+model.bottomViewHeight+model.imageHeight+ 110 + 30;
    }else if(model.contentHeight > 120 && !model.isUnfold){
        return 120+model.bottomViewHeight+model.imageHeight+ cellContentHeight;
    }
    return model.contentHeight+model.bottomViewHeight+model.imageHeight+ 110 + 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"mine_order_null"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无订单";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:kColor(@"999999")
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UITableView *)orderListTable
{
    if (!_orderListTable) {
        _orderListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight - 40 - 20) style:UITableViewStylePlain];
        _orderListTable.delegate = self;
        _orderListTable.dataSource = self;
        _orderListTable.backgroundColor = kColor(@"f8f8f8");
        _orderListTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.pageNum = 1;
            [self feltCircleList];
            [self.orderListTable.mj_header endRefreshing];
        }];
        _orderListTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNum ++;
            [self feltCircleList];
            [self.orderListTable.mj_footer endRefreshing];
        }];
        _orderListTable.emptyDataSetSource = self;
        _orderListTable.emptyDataSetDelegate = self;
        _orderListTable.mj_footer.automaticallyHidden = YES;
        [_orderListTable.mj_header beginRefreshing];
        _orderListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _orderListTable;
}

- (void)feltCircleList
{
    NSString *pageNumStr = [NSString stringWithFormat:@"%d",self.pageNum];
    [self.viewModel userCircleSelfMessageWithUserId:self.listModel.userId content:@"" PageNum:pageNumStr CallBack:^(id obj) {
        if (self.pageNum == 1) {
            self.dataArray = [SSCircleListModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
        }else{
            NSArray *moreArray = [SSCircleListModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [self.dataArray addObjectsFromArray:moreArray];
            if (moreArray.count < 10) {
                [self.orderListTable.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.orderListTable reloadData];
    }];//消息列表
}

- (void)feltData
{
    [self.viewModel  userCircleSelfFollowWithUserId:self.listModel.userId PageNum:@"1" CallBack:^(id obj) {
        self.followArray = [SSCircleListModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
        [self.orderListTable reloadData];
    }];//关注列表
    
    [self.viewModel userCircleSelfMessageWithUserId:self.listModel.userId content:@""  PageNum:@"1" CallBack:^(id obj) {
        self.dataArray = [SSCircleListModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
        [self.orderListTable reloadData];
    }];//消息列表
}

- (SSCircleViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[SSCircleViewModel alloc]init];
    }
    return _viewModel;
}

- (SSCircleFriendHomeHeaderView *)headerView
{
    if (_headerView == nil) {
        WEAKSELF
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleFriendHomeHeaderView" owner:self options:nil].lastObject;
        _headerView.block = ^(SSCircleHomeHeaderViewType type) {
            if (SSCircleHomeHeaderViewTypeHeader) {
                SSCircleShareBlackListView *shareView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleShareBlackListView" owner:weakSelf options:nil].lastObject;
                [shareView initViewWithType:SSCircleShareBlackListTypeBlackList];
                shareView.block = ^(SSCireViewTapType type) {
                    if(type == SSCireViewTapTypeJubao)
                    {
                        [weakSelf.reportView showView];
                    }else if (type == SSCireViewTapTypeLahei){
                        [weakSelf.laheiView showView];
                    }
                };
                if (self.vcType == SSFriendHomeVCTypeOthers) {
                    [shareView showView];
                }
            }
        };
    }
    return _headerView;
}

- (SSCircleReportView *)reportView
{
    if (_reportView == nil) {
        WEAKSELF
        _reportView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleReportView" owner:self options:nil].lastObject;
        _reportView.block = ^(NSString *content) {
            SSAccount *account = [SSAccountTool share].account;
            [weakSelf.viewModel circleUserCircleReportAndBlacklistWithUserId:account.uid targetId:weakSelf.listModel.ID type:@"1" reason:content allBack:^(id obj) {
                [ProgressHUD showSuccess:@"举报成功"];
            }];
        };
    }
    return _reportView;
}

- (SSCircleBlackListView *)laheiView
{
    if (_laheiView == nil) {
        WEAKSELF
        _laheiView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleBlackListView" owner:self options:nil].lastObject;
        _laheiView.block = ^{
            SSAccount *account = [SSAccountTool share].account;
            [weakSelf.viewModel circleUserCircleReportAndBlacklistWithUserId:account.uid targetId:weakSelf.listModel.ID type:@"0" reason:@"" allBack:^(id obj) {
                [ProgressHUD showSuccess:@"拉黑成功"];
            }];
        };
    }
    return _laheiView;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSMutableArray *)followArray
{
    if (_followArray == nil) {
        _followArray = [[NSMutableArray alloc]init];
    }
    return _followArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end