---
title: swift 带复制功能的 Label
date: 2018-08-30 15:09:16
keywords:
- copy
- label
tags:
- 自定义视图
- swift
categories:
- iOS
- 自定义视图
---
产品需求需要对 UILabel 展示的文本进行复制操作,针对这一需求想出了两种实现方式: 1.自定义控件,添加复制功能. 2.使用 UItextView 实现.
<!-- more -->
## 通过自定义 UILabel 的子类实现
* 创建 YTTCopyLabel, 使其继承于 UILabel.
```swift
class YTTCopyLabel: UILabel {
}
```

* 使 YTTCopyLabel 可以进行交互, 添加长按手势使其触发复制事件
```swift

override var canBecomeFirstResponder: Bool { return true }

override func awakeFromNib() {
    super.awakeFromNib()
    setup()
}

override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
}

private func setup() {
    self.isUserInteractionEnabled = true
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
    self.addGestureRecognizer(longPressGestureRecognizer)
}
```

* 在长按事件中实现复制功能
*使用 UIMenuController 弹出复制菜单.[使用简介](https://www.jianshu.com/p/71076f65835d)*
```swift
@objc private func longPressAction(_ sender: UIGestureRecognizer) {

    guard sender.state == .began else {
    return
    }

    // 变为第一响应者
    self.becomeFirstResponder()

    // 菜单控制器
    let menuController = UIMenuController.shared
    // 复制 item
    let copyItem = UIMenuItem(title: "复制", action: #selector(copyText))
    // 添加 item 到 menu 控制器
    menuController.menuItems = [copyItem]
    // 设置菜单控制器点击区域为当前控件 bounds
    menuController.setTargetRect(self.bounds, in: self)
    // 菜单显示器可见
    menuController.setMenuVisible(true, animated: true)

}
```
* 确认 label 具有的操作能力
```swift
override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(copyText) {
        return true
    }
    return false
}
```

* 实现将 label 内容放到剪切板
```swift
@objc private func copyText() {
    UIPasteboard.general.string = self.text
}
```

* 在需要的地方使用
```swift
let label = YTTCopyLabel(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 30))
```

运行效果如下:
![copyLabel](YTTCopyLabel.PNG)
[YTTCopyLabel.swift](YTTCopyLabel.zip)

## 通过设置 UITextView 的属性实现
UITextView 本身就有复制的功能,他有两个属性，一个可控制其是否编辑，一个是可控制其是否可选,只需将其可编辑设为 false
```swift
isEditable = false
```
* 创建 YTTCustomTextView,使其继承与 UITextView
```swift
class YTTCustomTextView: UITextView {
}
```
* 重写父类方法,使其使其编辑功能
```swift
@IBInspectable
var isAutoLayout: Bool = true  // 是否是自适应布局

override func awakeFromNib() {
    super.awakeFromNib()
    setup()
}

override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setup()
}

private func setup() {
    self.isEditable = false
    self.isScrollEnabled = false // 设为 false 可自适应
}
```
* 重写属性 text 与 attributedText, 进行自适应布局
```swift
override var text: String! {
    get {
        return super.text
    }
    set {
        super.text = newValue
        if !isAutoLayout {
            let width = self.bounds.width - (self.contentInset.left + self.contentInset.right + self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode
            let wordHeight = (self.text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : self.font!, .paragraphStyle: paragraphStyle ], context: nil).height + self.textContainerInset.top + self.textContainerInset.bottom + self.textContainer.lineFragmentPadding * 2 + self.contentInset.top + self.contentInset.bottom
            let rect = CGRect(x: self.frame.minX, y: self.frame.minY, width: width, height: wordHeight)
            self.frame = rect
        }
    }
}

override var attributedText: NSAttributedString! {
    get {
        return super.attributedText
    }
    set {
        super.attributedText = newValue
        if !isAutoLayout {
            let width = self.bounds.width - (self.contentInset.left + self.contentInset.right + self.textContainerInset.left + self.textContainerInset.right + self.textContainer.lineFragmentPadding * 2)
            let wordHeight = newValue.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height + self.textContainerInset.top + self.textContainerInset.bottom + self.textContainer.lineFragmentPadding * 2 + self.contentInset.top + self.contentInset.bottom
            let rect = CGRect(x: self.frame.minX, y: self.frame.minY, width: width, height: wordHeight)
            self.frame = rect
        }
    }
}
```
* 判断屏幕点击事件是否在本视图,不是取消选中状态
```swift
// 设置点击空白取消选中效果
override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    // 判断点击点是否在本视图
    if !self.point(inside: point, with: event) {
        self.selectedRange = NSMakeRange(0, 0) // 设置为 NSMakeRange(0, 0) 取消选中效果
    }
    return super.hitTest(point, with: event)
}
```
[YTTCustomTextView](YTTCustomTextView.zip)



