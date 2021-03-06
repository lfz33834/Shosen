//
//  SSOrderFooterView.h
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/14.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderFooterViewType)
{
    OrderFooterViewTypeBook,
    OrderFooterViewTypeOrderDetail,
    OrderFooterViewTypePSQLookIn,
};

typedef NS_ENUM(NSInteger,OrderFooterOperateType)
{
    OrderFooterOperateTypeCancel,
    OrderFooterOperateTypePay,
};

typedef void(^SSOrderFooterViewBlock)(OrderFooterOperateType type);

@interface SSOrderFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *book_button;
@property (weak, nonatomic) IBOutlet UIButton *left_button;
@property (weak, nonatomic) IBOutlet UILabel  *left_label;
@property (nonatomic, copy) SSOrderFooterViewBlock block;

@property (nonatomic, assign) OrderFooterOperateType operateType;
@property (nonatomic, assign) OrderFooterViewType vcType;

- (void)initWithViewWithType:(OrderFooterViewType)vcType operateType:(OrderFooterOperateType)operateType;

@end
