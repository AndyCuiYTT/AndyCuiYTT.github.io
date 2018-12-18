---
title: 自定义 Navigation 返回按钮
date: 2018-08-21 10:27:52
keywords:
- navigation
- backBarButtonItem
tags:
- navigation
categories:
- iOS
- 导航栏
---
UINavigationController 是 iOS 开发中常用的空间,在开发中难免会遇到一些样式与我们需求不相符合,这里针对于返回按钮(backBarButtonItem)进行总结.
<!-- more -->
## 通过继承与 NavigationController 的子类实现自定义返回按钮
* 新建类继承与 UINavigationController
* 通过重写 pushViewController,方法设置返回按钮
```swift
override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if self.viewControllers.count > 0 {
        viewController.hidesBottomBarWhenPushed = true
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_nav_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
    }
    super.pushViewController(viewController, animated: true)
}
```
## 设置滑动返回
如果使用系统的返回按钮是有轻扫左边缘返回的操作的,如果设置了 leftBarButtonItem 滑动返回将消失.
* 设置 interactivePopGestureRecognizer 的代理为当前类
* 实现 gestureRecognizerShouldBegin 代理方法
```swift
func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return self.viewControllers.count > 1
}
```

