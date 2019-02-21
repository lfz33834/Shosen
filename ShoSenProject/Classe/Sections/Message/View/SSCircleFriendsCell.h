//
//  SSCircleFriendsCell.h
//  ShoSenProject
//
//  Created by lifuzhou on 2018/10/30.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSCircleListModel.h"

typedef NS_ENUM(NSInteger,SSCircleFriendsCellType)
{
    SSCircleFriendsCellTypeFinder,
    SSCircleFriendsCellTypeSelfUserInfo,
    SSCircleFriendsCellTypeOtherUserInfo,

};


typedef void(^SSCircleFriendsCellBlock)(SSCircleListModel* model,SSCircleFriendsCellType tapType);

@interface SSCircleFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *moreFriend_button;
@property (weak, nonatomic) IBOutlet UICollectionView *moreFriend_collection;

@property (nonatomic, assign) SSCircleFriendsCellType cellType;
@property (nonatomic, copy) SSCircleFriendsCellBlock block;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomview_height;

- (void)initCellWithDataArray:(NSMutableArray *)dataArray;

@end