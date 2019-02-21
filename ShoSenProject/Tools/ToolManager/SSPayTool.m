//
//  SSPayTool.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/28.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "SSPayTool.h"
#import "WXApi.h"
#import "FZRouteUrlTool.h"
#import "SSPaySuccessVC.h"
#import "SSPayFailureVC.h"
//#import "SSRechargeVC."

@interface SSPayTool ()

@end

@implementation SSPayTool

static SSPayTool * tools = nil;
+(instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[SSPayTool alloc]init];
    });
    return tools;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)initWechat
{
    [WXApi registerApp:kWechatAppID];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliPayresult:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliAuthResult:resultDic];
        }];
    }
    if ([url.scheme isEqualToString:kWechatAppID] || [url.scheme isEqualToString:kXiaoChengXuAppID])
    {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // 其他如支付等SDK的回调
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliPayresult:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliAuthResult:resultDic];
        }];
    }
    if ([url.scheme isEqualToString:kWechatAppID] || [url.scheme isEqualToString:kXiaoChengXuAppID])
    {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliPayresult:resultDic];
        }];
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self aliAuthResult:resultDic];
        }];
    }else  if ([url.scheme isEqualToString:kWechatAppID] || [url.scheme isEqualToString:kXiaoChengXuAppID])
    {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}
