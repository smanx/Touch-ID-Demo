//
//  ViewController.m
//  Touch ID Demo
//
//  Created by ZC on 16/11/4.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self authenticateUser];
    
}
- (void)authenticateUser
{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
            }
            else
            {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
//    //授权失败
//    LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
//    
//    //用户取消Touch ID授权
//    LAErrorUserCancel           = kLAErrorUserCancel,
//    
//    //用户选择输入密码
//    LAErrorUserFallback         = kLAErrorUserFallback,
//    
//    //系统取消授权(例如其他APP切入)
//    LAErrorSystemCancel         = kLAErrorSystemCancel,
//    
//    //系统未设置密码
//    LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
//    
//    //设备Touch ID不可用，例如未打开
//    
//    LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
//    
//    //设备Touch ID不可用，用户未录入
//    LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
}


@end
