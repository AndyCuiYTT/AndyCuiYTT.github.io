---
title: iOS 判断网络连接状态的几种方法
date: 2016-09-11 09:22:56
keywords:
- Reachability
- AFNetwoking
- Alamofire
- 网络状态
tags:
- iOS
- network
- Reachability
- AFNetwoking
- Alamofire
categories:
- iOS
- 网络
description: iOS 开发过程中经常会用到判断网络连接状态的几种方法.
---

### Reachability

Apple 的官方例子 [Reachability](https://developer.apple.com/library/ios/#samplecode/Reachability/Introduction/Intro.html) 中介绍了获取、检测设备当前网络状态的方法。在你的程序中，需要把该工程中的Reachability.h 和 Reachability.m 拷贝到你的工程中，同时需要把 SystemConfiguration.framework 添加到工程中，

```Object-C
// 监听网络状态改变的通知
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];

// 创建Reachability
self.conn = [Reachability reachabilityForInternetConnection];
// 开始监控网络(一旦网络状态发生改变, 就会发出通知kReachabilityChangedNotification)
[self.conn startNotifier];

// 处理网络状态改变
- (void)networkStateChange {
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];

    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];

    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
    } else { // 没有网络
        NSLog(@"没有网络");
    }
}
```

### AFNetwoking

```Object-C
// 1.获得网络监控的管理者
AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];

// 2.设置网络状态改变后的处理
[mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
// 当网络状态改变了, 就会调用这个block
    switch (status) {
        case AFNetworkReachabilityStatusUnknown: // 未知网络
            NSLog(@"未知网络");
            break;

        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            NSLog(@"没有网络(断网)");
            break;

        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            NSLog(@"手机自带网络");
            break;

        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            NSLog(@"WIFI");
            break;
    }
}];

// 3.开始监控
[mgr startMonitoring];
```

### Alamofire
```swift
private func monitorNetwork() {

    if let manager = networkReachabilityManager {
    
        networkReachabilityManager?.listener = { (status) in
            switch status {
                case .notReachable:
                    // 无网络
                case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                    // wifi
                case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                    // 数据流量
                default:
                    // 未知
            }
    }
    networkReachabilityManager?.startListening()
}
```

### 通过状态栏获取网络类型

```Object-C
- (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];

            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5: {
                    state =  @"wifi";
                    break;
                    default:
                    break;
                }
            }
        }
        //根据状态选择
    }
    return state;
}
```

基本原理是从UIApplication类型中通过valueForKey获取内部属性 statusBar。然后筛选一个内部类型
（UIStatusBarDataNetworkItemView），最后返回他的 dataNetworkType属性，根据状态栏获取网络
状态，可以区分2G、3G、4G、WIFI，系统的方法，比较快捷，不好的是万一连接的WIFI 没有联网的话，
识别不到。
