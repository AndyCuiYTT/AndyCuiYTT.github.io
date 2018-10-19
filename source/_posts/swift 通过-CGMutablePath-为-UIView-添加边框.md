---
title: 通过 UIBezierPath 与 CAShapeLayer 为 UIView 添加边框
date: 2017-07-12 14:44:15
keywords: swift,UIBezierPath
categories:
    - iOS
    - 绘图
tags:
    - UIBezierPath
    - CAShapeLayer
---
 通过贝塞尔曲线与 CAShapeLayer 为 View 添加虚线边框,可设置宽度,颜色,圆角等
<!-- more -->

![效果图](17-7-12.png)
## 代码如下:
 ```swift
 	/// 为视图添加虚线边框
    ///
    /// - Parameters:
    ///   - view: 要添加边框的视图
    ///   - size: 视图 size
    ///   - cornerRadius: 视图圆角 默认:10
    ///   - lineWidth: 边框宽 默认: 1
    ///   - lineColor: 边框颜色 默认: black
    ///   - lineDashPattern: 边框段长和间距 默认: [5,3]
    func addBorderLine(view:UIView, size:CGSize, cornerRadius:CGFloat = 10, lineWidth:CGFloat = 1, lineColor:Color? = Color.black, lineDashPattern: [NSNumber] = [5,3]) -> Void {
        let shaplayer = CAShapeLayer()
        shaplayer.bounds = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        shaplayer.anchorPoint = CGPoint.init(x: 0, y: 0)
        shaplayer.fillColor = Color.clear.cgColor
        shaplayer.strokeColor = lineColor?.cgColor
        shaplayer.lineWidth = lineWidth
        shaplayer.lineJoin = "miter"
        shaplayer.lineDashPattern = [5,3]
        let path = CGMutablePath()
        path.move(to: CGPoint.init(x: lineWidth / 2, y: cornerRadius + lineWidth / 2))
        path.addArc(center: CGPoint.init(x: cornerRadius + lineWidth / 2, y: cornerRadius + lineWidth / 2), radius: cornerRadius, startAngle: .pi, endAngle: .pi / 2 * 3, clockwise: false)
        path.addLine(to: CGPoint.init(x: size.width - cornerRadius - lineWidth / 2, y: lineWidth / 2))
        path.addArc(center: CGPoint.init(x: size.width - cornerRadius - lineWidth / 2, y: cornerRadius + lineWidth / 2), radius: cornerRadius, startAngle: .pi / 2 * 3, endAngle: .pi * 2, clockwise: false)
        path.addLine(to: CGPoint.init(x: size.width - lineWidth / 2, y: size.height - cornerRadius - lineWidth / 2))
        path.addArc(center: CGPoint.init(x: size.width - cornerRadius - lineWidth / 2, y:  size.height - cornerRadius - lineWidth / 2), radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        path.addLine(to: CGPoint.init(x: cornerRadius + lineWidth / 2, y: size.height - lineWidth / 2))
        path.addArc(center: CGPoint.init(x: cornerRadius + lineWidth / 2, y:  size.height - cornerRadius - lineWidth / 2), radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
        path.addLine(to: CGPoint.init(x: lineWidth / 2, y: cornerRadius + lineWidth / 2))
        shaplayer.path = path
        view.layer.addSublayer(shaplayer)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
    }```
