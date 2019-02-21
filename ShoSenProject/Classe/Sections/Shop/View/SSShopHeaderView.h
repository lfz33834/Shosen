//
//  SSShopHeaderView.h
//  ShoSenProject
//
//  Created by lifuzhou on 2018/12/10.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSShopHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *scroll_view;
@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END