#pragma mark - 微信 阿里 支付 -
-(void)weixinPay:(NSDictionary *)paramDic result:(payToolsBlock)block
{
    self.toolBlock = block;
    if (paramDic) {
        PayReq *req = [[PayReq alloc] init];
        req.openID = kWechatAppID;
        req.partnerId = paramDic[@"partnerid"];
        req.prepayId  = paramDic[@"prepayid"];
        req.package  = paramDic[@"package"];
        req.nonceStr  = paramDic[@"noncestr"];
        NSString * stamp = paramDic[@"timestamp"];
        req.timeStamp = stamp.intValue;
        req.sign = paramDic[@"sign"];
        [WXApi sendReq:req];
    }
}
-(void)aliPay:(NSString *)paramStr result:(payToolsBlock)block
{
    self.toolBlock = block;
    [[AlipaySDK defaultService] payOrder:paramStr fromScheme:kAlipaySchemes callback:^(NSDictionary *resultDic) {
    }];
}
#pragma mark - 微信 阿里 授权 -
-(void)weixinAuth:(payToolsBlock)block
{
    self.toolBlock = block;
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = [NSString stringWithFormat:@"%u",arc4random()%1000];
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
-(void)aliPayAuth:(payToolsBlock)block
{
    self.toolBlock = block;
    [FZHttpTool post:@"" parameters:nil httpToolSuccess:^(id  _Nullable json) {
        if (json) {
            [self aliPayInfo:json];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)aliPayInfo:(NSString *)paramStr
{
    [[AlipaySDK defaultService] auth_V2WithInfo:paramStr fromScheme:kAlipaySchemes callback:^(NSDictionary *resultDic) {
        if (resultDic) {
            //回调失败
        }
    }];
}
- (void)processAuthResult:(NSURL *)resultUrl standbyCallback:(CompletionBlock)completionBlock
{
    [[AlipaySDK defaultService] processAuth_V2Result:resultUrl standbyCallback:^(NSDictionary *resultDic) {
        [self aliAuthResult:resultDic];
    }];
}
#pragma mark - 授权回调 -
//支付宝授权回调
- (void)aliAuthResult:(NSDictionary *)paramDic
{
    if (paramDic) {
        NSInteger codeVal = [[NSString stringWithFormat:@"%@",paramDic[@"resultStatus"]] integerValue];
        if (codeVal == 9000) {
            NSString * resultStr = [NSString stringWithFormat:@"%@",paramDic[@"result"]];
            NSDictionary * tempDic = [self jsonDic:resultStr];
            if (tempDic && tempDic.count > 0) {
                if (self.toolBlock) {
                    self.toolBlock(tempDic);
                }
            }
        }
    }
}
//支付宝支付回调
- (void)aliPayresult:(NSDictionary *)paramDic
{
    if (paramDic && paramDic.count > 0) {
        NSString * resultStatus = [NSString stringWithFormat:@"%@",paramDic[@"resultStatus"]];
        if ([resultStatus isEqualToString:@"9000"]) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccess" object:nil];
            if (self.toolBlock) {
                self.toolBlock(@"成功");
            }
        }else if ([resultStatus isEqualToString:@"6001"]){
            if (self.toolBlock) {
                self.toolBlock(@"取消");
            }
            [ProgressHUD showError:paramDic[@"memo"]];
        }
        else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"PayFailure" object:nil];
            if (self.toolBlock) {
                self.toolBlock(@"失败");
            }
        }
    }
}
//微信回调,有支付结果的时候会回调这个方法
- (void)onResp:(BaseResp *)resp
{
    //支付结果回调
    if([resp isKindOfClass:[PayResp class]]){
        switch (resp.errCode) {
            case WXSuccess:{
                //支付返回结果，实际支付结果需要去自己的服务器端查询
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccess" object:nil];
                if (self.toolBlock) {
                    self.toolBlock(@"成功");
                }
                break;
            }
            case WXErrCodeUserCancel:{
                if (self.toolBlock) {
                    self.toolBlock(@"取消");
                }
                break;
            }
            default:{
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"PayFailure" object:nil];
                if (self.toolBlock) {
                    self.toolBlock(@"失败");
                }
                break;
            }
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp * authResp = (SendAuthResp *)resp;
        switch (resp.errCode) {
            case WXSuccess:
                [self accessTokenAction:authResp.code];
                break;
            default:
                [ProgressHUD showError:@"授权失败"];
                break;
        }
    }
}
#pragma mark - weixin methods -
- (void)accessTokenAction:(NSString *)codeStr
{
    NSString * urlStr= [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWechatAppID,kWechatAppSecret,codeStr];
    [FZHttpTool get:urlStr parameters:nil isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        if (json) {
            NSString * refreshToken = json[@"refresh_token"];
            [self refreshToken:refreshToken];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)refreshToken:(NSString *)refreshToken
{
    NSString * urlStr= [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",kWechatAppID,refreshToken];
  
    [FZHttpTool get:urlStr parameters:nil isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        if (json) {
            NSString * accessToken = json[@"access_token"];
            NSString * openId = json[@"openid"];
            [self reqeustUserInfo:openId accessToken:accessToken];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
- (void)reqeustUserInfo:(NSString *)openId accessToken:(NSString *)accessToken
{
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    [FZHttpTool get:urlStr parameters:nil isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        if (json) {
            self.block(json);
           }
    } failure:^(NSError * _Nullable error) {
        [ProgressHUD showError:@"授权失败"];
    }];
   
}
- (NSDictionary *)jsonDic:(NSString *)paramStr
{
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (paramStr.length > 0){
        NSArray * tempArr = [paramStr componentsSeparatedByString:@"&"];
        if (tempArr && tempArr.count > 0){
            for (int i = 0; i < tempArr.count; i++){
                NSString * tempStr = tempArr[i];
                if (tempStr.length > 0) {
                    NSArray * detailArr = [tempStr componentsSeparatedByString:@"="];
                    if (detailArr.count > 0) {
                        [tempDic setObject:detailArr[1] forKey:detailArr[0]];
                    }
                }
            }
            
        }
    }
    return tempDic;
}

//微信支付
- (void)wechatPayWithID:(NSString *)bookID
{
    [FZHttpTool post:UserWechatBookUrl parameters:@{@"bookId":bookID} isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        
        [self weixinPay:json[@"data"] result:^(id obj) {
            if ([obj isEqualToString:@"成功"]) {
                SSPaySuccessVC *successVC = [[SSPaySuccessVC alloc]init];
                [[[FZRouteUrlTool share]getCurrentVC].navigationController pushViewController:successVC animated:YES];
            }else if ([obj isEqualToString:@"取消"])
            {
                self.block(@"取消");
                [ProgressHUD showSuccess:@"支付取消"];
            }else if ([obj isEqualToString:@"失败"])
            {
                SSPayFailureVC *successVC = [[SSPayFailureVC alloc]init];
                [[[FZRouteUrlTool share]getCurrentVC].navigationController pushViewController:successVC animated:YES];
            }
        }];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

//支付宝支付
- (void)aliPayWithID:(NSString *)bookID
{
    [FZHttpTool post:UserAlipayBookUrl parameters:@{@"bookId":bookID} isShowHUD:YES  httpToolSuccess:^(id  _Nullable json) {
        
        [self aliPay:json[@"data"][@"payStr"] result:^(id obj) {
            if ([obj isEqualToString:@"成功"]) {
                SSPaySuccessVC *successVC = [[SSPaySuccessVC alloc]init];
                [[[FZRouteUrlTool share]getCurrentVC].navigationController pushViewController:successVC animated:YES];
            }else if ([obj isEqualToString:@"取消"])
            {
                self.block(@"取消");
                [ProgressHUD showSuccess:@"支付取消"];
            }else if ([obj isEqualToString:@"失败"])
            {
                SSPayFailureVC *successVC = [[SSPayFailureVC alloc]init];
                [[[FZRouteUrlTool share]getCurrentVC].navigationController pushViewController:successVC animated:YES];
            }
        }];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

//支付宝充值
- (void)aliRechargeWithOrderNo:(NSString *)orderNo
{
    [FZHttpTool post:kAliReChargeMoney parameters:@{@"orderNo":orderNo} isShowHUD:YES  httpToolSuccess:^(id  _Nullable json) {
        
        [self aliPay:json[@"data"][@"payStr"] result:^(id obj) {
            if ([obj isEqualToString:@"成功"]) {
                self.block(@"成功");
            }else if ([obj isEqualToString:@"取消"])
            {
                self.block(@"取消");
                [ProgressHUD showSuccess:@"支付取消"];
            }else if ([obj isEqualToString:@"失败"])
            {
                self.block(@"失败");
            }
        }];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

//微信充值
- (void)wechatRechargeWithOrderNo:(NSString *)orderNo
{
    [FZHttpTool post:kWechatReChargeMoney parameters:@{@"orderNo":orderNo} isShowHUD:YES httpToolSuccess:^(id  _Nullable json) {
        
        [self weixinPay:json[@"data"] result:^(id obj) {
            if ([obj isEqualToString:@"成功"]) {
                self.block(@"成功");
            }else if ([obj isEqualToString:@"取消"])
            {
                self.block(@"取消");
                [ProgressHUD showSuccess:@"支付取消"];
            }else if ([obj isEqualToString:@"失败"])
            {
                self.block(@"失败");
            }
        }];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}


//- (void)returnPurseVC
//{
//    FZMainTabBarController *tabVC = (FZMainTabBarController *)FZAppDelegate.window.rootViewController;
//    FZNavigationController *nav = (FZNavigationController *)[tabVC.childViewControllers objectAtIndex:tabVC.selectedIndex];
//    for (UIViewController *vc in nav.childViewControllers) {
//        if ([vc isKindOfClass:[SSRechargeVC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    [tabVC setSelectedIndex:4];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    SSRechargeVC *listVC = [[SSRechargeVC alloc]init];
//    [[[FZRouteUrlTool share]getCurrentVC].navigationController pushViewController:listVC animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
//}

//第三方登录
- (void)getAuthWithUserInfoFromWechat:(UIViewController *)shareVC callBack:(void(^)(NSDictionary *dicData))block
{
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
        //        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        //            if (error) {
        //
        //            } else {
        //                UMSocialUserInfoResponse *resp = result;
        //
        //                // 授权信息
        //                NSLog(@"Wechat uid: %@", resp.uid);
        //                NSLog(@"Wechat openid: %@", resp.openid);
        //                NSLog(@"Wechat unionid: %@", resp.unionId);
        //                NSLog(@"Wechat accessToken: %@", resp.accessToken);
        //                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
        //                NSLog(@"Wechat expiration: %@", resp.expiration);
        //
        //                // 用户信息
        //                NSLog(@"Wechat name: %@", resp.name);
        //                NSLog(@"Wechat iconurl: %@", resp.iconurl);
        //                NSLog(@"Wechat gender: %@", resp.unionGender);
        //
        //                // 第三方平台SDK源数据
        //                NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        //            }
        //        }];
    }else {
        [self setupAlertController];
    }
}

#pragma mark - 设置弹出提示语

- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:actionConfirm];
    
    [[[FZRouteUrlTool share]getCurrentVC] presentViewController:alert animated:YES completion:nil];
    
}

@end