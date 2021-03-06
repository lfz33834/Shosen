//
//  SSFlagsModel.h
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/26.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZBaseModel.h"

@interface SSFlagsModel : FZBaseModel

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *dicCode;
@property (nonatomic, strong) NSString *dicType;
@property (nonatomic, strong) NSString *dicValue;
@property (nonatomic, strong) NSString *sortNum;

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeValue;
@property (nonatomic, strong) NSString *userPhone;


@property (nonatomic, assign) BOOL  isSelect;

@end
