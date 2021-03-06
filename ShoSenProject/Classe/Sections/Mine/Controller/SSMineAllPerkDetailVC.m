//
//  SSMineAllPerkDetailVC.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/8.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSMineAllPerkDetailVC.h"
#import "SSAllPerkDetailCell.h"
#import "SSPartnerItemModel.h"

@interface SSMineAllPerkDetailVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView      *perk_table;
@property (nonatomic, strong) NSMutableArray   *item_array;
@end

@implementation SSMineAllPerkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"明细"];
    [self.view addSubview:self.perk_table];
    [self feltData];
}

#pragma --tableDataSource--
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSAllPerkDetailCell *cell = [SSAllPerkDetailCell cellWithTableView:tableView];
    SSPartnerItemModel *model = self.item_array[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item_array.count;
}
#pragma --tableDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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

- (NSMutableArray *)item_array
{
    if (_item_array == nil) {
        _item_array = [[NSMutableArray alloc]init];
    }
    return _item_array;
}

- (void)feltData
{
    SSAccount *account = [SSAccountTool share].account;
    NSDictionary *paramsDic = @{@"phone":account.phone};
    [FZHttpTool post:UserRewardList parameters:paramsDic isShowHUD:YES httpToolSuccess:^(id json) {
        self.item_array = [SSPartnerItemModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.perk_table reloadData];
        
    } failure:^(NSError *error) {
        [ProgressHUD showSuccess:@"请求失败"];
    }];
}

- (UITableView *)perk_table
{
    if (!_perk_table) {
        _perk_table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight) style:UITableViewStylePlain];
        _perk_table.delegate = self;
        _perk_table.dataSource = self;
        _perk_table.emptyDataSetSource = self;
        _perk_table.emptyDataSetDelegate = self;
        _perk_table.mj_footer.automaticallyHidden = YES;
         _perk_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _perk_table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
