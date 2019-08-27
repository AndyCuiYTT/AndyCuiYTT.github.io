---
title: iOS 实现电子签名
date: 2019-08-07 11:10:14
keywords:
- UIBezierPath
- 签名
- setNeedsDisplay
tags:
- UIBezierPath
- 签名
categories:
- iOS
- 绘图
description: 公司需求需要用户对用户协议进行在线签名,利用 UIBezierPath 绘制,转换为图片保存实现.
---
### 实现原理
1. 使用拖动手势记录获取用户签名路径.
2. 当用户初次接触屏幕,生成一个新的UIBezierPath,并加入数组中.设置接触点为起点.在手指拖动过程中为UIBezierPath添加线条,并重新绘制,生成连续的线.
3. 手指滑动中不断的重新绘制,形成签名效果.
4. 签名完成,转化为UIImage保存.
### [实现代码](CXGSignature.zip)
```swift
class CXGSignView: UIView {

    var path: UIBezierPath?
    var pathArray: [UIBezierPath] = []
    
    private var _signColor = UIColor.black
    private var _signWidth: CGFloat = 2
    var signColor: UIColor {
        get {
            return _signColor
        }
        set {
            _signColor = newValue
        }
    }
    
    var signWidth: CGFloat {
        get {
            return _signWidth
        }
        set {
            _signWidth = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupSubviews()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupSubviews() {

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.addGestureRecognizer(panGestureRecognizer)

    }

    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        // 获取当前点
        let currentPoint = sender.location(in: self)

        if sender.state == .began {
            self.path = UIBezierPath()
            path?.lineWidth = _signWidth
            path?.move(to: currentPoint)
            pathArray.append(path!)
        }else if sender.state == .changed {
            path?.addLine(to: currentPoint)
        }
        self.setNeedsDisplay()
    }

    // 根据 UIBezierPath 重新绘制
    override func draw(_ rect: CGRect) {

        for path in pathArray {
            // 签名颜色
            _signColor.set()
            path.stroke()
        }
    }

    // 清空
    func clearSign() {
        pathArray.removeAll()
        self.setNeedsDisplay()
    }

    // 撤销
    func undoSign() {
        guard pathArray.count > 0 else {
        return
    }
    pathArray.removeLast()
        self.setNeedsDisplay()
    }

    /// 签名转化为图片
    func saveSignToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
```
