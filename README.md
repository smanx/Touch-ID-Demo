####引入指纹解锁必须的头文件

```
#import <LocalAuthentication/LocalAuthentication.h>
```

####判断设备是否支持TouchID
```
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error __attribute__((swift_error(none)));
```

####弹出框出来验证TouchID,Block返回成功和失败
```
- (void)evaluatePolicy:(LAPolicy)policy localizedReason:(NSString *)localizedReason reply:(void(^)(BOOL success, NSError * __nullable error))reply;
```

######验证的例子
```
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
```


####几种返回的错误的枚举值
```
typedef NS_ENUM(NSInteger, LAError)
 { 
     //授权失败  
     LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed, 

     //用户取消Touch ID授权  
     LAErrorUserCancel = kLAErrorUserCancel, 

     //用户选择输入密码  
     LAErrorUserFallback = kLAErrorUserFallback, 

     //系统取消授权(例如其他APP切入)  
     LAErrorSystemCancel = kLAErrorSystemCancel, 

     //系统未设置密码  
     LAErrorPasscodeNotSet =kLAErrorPasscodeNotSet, 

     //设备Touch ID不可用，例如未打开  
     LAErrorTouchIDNotAvailable = kLAErrorTouchIDNotAvailable, 

     //设备Touch ID不可用，用户未录入  
     LAErrorTouchIDNotEnrolled = kLAErrorTouchIDNotEnrolled, } NS_ENUM_AVAILABLE(10_10, 8_0);
}
```
