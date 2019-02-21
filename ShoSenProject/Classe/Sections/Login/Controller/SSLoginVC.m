


//
//  SSLoginVC.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/6.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSLoginVC.h"
#import "SSLoginViewModel.h"
#import "SSUMShareTool.h"
#import "SSRelationPhoneVC.h"
#import "UITextField+Extension.h"
//需要引入的头文件和库
//#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"


@interface SSLoginVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *psdTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) SSLoginViewModel *loginViewModel;
@property (weak, nonatomic) IBOutlet UILabel *service_label;

@end

@implementation SSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setLeftItemNull];
    [self initUI];
    [self initBindModel];
    

    //判断安装微信
    if ([WXApi isWXAppInstalled]){
        //安装了微信的处理
        self.wechat_button.hidden = NO;
    } else {
        //没有安装微信的处理
        self.wechat_button.hidden = YES;
    }
    
    
    [SSPayTool share].block = ^(id obj) {
        NSString *headimgurl = obj[@"headimgurl"];
        NSString *nickName = obj[@"nickname"];
        NSString *openId = obj[@"openid"];
        [self wechatLoginWithImageUrl:headimgurl name:nickName openID:openId];
    };
    
    self.service_label.attributedText = [NSMutableAttributedString attributeStringWithFont1:[UIFont systemFontOfSize:14] color1:kColor(@"666666") Font2:[UIFont systemFontOfSize:14] color2:kColor(@"D6B35B") text1:@"我已阅读并同意" text2:@"《MAXMaker购车服务条款》"];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"登录";
    self.loginBtn.layer.cornerRadius = 5;
    self.phoneTextField.delegate            = self;
    self.phoneTextField.keyboardType        = UIKeyboardTypeNumberPad;
    self.psdTextField.delegate              = self;
    self.psdTextField.keyboardType          = UIKeyboardTypeNumberPad;
    
    self.codeBtn.enabled                    = NO;
    self.loginBtn.enabled                   = NO;
    
    [self.phoneTextField setPlaceHolderColor:kColor(@"A2A2A2")];
    [self.psdTextField setPlaceHolderColor:kColor(@"A2A2A2")];

 }

- (void)initBindModel
{
    @weakify(self);
    RAC(self.loginViewModel,phoneNum) = self.phoneTextField.rac_textSignal;
    RAC(self.loginViewModel,codeNum)  = self.psdTextField.rac_textSignal;
    RAC(self.loginBtn,enabled) = self.loginViewModel.canLoginSignal;
    RAC(self.codeBtn,enabled) = self.loginViewModel.canCodeSignal;
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [[self.loginViewModel.codeCommand execute:x]subscribeNext:^(id x) {
            }];
     }];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
             [self.loginViewModel.loginCommand execute:x];
     }];
 [self.loginViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSDictionary *dicData = x;
//     SSAccount *account = [SSAccount mj_objectWithKeyValues:dicData];
     [[SSAccountTool share]saveAccountData:[dicData mutableCopy]];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginNotification" object:nil];
     if (self.navigationController.topViewController == self) {
         if (self.block) {
             self.block();
         }
         if (self.fromVC == SSLoginVCFromSetting) {
             [self.navigationController popToRootViewControllerAnimated:YES];
         }else{
             [self.navigationController popViewControllerAnimated:YES];
         }
     } else {
         [self dismissViewControllerAnimated:YES completion:nil];
     }
 }];
    
    [self.phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.psdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

-(void) textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTextField){
        [textField validateTextFieldTextLengh:11];
    }else if (textField == self.psdTextField){
        [textField validateTextFieldTextLengh:4];
    }
}

- (SSLoginViewModel *)loginViewModel
{
    if (_loginViewModel == nil) {
        _loginViewModel = [[SSLoginViewModel alloc]init];
    }
    return _loginViewModel;
}
- (IBAction)wechatButtonTapLogin:(UIButton *)sender {
    [[SSPayTool share] getAuthWithUserInfoFromWechat:self callBack:^(NSDictionary *dicData) {
       
    }];
}
- (IBAction)infoButtonTapAction:(UIButton *)sender {
    
    FZWebViewController *webVC = [[FZWebViewController alloc]init];
    webVC.title = @"X商务社区用户协议";
     webVC.loadUrl = @"https://api.shosen.cn/news/usernote.html";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)wechatLoginWithImageUrl:(NSString *)imageUrl name:(NSString *)nickName openID:(NSString *)openID
{
    NSDictionary *params = @{@"openId":openID};
    [FZHttpTool post:UserLoginWechatUrl parameters:params isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        if ([json[@"code"] intValue] == 997)//未绑定
        {
            SSRelationPhoneVC *bindVC = [[SSRelationPhoneVC alloc]init];
            bindVC.openID = openID;
            bindVC.headerImg = imageUrl;
            bindVC.name = nickName;
            [self.navigationController pushViewController:bindVC animated:YES];
        }else if ([json[@"code"] intValue] == 100)
        {
            NSDictionary *dicData = json[@"data"];
            SSAccount *account = [SSAccount mj_objectWithKeyValues:dicData];
            [[SSAccountTool share]saveAccountData:[dicData mutableCopy]];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginNotification" object:nil];
            if (self.navigationController.topViewController == self) {
                if (self.block) {
                    self.block();
                }
                if (self.fromVC == SSLoginVCFromSetting) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

@end