---
title: 消除 UINavigationBar 底部黑线
date: 2018-12-18 13:50:41
keywords:
- UINavigationBar
tags:
- UINavigationBar
categories:
- iOS
- 导航栏
description:
- 清除 UINavigationBar 底部黑线
---
### 1. 通过设置背景图片与阴影图片清除
```swift
// 在自定义 UINavigationController 内
self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
self.navigationBar.shadowImage = UIImage()
```
### 2. 通过遍历 UINavigationBar 子视图,找到对应的 View,设置为隐藏
```swift
extension UINavigationBar {

    func hideBottomHairline() {
        findUnderImageView(self)?.isHidden = true
    }

    func showBottomHairline() {
        findUnderImageView(self)?.isHidden = true
    }


    func findUnderImageView(_ view: UIView) -> UIImageView? {

        if view is UIImageView && view.bounds.height <= 1.0 {
            return view as? UIImageView
        }

        for subView in view.subviews {
            return self.findUnderImageView(subView)
        }
        return nil
    }
}
```
使用时只需在 viewWillAppear 方法中添加  ``` self.navigationController?.navigationBar.hideBottomHairline()```

