---
title: 禁止 UIButton 连续点击
date: 2018-09-10 10:24:19
keywords:
- runtime
- UIButton重复点击
tags:
- runtime
- swift
categories:
- iOS
- 总结
---
UIButton是我们iOS开发中常用的控件，连续／抖动点击造成数据请求或其它操作重复执行也是用户使用中常发生的 !解决这一问题的方法很多,简单总结了一下.
<!-- more -->
## 使用UIButton的enabled或userInteractionEnabled
使用UIButton的enabled属性,点击后将enabled设置为 false, 进行任务处理,完成任务后再将其设置为 false.
```swift
@objc func btnClick(_ sender: UIButton) {
    sender.isEnabled = false
    // 网络请求
    // 数据处理
    // ....
    sender.isEnabled = true        
}
```

## runtime 对 sendAction:to:forEvent: 进行处理
添加 UIButton 的分类,在其分类进行处理,对全局 UIButton 有效
自定义 ytt_sendAction(_ action:  to:, for event:) 方法,对点击进行处理,利用 runtime 进行方法交换.
swift 取消了 load 方法,具体实现方法交换参考[swift下使用runtime交换方法的实现](https://www.jianshu.com/p/335ba236b56a)
```swift
private var UIButton_acceptEventTime: Void?
private var UIButton_acceptInterval: Void?

extension UIButton: YTTExtensionProtocol {

    static func awake() {
        if let oldMethod = class_getInstanceMethod(self, #selector(sendAction(_:to:for:))), let newMethod = class_getInstanceMethod(self, #selector(ytt_sendAction(_:to:for:))) {
            method_exchangeImplementations(oldMethod, newMethod)
        }
    }

    // 连续点击时间间隔
    var acceptEventInterval: TimeInterval {
        get {
            if let time = objc_getAssociatedObject(self, &UIButton_acceptInterval) as? TimeInterval {
                return time
            } else {
                objc_setAssociatedObject(self, &UIButton_acceptInterval, 1, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return 1
            }
        }
        set {
            objc_setAssociatedObject(self, &UIButton_acceptInterval, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // 上次点击时间
    private var acceptEventTime: TimeInterval {
        get {
            if let time = objc_getAssociatedObject(self, &UIButton_acceptEventTime) as? TimeInterval {
                return time
            } else {
                objc_setAssociatedObject(self, &UIButton_acceptEventTime, 0, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return 0
            }
        }
        set {
            objc_setAssociatedObject(self, &UIButton_acceptEventTime, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func ytt_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if Date().timeIntervalSince1970 - self.acceptEventTime >= acceptEventInterval {
            self.ytt_sendAction(action, to: target, for: event)
            acceptEventTime = Date().timeIntervalSince1970
        }
    }
}
```
下载文件[UIButton+YTT](UIButton+YTT.zip),将两个文件拖入到工程,添加 AppDelegate 扩展:
```swift
extension UIApplication {
    private static let runOnce: Void = {
        YTTExtensionManager.harmlessFunction()
    }()

    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
```
