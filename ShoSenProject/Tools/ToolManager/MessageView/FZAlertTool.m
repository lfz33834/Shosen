
//
//  FZAlertTool.m
//  ShoSenProject
//
//  Created by lifuzhou on 2018/9/5.
//  Copyright © 2018年 lifuzhou. All rights reserved.
//

#import "FZAlertTool.h"

@implementation FZAlertTool

+(instancetype)share
{
    static FZAlertTool * tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FZAlertTool alloc]init];
    });
    return tools;
}

- (void)alertView:(NSString *)titleStr message:(NSString *)messageStr cancelTitle:(NSString *)cancelTitle confirm:(NSString *)confirmStr resultBlock:(WCNoticeAlertViewBlock)block
{
    WCNoticeAlertView *alertView = [[WCNoticeAlertView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
    alertView.dicData = @{@"title":titleStr,@"content":messageStr,@"cancel":cancelTitle,@"confirm":confirmStr};
    alertView.block = ^(WCNoticeAlertViewType type) {
        if(block) {
            block(type);
        }
    };
    [alertView  showNoticeView];
}

-(void)showAlertView:(UIViewController *)viewController title:(NSString *)title mes:(NSString *)message cancelBnt:(NSString *)cancelButtonTitle otherBnt:(NSString *)otherButtonTitle :(void (^)(void))confirm :(void (^)(void))cancle{
    [ShowMes stop];
    confirmParam=confirm;
    cancleParam=cancle;
    if (message == nil || [message isEqualToString:@""]) {
        return;
    }
    if (ios_system>=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        if(cancelButtonTitle){
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                cancle();
            }];
            [alertController addAction:cancelAction];
        }
        if(otherButtonTitle){
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                confirm();
            }];
            [alertController addAction:otherAction];
        }
        if(otherButtonTitle==nil){
            float delay = message.length/5+2;
            [self performSelector:@selector(dimissAlert:) withObject:alertController afterDelay:delay];
        }
        // Add the actions.
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:otherButtonTitle otherButtonTitles:cancelButtonTitle,nil];
        [TitleAlert show];
        if(otherButtonTitle==nil){
            float delay = message.length/5+2;
            [self performSelector:@selector(dimissAlert1:) withObject:TitleAlert afterDelay:delay];
        }
    }
}

- (void)dimissAlert:(UIAlertController*)sender{
    if(sender){
        [sender dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
- (void)dimissAlert1:(UIAlertView *)alert {
    if(alert){
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        confirmParam();
    }
    else{
        cancleParam();
    }
}

+ (UIAlertController *)showActionSheetWithCurrentController:(UIViewController *)paramVC  withTitle:(NSString *)paramTitle withMessage:(NSString *)messageString withUIAlertControllerStyle:(UIAlertControllerStyle)style withOtherBtnTitle:(NSArray *)otherArr cancelHidden:(BOOL)state result:(void (^)(NSString * paramNavWayStr))result
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:paramTitle message:messageString preferredStyle:style];
    NSString * tempStr = @"好";
    if (otherArr && otherArr.count > 0) {
        tempStr = @"取消";
        for (int i = 0; i < otherArr.count; i++) {
            NSString * tempStr = [otherArr objectAtIndex:i];
            UIAlertAction * action = [UIAlertAction actionWithTitle:tempStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (action) {
                    result(action.title);
                }
            }];
            [alertVC addAction:action];
        }
    }
    if (state) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:tempStr style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (action) {
                result(action.title);
            }
        }];
        [alertVC addAction:cancelAction];
    }
    if (paramVC) {
        [paramVC presentViewController:alertVC animated:YES completion:nil];
    }
    return alertVC;
}


-(void)loadingAnimation:(BOOL)state
{
    [MBProgressHUD hideAllHUDsForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    if (state) {
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
    }
}

@end