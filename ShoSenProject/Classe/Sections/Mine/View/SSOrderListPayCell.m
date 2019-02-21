//
//  SSOrderListPayCell.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/14.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSOrderListPayCell.h"

@implementation SSOrderListPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.paycell_view.layer.cornerRadius = 5;
    self.paycell_view.layer.shadowColor= kColor(@"333333").CGColor;
    self.paycell_view.layer.shadowOpacity=0.15;
    [self.paycell_view.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.paycell_view.bounds] CGPath]];
    self.paycell_view.layer.shadowRadius = 5.0;//半径
    self.paycell_view.layer.shadowOffset = CGSizeMake(5, 5);
    
    [self.header_imageview sd_setImageWithURL:[NSURL URLWithString:@"https://api.shosen.cn/wx/images/reservation/banner.png"] placeholderImage:[UIImage imageNamed:@"home_confirm_bg"]];
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
- (IBAction)payButtonTapAction:(UIButton *)sender {
    self.block(self.listModel);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end