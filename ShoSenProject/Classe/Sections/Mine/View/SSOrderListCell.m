//
//  SSOrderListCell.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/14.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSOrderListCell.h"

@implementation SSOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bg_view.layer.cornerRadius = 5;
    self.bg_view.layer.shadowColor= kColor(@"333333").CGColor;
    self.bg_view.userInteractionEnabled=YES;
    self.bg_view.layer.shadowOpacity=0.15;
    [self.bg_view.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bg_view.bounds] CGPath]];
    self.bg_view.layer.shadowRadius = 5.0;//半径
    self.bg_view.layer.shadowOffset = CGSizeMake(5, 5);
}

- (void)setListModel:(SSOrderListModel *)listModel
{
    _listModel = listModel;
//    1:接收预定2:己缴预定款3:己缴全款4:取消定单5:删除定单'
    if ([listModel.bookStatus intValue] == 1) {
        _status_label.text = @"待支付";
    }else if ([listModel.bookStatus intValue] == 2)
    {
        _status_label.text = @"交易成功";
    }else if ([listModel.bookStatus intValue] == 3)
    {
        _status_label.text = @"已缴全款";
    }else if ([listModel.bookStatus intValue] == 4)
    {
        _status_label.text = @"交易关闭";
    }
    _title_label.text = [NSString stringWithFormat:@"预订价格:￥%@",listModel.bookMoney];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end