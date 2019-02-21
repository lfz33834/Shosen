//
//  SSRelationPhoneVC.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/20.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSRelationPhoneVC.h"
#import "SSRelationPhoneViewModel.h"
#import "UITextField+Extension.h"

@interface SSRelationPhoneVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pswTextfield;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) SSRelationPhoneViewModel *bindVM;

@end

@implementation SSRelationPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self initBindModel];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"关联手机号"];
    self.loginBtn.layer.cornerRadius = 5;
    self.phoneTextfield.delegate            = self;
    self.phoneTextfield.keyboardType        = UIKeyboardTypeNumberPad;
    self.pswTextfield.delegate              = self;
    self.pswTextfield.keyboardType          = UIKeyboardTypeNumberPad;
    
    self.codeBtn.enabled                    = NO;
    self.loginBtn.enabled                   = NO;
    
    [self.phoneTextfield setPlaceHolderColor:kColor(@"A2A2A2")];
    [self.pswTextfield setPlaceHolderColor:kColor(@"A2A2A2")];
}

- (void)initBindModel
{
    @weakify(self);
    RAC(self.bindVM,phoneNum) = self.phoneTextfield.rac_textSignal;
    RAC(self.bindVM,codeNum)  = self.pswTextfield.rac_textSignal;
 
    self.bindVM.nickName = self.name;
    self.bindVM.picUrl = self.headerImg;
    self.bindVM.openID = self.openID;
    
    RAC(self.loginBtn,enabled) = self.bindVM.canLoginSignal;
    RAC(self.codeBtn,enabled) = self.bindVM.canCodeSignal;
    
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [[self.bindVM.codeCommand execute:x]subscribeNext:^(id x) {
        }];
    }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.bindVM.loginCommand execute:x];
    }];
    [self.bindVM.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSDictionary *dicData = x;
        SSAccount *account = [SSAccount mj_objectWithKeyValues:dicData];
        [[SSAccountTool share]saveAccountData:[dicData mutableCopy]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginNotification" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [self.phoneTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.pswTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void) textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextfield){
        [textField validateTextFieldTextLengh:11];
    }else if (textField == self.pswTextfield){
        [textField validateTextFieldTextLengh:4];
    }
}

//- (IBAction)relationButtonTapAction:(UIButton *)sender {
//    [[FZRouteUrlTool share] setupAppRootCtrl:[[FZMainTabBarController alloc]init]];
//}

- (SSRelationPhoneViewModel *)bindVM
{
    if (_bindVM == nil) {
        _bindVM = [[SSRelationPhoneViewModel alloc]init];
    }
    return _bindVM;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end