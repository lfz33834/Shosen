
//
//  SSOrderFooterView.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/14.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSOrderFooterView.h"

@implementation SSOrderFooterView

- (void)initWithViewWithType:(OrderFooterViewType)vcType operateType:(OrderFooterOperateType)operateType
{
    self.vcType = vcType;
    self.operateType = operateType;
    if (vcType == OrderFooterViewTypeOrderDetail) {
        self.left_label.text = @"取消订单";
        self.left_button.enabled = YES;
        [self.book_button setTitle:@"继续支付" forState:UIControlStateNormal];
    }else if (vcType == OrderFooterViewTypeBook)
    {
        NSString *moneyStr  = [NSString stringWithFormat:@"￥%@",[[NSUserDefaults standardUserDefaults]objectForKey:KConfigNoticeKey]];
        [self.book_button setTitle:@"立即预订" forState:UIControlStateNormal];
        self.left_button.enabled = NO;
        self.left_label.attributedText = [NSMutableAttributedString attributeStringWithFont1:[UIFont systemFontOfSize:14] color1:kColor(@"666666") Font2:[UIFont systemFontOfSize:17] color2:kColor(@"F95959") text1:@"预订价格 " text2:moneyStr?moneyStr:@"$25000"];
    }else if (vcType == OrderFooterViewTypePSQLookIn)
    {
        self.left_label.text = @"跳过此步";
        self.left_button.enabled = YES;
        [self.book_button setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

- (IBAction)leftButtonTap:(UIButton *)sender {
    
     self.block(OrderFooterOperateTypeCancel);
 }
- (IBAction)bookButtonTap:(UIButton *)sender {
    self.block(OrderFooterOperateTypePay);
}



@end