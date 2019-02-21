//
//  SSCircleFriendsCell.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/30.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSCircleFriendsCell.h"
#import "SSCircleListImageCell.h"
#import "SSCircleListModel.h"

@interface SSCircleFriendsCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SSCircleFriendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.moreFriend_button addTarget:self action:@selector(moreFriendTapAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    self.moreFriend_collection.scrollEnabled = NO;
    //第二个参数是cell的布局
    self.moreFriend_collection.collectionViewLayout = flowLayout;
    self.moreFriend_collection.dataSource = self;
    self.moreFriend_collection.delegate = self;
    self.moreFriend_collection.backgroundColor = [UIColor whiteColor];
    self.moreFriend_collection.scrollEnabled = NO;
    UINib *nib = [UINib nibWithNibName:@"SSCircleListImageCell" bundle: [NSBundle mainBundle]];
    [self.moreFriend_collection registerNib:nib forCellWithReuseIdentifier:@"SSCircleListImageCell"];
}

- (void)moreFriendTapAction
{
    if (self.block) {
        self.block(nil,SSCircleFriendsCellTypeFinder);
    }
}

- (void)initCellWithDataArray:(NSMutableArray *)dataArray
{
    self.dataArray = dataArray;
    [self.moreFriend_collection reloadData];
}

- (void)setCellType:(SSCircleFriendsCellType)cellType
{
    _cellType = cellType;
    if (cellType == SSCircleFriendsCellTypeFinder) {
        _bottomview_height.constant = 65;
        _title_label.text = @"好友推荐";
    }else if (cellType == SSCircleFriendsCellTypeSelfUserInfo)
    {
        _bottomview_height.constant = 0;
        _title_label.text = @"我关注的好友";
    }else if (cellType == SSCircleFriendsCellTypeOtherUserInfo)
    {
        _bottomview_height.constant = 0;
        _title_label.text = @"他关注的好友";
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSCircleListImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SSCircleListImageCell" forIndexPath:indexPath];
    SSCircleListModel *model = self.dataArray[indexPath.row];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"mine_header_normal"]];
    cell.layer.cornerRadius = (kwidth - 30- 10*5)/6/2;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSCircleListModel *model = self.dataArray[indexPath.row];
    if (self.block) {
        self.block(model,SSCircleFriendsCellTypeOtherUserInfo);
    }
    NSLog(@"%d %d", (int)indexPath.section, (int)indexPath.row);
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell 的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat with = (kwidth - 30- 10*5)/6;
    return CGSizeMake(with, with);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end