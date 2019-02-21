//
//  SSCircleMineVC.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/30.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSCircleMineVC.h"
#import "SSCircleMineHeaderView.h"
#import "SSCircleViewModel.h"
#import "SSCircleFriendRecommendVC.h"
#import "SSCircleTopicVC.h"
#import "SSCircleMessageVC.h"

@interface SSCircleMineVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SSCircleMineHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray   *data_array;
@property (nonatomic, strong) UITableView      *mine_table;
@property (nonatomic, strong) SSCircleViewModel *viewModel;
@property (nonatomic, strong) NSDictionary      *dicData;

@end

@implementation SSCircleMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wr_setNavBarTintColor:kColor(@"D6B35B")];
    [self wr_setNavBarBarTintColor:kColor(@"D6B35B")];
    [self wr_setNavBarTitleColor:kColor(@"333333")];
    [self.view addSubview:self.mine_table];
    [self userCircleInfo];
}

#pragma --tableDataSource--
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell cellWithTableView:tableView];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
#pragma --tableDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 275;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)userCircleInfo
{
    [self.viewModel userCircleInfoCallBack:^(id obj) {
//        返回值 fansNum 粉丝数 followNum关注数 messageNum 朋友圈个数
        self.dicData = obj[@"data"];
        self.headerView.huati_label.text = obj[@"data"][@"messageNum"];
        self.headerView.fensi_label.text = obj[@"data"][@"fansNum"];
        self.headerView.guanzhu_label.text = obj[@"data"][@"followNum"];
        [self.mine_table reloadData];
        NSLog(@"%@",obj);
    }];
}

- (SSCircleViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[SSCircleViewModel alloc]init];
    }
    return _viewModel;
}

- (UITableView *)mine_table
{
    if (!_mine_table) {
        _mine_table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _mine_table.delegate = self;
        _mine_table.dataSource = self;
        _mine_table.scrollEnabled = NO;
        _mine_table.backgroundColor = kColor(@"ffffff");
        _mine_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mine_table;
}

- (SSCircleMineHeaderView *)headerView
{
    if (_headerView == nil) {
        WEAKSELF
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"SSCircleMineHeaderView" owner:self options:nil].lastObject;
        _headerView.block = ^(SSCircleMineHeaderViewType type) {
            if (type == SSCircleMineHeaderViewTypeFensi) {
               
                SSCircleFriendRecommendVC *guanzhuVC = [[SSCircleFriendRecommendVC alloc]init];
                guanzhuVC.type = SSCircleVCTypeFans;
                [weakSelf.navigationController pushViewController:guanzhuVC animated:YES];
            }else if (type == SSCircleMineHeaderViewTypeGuanzhu)
            {
                SSCircleFriendRecommendVC *guanzhuVC = [[SSCircleFriendRecommendVC alloc]init];
                guanzhuVC.type = SSCircleVCTypeFollow;
                [weakSelf.navigationController pushViewController:guanzhuVC animated:YES];
            }else if (type == SSCircleMineHeaderViewTypeHuati)
            {
                SSCircleTopicVC *guanzhuVC = [[SSCircleTopicVC alloc]init];
                [weakSelf.navigationController pushViewController:guanzhuVC animated:YES];
                
            }else if (type == SSCircleMineHeaderViewTypePrivateMessage)
            {
                
            }else if (type == SSCircleMineHeaderViewTypeMessage)
            {
                SSCircleMessageVC *myMessage = [[SSCircleMessageVC alloc]init];
                myMessage.type = SSCircleMessageVCTypeMessage;
                [weakSelf.navigationController pushViewController:myMessage animated:YES];
            }
        };
    }
    return _headerView;
}

- (NSDictionary *)dicData
{
    if (_dicData == nil) {
        _dicData = [[NSDictionary alloc]init];
    }
    return _dicData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end